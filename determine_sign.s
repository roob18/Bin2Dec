// Matthew Clayton & Ruben Gonzalez
// CS3B - Bin2Dec
// 3/24/2026
// Purpose: Determines whether the collected binary input represents a
//          positive or negative 16-bit two's complement value and applies
//          sign extension when fewer than 16 valid bits were entered.
//
// Algorithm/Pseudocode:
//     Input      : X0 = raw binary value built from valid entered bits
//                  X1 = number of valid bits in X0 (1 to 16)
//     Processing : If bit count is less than 1
//                      return 0 and sign flag 0
//                  If bit count is greater than 16
//                      treat bit count as 16
//                  Build a mask for the valid entered bits
//                  Remove any bits above the valid entered portion
//                  Find the first entered bit (the sign bit)
//                  Set sign flag based on that bit
//                  If sign bit is 1 and bit count is less than 16
//                      extend the value with 1s up through bit 15
//                  Mask result to 16 bits
//     Output     : X0 = normalized 16-bit value after sign extension
//                  X1 = sign flag (0 = positive, 1 = negative)

.global determine_sign
    .text

//*****************************************************************************
//determine_sign
//  Function determine_sign: Provided a raw binary value and its valid bit
//  count, will determine the sign of the entered two's complement value and
//  sign-extend it to a full 16-bit representation.
//
//  X0: Contains the raw binary value collected from Input.s
//      Valid bits are packed into the low-order portion of X0
//  X1: Contains the number of valid bits in X0 (expected range 1 to 16)
//
//  X0: Returns the normalized 16-bit value after sign extension
//  X1: Returns the sign flag (0 = positive, 1 = negative)
//
//  Registers X0 - X5 are modified and not preserved
//*****************************************************************************
determine_sign:
    MOV     X4, X1                      // set X4 to nBitCount working copy

    CMP     X4, #1                      // check if at least 1 valid bit exists
    B.GE    lblCheckUpperBound          // if valid count, continue

    MOV     X0, #0                      // return 0 value if no valid bits
    MOV     X1, #0                      // return positive sign flag
    RET                                 // return to caller

lblCheckUpperBound:
    CMP     X4, #16                     // compare bit count to 16
    B.LE    lblBuildCountMask           // if 16 or less, continue normally

    MOV     X4, #16                     // reduce any larger count down to 16

lblBuildCountMask:
    MOV     X5, #1                      // set X5 to 1
    LSLV    X5, X5, X4                  // set X5 to (1 << nBitCount)
    SUB     X5, X5, #1                  // set X5 to bit mask of valid bits

    AND     X0, X0, X5                  // keep only the valid entered bits

    SUB     X2, X4, #1                  // set X2 to sign bit position
    LSRV    X3, X0, X2                  // move sign bit down to bit 0
    AND     X3, X3, #1                  // isolate sign bit only

    MOV     X1, X3                      // return sign flag in X1

    CMP     X3, #0                      // check whether value is positive
    B.EQ    lblFinalize16BitValue       // if sign bit is 0, no 1-extension

    CMP     X4, #16                     // check whether already full width
    B.EQ    lblFinalize16BitValue       // if already 16 bits, no extension

    MOVZ    X5, #0xFFFF                 // set X5 to 0000...0000FFFF
    LSLV    X5, X5, X4                  // shift left by entered bit count
                                        // this creates 1s above valid bits
    ORR     X0, X0, X5                  // fill upper bits with 1s

lblFinalize16BitValue:
    MOVZ    X5, #0xFFFF                 // set X5 to final 16-bit mask
    AND     X0, X0, X5                  // keep only low 16 bits in result

    RET                                 // return to caller

.end                                    // end of file
