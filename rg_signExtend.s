// Ruben Gonzalez
// CS3B - Bin2Dec - signExtend.s
// 03/19/2025
// Extend the binary string (after validate.s) to 16 bits using sign
// extension. If the binary string is shorter than 16 bits, the most 
// significant (msg) bit is extended to 16 bits.
//
// Pseudocode:
// 1. If the binary string is already 16 bits, we return the original string
// 2. Load the sign bit (msg of binary string)
// 3. Calculate the amount of bits that need to be filled
// 4. Fill the binary string with that sign bit
// 5. Copy the original binaryu digits after the filled bits
// 6. Add a null terminator at the end of the extended binary string
// 7. Return the new extended binary string 
//
//*********************************************************************
.global rg_signExtend

	.text				// code section

rg_signExtend:
	// *note that X2 has the length of the binary from validate.s
	CMP    X2, #16		// Check if binary string already 16 bits
	B.EQ   alr_ext		// If length is 16 bits, no extension needed
	
	LDRB   W1, [X0]		// Load first character of sign bit
	
	MOV   X3, #16		// X3 = 16
	SUB   X3, X3, X2	// X3 = Missing bits = 16 - currBitLength
	
	LDR   X4, =extBuf	// Load destination buffer address
	MOV   X5, #0		// Destination index for extended string
	
fill_loop:
	CMP   X5, X3		// Check if fill is complete
	B.EQ  copy_original // If we are done filling, copy original digits
	STRB  W1, [X4, X5]  // Store sign bit into extended buffer
	ADD   X5, X5, #1	// Increment index
	B     fill_loop		// Continue filling
	
copy_original:
	MOV   X6, #0		// Source index for original binary string
	
copy_loop:
	CMP   X6, X2		// Check if all original digits copied 
	B.EQ  finish_extend // If we finished copying og digits, fin. ext.
	LDRB  W7, [X0, X6]  // Load original binary digit
	STRB  W7, [X4, X5]	// Store digit in extended buffer
	ADD   X5, X5, #1	// Increment destination index
	ADD   X6, X6, #1	// Increment source index
	B	  copy_loop		// Continue to copy

finish_extend:
	MOV   W7, #0		// Null terminator
	STRB  W7, [X4, X5]  // Add null terminator
	MOV   X0, X4		// return pointer to extended buffer
	MOV   X2, #16 		// Return the caller
	
alr_ext:
	RET					// Return original pointer unchanged
	
	.data				// data section
extBuf:		.skip  17	// 16 bits + null
