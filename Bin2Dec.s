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
.text

_start:

main_loop:

    // -------------------------------------------------------------
    // Prompt user for binary number
    // -------------------------------------------------------------
    LDR     X0, =prompt
    BL      putstring

    // -------------------------------------------------------------
    // Read input string
    // -------------------------------------------------------------
    LDR     X0, =input_buffer
    MOV     X1, #64
    BL      getstring

    // -------------------------------------------------------------
    // Check if user entered Q or q to quit
    // -------------------------------------------------------------
    LDR     X0, =input_buffer
    LDRB    W1, [X0]

    CMP     W1, #'Q'
    B.EQ    program_exit

    CMP     W1, #'q'
    B.EQ    program_exit

    // -------------------------------------------------------------
    // Validate binary string
    // -------------------------------------------------------------
    LDR     X0, =input_buffer
    BL      rg_validate

    CMP     X0, #0
    B.EQ    invalid_input

    // -------------------------------------------------------------
    // Convert binary string ? integer value
    // -------------------------------------------------------------
    LDR     X1, =input_buffer
    MOV     X2, #0          // result accumulator

convert_loop:

    LDRB    W3, [X1], #1
    CMP     W3, #0
    B.EQ    conversion_done

    LSL     X2, X2, #1

    CMP     W3, #'1'
    B.NE    convert_loop

    ADD     X2, X2, #1
    B       convert_loop

conversion_done:

    MOV     X0, X2

    // -------------------------------------------------------------
    // Determine sign of number
    // -------------------------------------------------------------
    BL      determine_sign

    // -------------------------------------------------------------
    // Output the result
    // -------------------------------------------------------------
    BL      output_result

    B       main_loop


invalid_input:

    LDR     X0, =error_msg
    BL      putstring
    B       main_loop


program_exit:

    MOV     X0, #0
    MOV     X8, #93
    SVC     0


// -------------------------------------------------------------
// Data Section
// -------------------------------------------------------------
.data

prompt:
    .asciz "Enter 16-bit binary number (Q to quit): "

error_msg:
    .asciz "Invalid binary input.\n"

input_buffer:
    .skip   64
