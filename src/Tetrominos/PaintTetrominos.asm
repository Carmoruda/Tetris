;-----------------------------------------------------------------------------------------
; PAINT_TETROMINOS - Paint a tetromino.
;	  IN -  IX = Tetromino we want to paint.
;           ROWS = Row of the screen in which we want to paint.
;           COLUMNS = Column of the screen in which we want to paint.
;-----------------------------------------------------------------------------------------
PAINT_TETROMINO:
    LD IY, IX
    LD E, (IX)      ; Number of rows
    INC IY: INC IY
    LD A, (ROWS)
    LD B, A

PAINT_TETROMINO_OUTERLOOP:
    LD D, (IX + 1)  ; Number of columns
    LD A, (COLUMNS)
    LD C, A
PAINT_TETROMINO_INNERLOOP:
    LD A, (IY)                  ; A = Square
    INC IY                      ; IY = Next square
    CP 0                        ; Square = 0?
    JP NZ, PAINT_TETROMINO_LOOP ; No - Paint
    INC C                       ; Next column
    JP PAINT_TETROMINO_CHECK_LOOPS               ; Yes - Check loop conditions

PAINT_TETROMINO_LOOP:
    PUSH DE
    CALL DOTYXC         ; Paint square
    POP DE
    INC C               ; Next column
PAINT_TETROMINO_CHECK_LOOPS:
    LD A, D                             ; A = D
    CP 0                                ; Column = 0?
    DEC D                               ; Column -= 1
    JP NZ, PAINT_TETROMINO_INNERLOOP    ; Yes - Paint
    INC B                               ; Next row
    LD A, E                             ; A = E
    CP 0                                ; Row = 0?
    DEC E                               ; Row -= 1
    JP NZ, PAINT_TETROMINO_OUTERLOOP    ; No - Loop
    RET
;-----------------------------------------------------------------------------------------
