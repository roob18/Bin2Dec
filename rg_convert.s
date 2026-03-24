// Ruben Gonzalez
// CS3B - Bin2Dec - rg_convert.s
// 03/19/2025
// Convert a 16-bit binary string to two's complement into signed decimal
// value. The binary string is already sign extended to 16-bits before
// using this function.
//
// Pseudocode:
// 1. Initialize result to 0
// 2. Set power to 15
// 3. For each bit in the 16-bit binary string, do a loop:
//	  - if bit == '1'
//			result += 2^power
//	    power--
// 4. After building the valuem sign extend the 16-bit result
// 5. Return signed decimal value
// 6. Add a null terminator at the end of the extended binary string
//
//*********************************************************************

.global rg_convert		// start of rg_convert

	.text				// code section

rg_convert:
	MOV   X1, #0		// X1 = result
	MOV   X2, #0		// X2 = index
	MOV   X4, #15		// X4 = current power (2^15)
	
convert_loop:
	LDRB  W3, [X0, X2]	// Load current binary character
	CMP   W3, #'1'		// Check if the char is '1'
	B.NE  skip_add		// If not, skip adding to result
	
	MOV   X5, #1		// Start with value 1
	LSL   X5, X5, X4	// Copmuter the 2^power
	ADD   X1, X1, X5	// Add to reesult
	
skip_add:
	ADD   X2, X2, #1	// Move to next char
	SUB   X4, X4, #1	// Decrease power by 1
	
	CMP   X2, #16		// Have we gone through 16 bits?
	B.LT  convert_loop	// Continue if not done
	
	MOV   W0, W1		// Copy result
	SXTH  X0, W0		// Sign extend 16-bit value
	
	RET					// Return to main program
