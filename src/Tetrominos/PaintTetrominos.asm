;-----------------------------------------------------------------------------------------
; PAINTTETROMINOS - Paint a tetromino.
;	  IN - IX = Tetromino we want to paint.
;           B = Row of the screen in which we want to paint.
;           C = Column of the screen in which we want to paint.
;-----------------------------------------------------------------------------------------
PAINT:
    LD IX, T_T1
    LD IY, IX
    LD E, (IX)      ; Number of rows
    LD B, 1         ; Screen row
    INC IY: INC IY

OUTERLOOP:
    LD D, (IX + 1)  ; Number of columns olumns
    LD C, 1         ; Screen column

INNERLOOP:
    LD A, (IY)          ; A = Square
    INC IY              ; IY = Next square
    CP 0                ; Square = 0?
    JP NZ, PAINTLOOP   ; No - Paint
    INC C               ; Next column
    JP CHECKLOOPS       ; Yes - Check loop conditions

PAINTLOOP:
    PUSH DE
    CALL DOTYXC         ; Paint square
    POP DE
    INC C               ; Next column
CHECKLOOPS:
    LD A, D             ; A = D
    CP 0                ; Column = 0?
    DEC D               ; Column -= 1
    JP NZ, INNERLOOP    ; Yes - Paint
    INC B               ; Next row
    LD A, E             ; A = E
    CP 0                ; Row = 0?
    DEC E               ; Row -= 1
    JP NZ, OUTERLOOP    ; No - Loop
    RET
;-----------------------------------------------------------------------------------------
