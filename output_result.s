// Matthew Clayton & Ruben Gonzalez
// CS3B - Bin2Dec
// 3/24/2026
// Purpose: Outputs the decimal conversion result for the Bin2Dec project.
//          This function prints the arrow prompt, prints a '+' sign for
//          non-negative values, converts the signed decimal value to a
//          C-String, then prints the decimal result followed by a newline.
//
// Algorithm/Pseudocode:
//     Input      : X0 = signed decimal value to output
//     Processing : Save preserved registers and LR
//                  Save the decimal value
//                  Output the arrow string
//                  If decimal value is greater than or equal to 0
//                      output '+' character
//                  Convert the decimal value to a C-String
//                  Output the converted decimal string
//                  Output a newline
//                  Restore preserved registers and return
//     Output     : Displays "->" followed by signed decimal value and newline

    .global output_result
    .text

//*****************************************************************************
//output_result
//  Function output_result: Provided a signed decimal value in X0, will
//  display the arrow prompt followed by the signed decimal value and a
//  newline. A '+' sign is displayed for non-negative values. Negative
//  values keep their '-' sign from int2cstr.
//
//  X0: Contains the signed decimal value to be displayed
//  LR: Must contain the return address (automatic when BL is used)
//
//  Output format:
//      ->+<decimal value>\n   for non-negative values
//      ->-<decimal value>\n   for negative values
//*****************************************************************************
output_result:
    STP     X29, X30, [SP, #-48]!        // save FP and LR, allocate stack frame
    MOV     X29, SP                      // establish frame pointer

    STP     X19, X20, [SP, #16]          // save preserved registers
    STR     X21, [SP, #32]               // save preserved register

    MOV     X19, X0                      // set X19 to qDecimalValue

    LDR     X0, =szArrow                 // set X0 to pointer to arrow string
    BL      putstring                    // output "->"

    CMP     X19, #0                      // compare decimal value to 0
    B.LT    lblConvertAndPrint           // if negative, skip '+' output

    LDR     X0, =szPlus                  // set X0 to pointer to plus string
    BL      putstring                    // output '+'

lblConvertAndPrint:
    MOV     X0, X19                      // set X0 to decimal value
    LDR     X1, =szDecimalBuffer         // set X1 to decimal output buffer
    BL      int2cstr                     // convert signed integer to C-String

    LDR     X0, =szDecimalBuffer         // set X0 to pointer to decimal string
    BL      putstring                    // output decimal string

    LDR     X0, =szNewLine               // set X0 to pointer to newline string
    BL      putstring                    // output newline

    LDR     X21, [SP, #32]               // restore preserved register
    LDP     X19, X20, [SP, #16]          // restore preserved registers

    LDP     X29, X30, [SP], #48          // restore FP/LR and deallocate stack
    RET                                  // return to caller

    .data

szArrow:
    .asciz  "->"                         // arrow output string

szPlus:
    .asciz  "+"                          // plus sign output string

szNewLine:
    .asciz  "\n"                         // newline output string

szDecimalBuffer:
    .skip   24                           // buffer for int2cstr output

.end                                     // end of file
