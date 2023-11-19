; IX - Tetromino pointer
; Ancho EQU IC1 - IB0
PAINT:
    LD HL, 0x5800
    LD IX, T_0
    LD IY, IX
    LD E, (IX)      ; Rows
    INC IY: INC IY

OUTERLOOP:
    LD D, (IX + 1)  ; Columns

INNERLOOP:
    LD A, (IY)          ; A = Square
    INC IY              ; Next square
    CP 0                ; Square = 0
    JP NZ, PAINTLOOP2   ; If so, paint
    JP CHECKCOLUMNS     ; Else, skip

PAINTLOOP2:
    LD (HL), A          ; Paint
    INC HL              ; Next pixel
CHECKCOLUMNS:
    LD A, D             ; A = C
    CP 0                ; Column = 0?
    DEC D               ; Column -= 1
    JP NZ, INNERLOOP    ; Yes - Paint
    LD A, E
    CP 0
    DEC E
    JP NZ, OUTERLOOP
