// Matthew Clayton & Ruben Gonzalez
// CS3B - Bin2Dec - validate.s
// 03/19/2025
// Validate the input string for valid characters. Scans the enitre
// string and checks for invalid chars.
//
// Pseudocode:
// 1. Initialize the result as valid output
// 2. Scan the input string one character at a time
// 3. If 'q' or 'Q' is encountered, return quit command
// 4. If 'c' or 'C' is encountered, return clear command
// 5. If character is '0', '1', store in a new buffer with valid input
// If a space, tab, or newline is encountered we skip (don't need)
// 6. When null is reached, return the valid input
//
//*********************************************************************

.global rg_validate

	.text				// code section
rg_validate:
	MOV   X1, #0		// Source index = 0
	MOV   X2, #0		// Destination index = 0
	LDR   X3, =binBuf	// Load the destination buffer

check_loop:
	LDRB   W4, [X0, X1] // Load char at inedex so we can traverse
	CMP    W4, #0		// End of string? (check for null terminator)
	B.EQ   finish_store	// If it is, we return the result
	
	// Check for Q's
	CMP    W4, #'q'		// Lowercase q?
	B.EQ   found_quit   // If found we return quit
	CMP    W4, #'Q'		// Uppercase Q?
	B.EQ   found_quit	// If found we return quit
	
	// Check for C's
	CMP    W4, #'c'		// Lowercase c?
	B.EQ   found_clear  // If found we return clear
	CMP    W4, #'C'		// Uppercase C?
	B.EQ   found_clear	// If found we return clear
	
	// If we have 16 valid digits, we stop storing but keep scanning
	CMP    X2, #16		// Store 16 bits already?
	B.GE   next_char	// If yes, ignore rest excpet for c or q
	
	// Check for valid 0 or 1 bits
	CMP    W4, #'0'		// Is it a 0?
	B.EQ   copy_digit	// Continue to scanning if its a valid 0
	CMP    W4, #'1'     // Is it a 1?
	B.EQ   copy_digit 	// Continue scanning if it's a valid 1
	
	// Check for space, tabs, and newlines
	//CMP    W4, #' '		// Is there a space?
	//B.EQ   check_loop	// Continue scanning if it's a space
	//CMP    W4, #9		// Is there a tab?
	//B.EQ   check_loop	// Continue scanning if it's a tab
	//CMP    W4, #10		// Is there a newline?
	//B.EQ   check_loop	// Continue scanning if it's a newline
	
	// Ignore if chars are invalid
	
copy_digit:
	STRB   W4, [X3, X2] // Store valid digit in buffer
	ADD    X2, X2, #1	// Increment stored digit count
	
next_char:
	ADD    X1, X1, #1   // Move to the next char 
	B	   check_loop	// Continue to scan

found_quit:
	MOV    W4, #0		// Null terminator
	STRB   W4, [X3, X2] // Terminate extracted string
	MOV    X0, #2		// X0 = 2 (wanting to exit)
	MOV    X1, X3		// Return buffer pointer
	RET					// Return to main prog. and exit
	
found_clear:
	MOV    W4, #0		// Null terminator
	STRB   W4, [X3, X2] // Terminate extracted string
	MOV    X0, #3		// X0 = 3 (Return clear command)
	MOV    X1, X3		// Return buffer pointer
	RET					// Return to main prog. and clear

finish_store:
	MOV    W4, #0		// Null terminator
	STRB   W4, [X3, X2] // Terminate extracted string
	MOV    X0, #1		// Our input is good by now and we return it
	MOV    X1, X3		// Return bufffer pointer
	RET


	.data
binBuf:    .skip  17	// 16 digits + null
	
	                                  
