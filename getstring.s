// Ruben Gonzalez
// CS3B - Lab6-1 getstring
// Reads a string from the keyboard and stores it as a C-string
// 03/05/2026
//
//*****************************************************************************
//getstring
//  Function getstring: Will read a string of characters up to a specified length
//  from the console and save it in a specified buffer as a C-String (i.e. null
//  terminated).
//*****************************************************************************
//
// Pseudocode:
// 1) Save the original buffer pointer so X0 is preserved on return
// 2) Reserve 16 bytes on stack for one temporary input character
// 3) Compute the number of usable characters we may store:
//      usable = maxLength - 1
// 4) Read one character at a time from STDIN
// 5) If read fails or reaches EOF, stop reading
// 6) If the character is '\n', stop reading
// 7) If there is still room in the buffer, store the character and advance
// 8) If there is no more room, discard extra characters until '\n' or EOF
// 9) Null terminate the buffer
// 10) Restore X0 so it still points to the original buffer
// 11) Return to caller

.global getstring                 // Make function visible to linker

.text                             // code section

getstring:

    MOV   X3, X0                  // Save original buffer pointer
    MOV   X4, X0                  // X4 = current buffer pointer

    CMP   X1, #0                  // Check if max length is 0
    B.EQ  finish                  // If 0, return right away

    SUB   X5, X1, #1              // X5 = max chars we can store before null
    
read_loop:
    CMP   X5, #0                  // Check if buffer is full
    B.EQ  discard_loop            // If full, discard rest of line

    MOV   X0, #0                  // X0 = STDIN file descriptor
    MOV   X1, X4                  // X1 = current buffer address
    MOV   X2, #1                  // X2 = read 1 byte
    MOV   X8, #63                 // X8 = Linux read syscall
    SVC   0                       // Call Linux

    CMP   X0, #1                  // Check if 1 byte was read
    B.NE  null_term               // If not, stop reading

    LDRB  W6, [X4]                // Load the character we just read
    CMP   W6, #10                 // Check if character is newline
    B.EQ  null_term               // If newline, stop reading

    ADD   X4, X4, #1              // Move to next buffer position
    SUB   X5, X5, #1              // One less character can be stored
    B     read_loop               // Read next character

    
discard_loop:
    MOV   X0, #0                  // X0 = STDIN file descriptor
    LDR   X1, =tempChar           // X1 = address of temp byte
    MOV   X2, #1                  // X2 = read 1 byte
    MOV   X8, #63                 // X8 = Linux read syscall
    SVC   0                       // Call Linux

    CMP   X0, #1                  // Check if 1 byte was read
    B.NE  null_term               // If not, stop reading

    LDRB  W6, [X1]                // Load discarded character
    CMP   W6, #10                 // Check if discarded char is newline
    B.NE  discard_loop            // If not newline, keep discarding
    
null_term:
    MOV   W6, #0                  // W6 = null terminator
    STRB  W6, [X4]                // Store null terminator

finish:
    MOV   X0, X3                  // Restore original buffer pointer
    RET                           // Return to caller

.data                             // Data section

tempChar: .byte 0                 // Temporary byte for extra input

.end                              // End of getstring
