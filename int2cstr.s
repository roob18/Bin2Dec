// Ruben Gonzalez
// CS3B - Lab5-2 int2cstr
// Converts signed integer in X0 into C-string at buffer pointed to by X1
// 02/10/2026
//
// Pseudocode:
// 1) Save starting buffer pointer
// 2) If number == 0 -> store "0" and return
// 3) If number > 0 -> remember sign and make negative
// 4) Loop:
//      quotient  = number / 10
//      remainder = number - quotient*10
//      digit     = -remainder
//      convert digit to ASCII
//      store digit
//      number = quotient
// 5) If original was positive - append '-'
// 6) Reverse string in place
// 7) Append null terminator
// 8) Return

.global int2cstr

    .text                  // code section
int2cstr:
	// Save start of buffer
	MOV   X7, X1		   // X7 = address of buffer
	
	// Check if our number is 0
	CMP   X0, #0		   // Compare to 0
	B.NE  checkSign		   // if not zero, check the sign of the number
	
	// Else, Store ASCII '0'
	MOV   W4, #'0'		   // W4 = '0'
	STRB  W4, [X1]		   // Store '0' in buffer
	ADD   X1, X1, #1	   // pointer++
	
	// Store null terminator
	MOV   W4, #0		   // W4 = 0 
	STRB  W4, [X1]		   // Store null 
	
	
	MOV   X0, X7		   // return start of pointer in X0
	
	// Done for 0 case
	RET					   // return to caller
	
checkSign:
    //--------------------------------------------------
    // Decide which path: positive or negative
    // X6 will be sign flag: 0 = no '-', 1 = prepend '-'
    //--------------------------------------------------
    MOV     X6, #0              // X6 = 0 by default (assume non-negative)
    CMP     X0, #0              // compare to 0
    B.GT    posSetup            // if > 0, go to positive path
    B.LT    negSetup            // if < 0, go to negative path
    // (== 0 never happens here because handled above)
    
posSetup:
    //--------------------------------------------------
    // Positive number:
    //   - keep X0 positive
    //   - no '-' sign
    //--------------------------------------------------
    MOV     X2, #10             // X2 = 10 (divisor)
    B       remLoopPos          // jump into positive remainder loop

negSetup:
    //--------------------------------------------------
    // Negative number:
    //   - keep X0 negative (important for min-int)
    //   - set sign flag so we add '-' later
    //--------------------------------------------------
    MOV     X6, #1              // X6 = 1 (we need '-' in final string)
    MOV     X2, #10             // X2 = 10 (divisor)
    B       remLoopNeg          // jump into negative remainder loop

// Positive number loop
remLoopPos:
    CMP     X0, #0              // while X0 != 0
    B.EQ    digitsDone          // if done, exit digit loop

    SDIV    X3, X0, X2          // X3 = quotient = X0 / 10
    MSUB    X4, X3, X2, X0      // X4 = X0 - (X3 * X2) = remainder (0..9)

    ADD     W5, W4, #'0'        // W5 = ASCII digit ('0' + remainder)

    STRB    W5, [X1]            // store digit byte into buffer
    ADD     X1, X1, #1          // advance buffer pointer

    MOV     X0, X3              // X0 = quotient for next loop
    B       remLoopPos          // repeat

	
// Negative number digit extraction loop
// X0 is negative, quotient and remainder also negative.
// We flip the remainder to turn it into a positive digit.
remLoopNeg:
    CMP     X0, #0              // while X0 != 0
    B.EQ    digitsDone          // if done, exit digit loop

    SDIV    X3, X0, X2          // X3 = quotient = X0 / 10 (still negative)
    MSUB    X4, X3, X2, X0      // X4 = X0 - (X3 * X2) = negative remainder
    NEG     X4, X4              // X4 = -remainder (0..9)

    ADD     W5, W4, #'0'        // W5 = ASCII digit ('0' + digit)

    STRB    W5, [X1]            // store digit byte into buffer
    ADD     X1, X1, #1          // advance buffer pointer

    MOV     X0, X3              // X0 = quotient for next loop
    B       remLoopNeg          // repeat

digitsDone:
    // If original number was negative, append '-'
    CMP     X6, #0              // check sign flag
    B.EQ    prepareReverse      // if 0, skip adding '-'

    MOV     W4, #'-'            // ASCII '-'
    STRB    W4, [X1]            // store '-' at end of current buffer
    ADD     X1, X1, #1          // advance buffer pointer
    
prepareReverse:
    //--------------------------------------------------
    // IN THIS PART:
    //   - X7 = start of buffer
    //   - X1 = one past last character
    //   - characters are stored in reverse order
    //--------------------------------------------------
    SUB     X3, X1, #1          // X3 = end pointer (last character)
    MOV     X2, X7              // X2 = start pointer

reverseLoop:
    CMP     X2, X3              // while start < end
    B.GE    finishString        // if start >= end, reversing is done

    LDRB    W4, [X2]            // W4 = *start
    LDRB    W5, [X3]            // W5 = *end

    STRB    W5, [X2]            // *start = old end char
    STRB    W4, [X3]            // *end   = old start char

    ADD     X2, X2, #1          // start++
    SUB     X3, X3, #1          // end--
    B       reverseLoop         // repeat until middle

finishString:

    // Append null terminator
    MOV     W4, #0              // null byte
    STRB    W4, [X1]            // store null

    // Return pointer to string
    MOV     X0, X7              // return start address
    RET							// return to caller



.end                    // end of function

