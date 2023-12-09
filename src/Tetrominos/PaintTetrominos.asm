;-----------------------------------------------------------------------------------------
; PAINT_TETROMINOS - Paint a tetromino.
;	  IN -  IX = Tetromino we want to paint.
;           ROWS = Row of the screen in which we want to paint.
;           COLUMNS = Column of the screen in which we want to paint.
;-----------------------------------------------------------------------------------------
PAINT_TETROMINO:
    LD IY, IX       ; IY = Tetromino we want to paint
    LD E, (IX)      ; Number of rows
    INC IY: INC IY  ; IY = Pointer to the first square
    LD A, (ROWS)    ; A = Row of the screen in which we want to paint
    LD B, A         ; B = Row of the screen in which we want to paint
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; PAINT_TETROMINO_OUTERLOOP - Loops through the rows of the tetromino.
;	  IN -  IX = Tetromino we want to paint.
;           IY = Pointer to the tetromino square we want to paint.
;           B = Row of the screen in which we want to paint.
;           E = Number of rows.
;-----------------------------------------------------------------------------------------
PAINT_TETROMINO_OUTERLOOP:
    LD D, (IX + 1)  ; Number of columns
    LD A, (COLUMNS)
    LD C, A
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; PAINT_TETROMINO_INNERRLOOP - Loops through the columns of a row and erases the squares.
;	  IN -  IY = Pointer to the tetromino square we want to paint
;           B = Row of the screen in which we want to paint.
;           D = Number of columns.
;           E = Number of rows.
;-----------------------------------------------------------------------------------------
PAINT_TETROMINO_INNERLOOP:
    LD A, (IY)                     ; A = Square
    INC IY                         ; IY = Next square
    CP 0                           ; Square = 0?
    JP NZ, PAINT_TETROMINO_LOOP    ; If square != 0 (has a colour), paint it.
    INC C                          ; Next column
    JP PAINT_TETROMINO_CHECK_LOOPS ; Check loop conditions
;-----------------------------------------------------------------------------------------


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
