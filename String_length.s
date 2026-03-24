// Ruben Gonzalez
// CS3B - String_length function
// Returns the length of a C-string
// 01/20/2026
// Parameters: X0 - X2
// Psuedocode:
// 1) Retrieve pointer to the string passed in X0
// 2) Copy the pointer into another register so we can move through the string
// 3) Initialize X0 to 0 to use as the string length counter
// 4) Loop through the string one character at a time
// 5) Load the current character from memory
// 6) If the character is the null terminator, exit the loop
// 7) Otherwise increment the length counter
// 8) Move to the next character in memory
// 9) Repeat the loop until null terminator is found
// 10) Return to the caller with the string length stored in X0

.global String_length	// Provide program starting address

	.text				// code section
String_length: 
	MOV   X1, X0		// Move the address of string into X2 register
	MOV   X0, #0		// Set X0 register to 0 to use for counter
	
loopStrL:
	LDRB   W2, [X1]		// load byte of string stored at X0 into X1
	CMP    W2, #0		// if we encounter 0, exit loop
	B.EQ   exit			// exiting loop
	ADD    X0, X0, #1	// increment the count (string length)
	ADD    X1, X1, #1   // increment pointer to char in memory
	B      loopStrL		// begin loop again

exit:
	RET					// Return to caller

.end					// end of program
