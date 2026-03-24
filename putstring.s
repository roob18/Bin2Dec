// Ruben Gonzalez
// CS3B - Lab4-1, putstring, output string to console
// 01/29/2026
// Parameters: X0 - X3, X8
// Psuedocode: 
// 1) Retreive poiniter from main (driver4-1.s)
// 2) Save link register address (we will call another function and need to anchor)
// 3) Call String_length function to obtain the length of the string
// 4) Output the string
// 4) Return to caller (driver4-1.s)
.global putstring		// Provide program starting address

	.text				// code section
putstring: 
	MOV   X8, X0		// Put pointer to string into X8
	MOV   X3, X30		// Save the address of the link register
	
	BL    String_length // Retrieve the string length
	
	MOV   X2, X0		// Move the length stored in X0 to X2
	MOV   X0, #1		// STDOUT = 1 (move #1 into X0 register)
	MOV   X1, X8	    // Get address of char and load into X1
	
	MOV   X30, X3		// Restore the link register to return back to 
						// driver
	
	MOV   X8, #64		// Linux write system call
	SVC   0             // Call Linux to output string
	
	RET					// Return to caller

.end					// end of program
