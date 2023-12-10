;-----------------------------------------------------------------------------------------
; CHECK_TETROMINO - Check a position to see if a tetromino can be painted there.
;	  IN -  IX = Tetromino we want to check.
;           ROWS = Row of the screen in which we want to paint.
;           COLUMNS = Column of the screen in which we want to paint.
;     OUT - IX = Tetromino we want to paint.
;           IY = Pointer to the first square of the tetromino.
;           B = Row of the screen in which we want to paint.
;           E = Number of rows.
;-----------------------------------------------------------------------------------------
CHECK_TETROMINO:
    PUSH AF
    PUSH BC
    LD IY, IX       ; IY = Tetromino we want to paint
    LD E, (IX)      ; Number of rows
    INC IY: INC IY  ; IY = Pointer to the first square
    LD A, (ROWS)    ; A = Row of the screen in which we want to paint
    LD B, A         ; B = Row of the screen in which we want to paint
    INC B
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; PAINT_TETROMINO_OUTERLOOP - Loops through the rows of the tetromino.
;	  IN -  IX = Tetromino we want to paint.
;           IY = Pointer to the tetromino square we want to paint.
;           B = Row of the screen in which we want to paint.
;           E = Number of rows.
;     OUT - IX = Tetromino we want to paint.
;           IY = Pointer to the first square of the tetromino.
;           B = Row of the screen in which we want to paint.
;           C = Column of the screen in which we want to paint.
;           D = Number of columns.
;           E = Number of rows.
;-----------------------------------------------------------------------------------------
CHECK_TETROMINO_OUTERLOOP:
    LD D, (IX + 1)  ; Number of columns
    LD A, (COLUMNS)
    LD C, A
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; PAINT_TETROMINO_INNERRLOOP - Loops through the columns of a row and erases the squares.
;	  IN -  IX = Tetromino we want to paint.
;           IY = Pointer to the first square of the tetromino.
;           B = Row of the screen in which we want to paint.
;           C = Column of the screen in which we want to paint.
;           D = Number of columns.
;           E = Number of rows.
;	  OUT - IX = Tetromino we want to paint.
;           IY = Pointer to the next square of the tetromino.
;           A = Color of the square.
;           B = Row of the screen in which we want to paint.
;           C = Column of the screen in which we want to paint.
;           D = Number of columns.
;           E = Number of rows.
;-----------------------------------------------------------------------------------------
CHECK_TETROMINO_INNERLOOP:
    LD A, (IY)                     ; A = Square
    INC IY                         ; IY = Next square
    CP 0                           ; Square = 0?
    JP NZ, CHECK_TETROMINO_LOOP    ; If square != 0 (has a colour), paint it.
    INC C                          ; Next column
    JP CHECK_TETROMINO_CHECK_LOOPS ; Check loop conditions
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; PAINT_TETROMINO_LOOP - Paints a square.
;	  IN - IX = Tetromino we want to paint.
;          IY = Pointer to the next square of the tetromino.
;          A = Color of the square.
;          B = Row of the screen in which we want to paint.
;          C = Column of the screen in which we want to paint.
;          D = Number of columns.
;          E = Number of rows.
;	  OUT - IX = Tetromino we want to paint.
;           IY = Pointer to the next square of the tetromino.
;           A = Color of the square.
;           B = Row of the screen in which we want to paint.
;           C = Next column of the screen in which we want to paint.
;           D = Number of columns.
;           E = Number of rows.
;-----------------------------------------------------------------------------------------
CHECK_TETROMINO_LOOP:
    PUSH DE
    CALL CHECK_DOTYXC
    POP DE
    LD A, (COLLISION)
    CP 0
    JP NZ, COLLISION_DETECTED
    INC C               ; Next column
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; PAINT_TETROMINO_CHECK_LOOPS - Checks if we have to continue looping.
;    IN - IX = Tetromino we want to paint.
;         IY = Pointer to the next square of the tetromino.
;         B = Row of the screen in which we want to paint.
;         C = Column of the screen in which we want to paint.
;         D = Number of columns.
;         E = Number of rows.
;   OUT - IX = Tetromino we want to paint.
;         IY = Pointer to the next square of the tetromino.
;         C = Column of the screen in which we want to paint.
;         B = Next row of the screen in which we want to paint.
;         D = Number of columns.
;         E = Number of rows.
;-----------------------------------------------------------------------------------------
CHECK_TETROMINO_CHECK_LOOPS:
    LD A, D                             ; A = D
    CP 0                                ; Column = 0?
    DEC D                               ; Column--
    JP NZ, CHECK_TETROMINO_INNERLOOP    ; Yes - Paint
    INC B                               ; Next row
    LD A, E                             ; A = E
    CP 0                                ; Row = 0?
    DEC E                               ; Row--
    JP NZ, CHECK_TETROMINO_OUTERLOOP    ; No - Loop
    JP NO_COLLISION_DETECTED

COLLISION_DETECTED:
    LD A, 1
    LD (COLLISION), A
    LD A, (GAME_Y_POS)
    LD (ROWS), A
    LD A, (GAME_X_POS)
    LD (COLUMNS), A
    CALL PAINT_TETROMINO
    JP END_CHECK_TETROMINO

NO_COLLISION_DETECTED:
    LD A, 0
    LD A, (ROWS)
    LD (GAME_Y_POS), A
    LD A, (COLUMNS)
    LD (GAME_X_POS), A

END_CHECK_TETROMINO:
    POP BC
    POP AF
    RET
;-----------------------------------------------------------------------------------------
