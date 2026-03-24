//*****************************************************************************
// Ruben Gonzalez
// CS3B  Bin2Dec Driver
// 03/24/2026
//
// Driver program for the Binary ? Decimal conversion project.
//
// Prompts the user to enter a binary string, validates the string,
// converts it to a 16-bit two's complement integer, and prints the
// decimal result.
//
// Pseudocode:
// 1. Display prompt asking for binary input.
// 2. Read input string using getstring.
// 3. If user enters Q/q -> quit program.
// 4. Validate the binary string using rg_validate.
// 5. If invalid -> display error and restart loop.
// 6. Convert binary string into raw 16-bit value.
// 7. Call determine_sign to determine if number is negative.
// 8. Convert to signed decimal.
// 9. Call output_result to display result.
// 10. Repeat until user quits.
//*****************************************************************************

.global _start
    .text                       // code section

_start:

// -------------------------------------------------------------
// System Call Exit
// -------------------------------------------------------------
.EQU SYS_exit, 93				// Linux exit()

main_loop:

    // -------------------------------------------------------------
    // Prompt user for binary number
    // -------------------------------------------------------------
    LDR     X0, =prompt         // Load address of prompt string
    BL      putstring           // Output prompt to console

    // -------------------------------------------------------------
    // Read input string
    // -------------------------------------------------------------
    LDR     X0, =input_buffer   // Load address of prompt string
    MOV     X1, #64             // Set the max buffer length
    BL      getstring           // Read the string from keyboard

    // -------------------------------------------------------------
    // Validate the input and get valid binary string
    //
    // rg_validate returns: 
    //     1 = valid input
    //     2 = quit command
    //     3 = clear command
    // X1 = pointer to new binary string (valid)
    // X2 = number of valid binary digits collected (length if new string)
    // -------------------------------------------------------------
    LDR    X0, =input_buffer    // Load pointer to input buffer
    BL     rg_validate          // Call validation function
    
    // -------------------------------------------------------------
    // Check if user entererd quit command
    // -------------------------------------------------------------
    CMP   X0, #2                // Is there a quit command?
    B.EQ  program_exit          // If yes, exit program
    
    // -------------------------------------------------------------
    // Check if user entered clear command
    // -------------------------------------------------------------
    CMP   X0, #3                // Is there a clear commmand?
    B.EQ  main_loop             // Restart the main_loop
    
    // -------------------------------------------------------------
    // Check if no valid binary digits were entered
    // -------------------------------------------------------------
    CMP   X2, #0                // Check number of valid digits
    B.EQ  main_loop             // If no valid digits prompt again
    
    // -------------------------------------------------------------
    MOV   X0, X1                // Move the new binary string pointer to X0  
    
    // -------------------------------------------------------------
    // Sign extend binary string to full 16 bits
    // -------------------------------------------------------------
    BL    rg_signExtend         // extened binary string to 16 bits
    
    // -------------------------------------------------------------
    // Convert 16 bit binary string to signed decimal value
    // -------------------------------------------------------------
    BL    rg_convert            // Convert binary string to decmial
    
    // -------------------------------------------------------------
    // Output the decimal result
    // -------------------------------------------------------------
    BL    output_result          // Print arrow and decmial value
    
    // -------------------------------------------------------------
    // Prompt user for input again and start new input
    // -------------------------------------------------------------
    B   main_loop               // Repeat main program loop

// -------------------------------------------------------------
// Exit the program
// -------------------------------------------------------------
program_exit:

    MOV     X0, #0
    MOV     X8, #SYS_exit
    SVC     0


// -------------------------------------------------------------
// Data Section
// -------------------------------------------------------------
.data
// input prompt string
prompt:        .asciz "Enter 16-bit binary number (Q to quit): "

input_buffer:  .skip   64       // buffer for user input string
