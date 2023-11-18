; IX - Tetromino pointer
; Ancho EQU IC1 - IB0
PAINT:
    LD HL, 0x5800
    LD IX, T_0
    LD B, (IX)      ; Rows
    LD C, (IX + 1)  ; Columns
    INC IX: INC IX

PAINTLOOP:
    LD A, (IX)          ; A = Square
    INC IX              ; Next square
    CP 0                ; Square = 0
    JP NZ, PAINTLOOP2   ; If so, paint
    JP CHECKCOLUMNS        ; Else, skip

PAINTLOOP2:
    LD (HL), A          ; Paint
    INC HL              ; Next pixel
CHECKCOLUMNS:
    LD A, C             ; A = C
    CP 0                ; Column = 0?
    DEC C               ; Column -= 1
    JP NZ, PAINTLOOP    ; Yes - Paint
    INC HL              ; No - Next square
    DJNZ PAINTLOOP      ; Next square
