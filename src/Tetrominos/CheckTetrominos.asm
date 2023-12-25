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
    LD A, (COLUMNS) ; A = Column of the screen in which we want to check if we can paint
    LD C, A         ; C = Column of the screen in which we want to check if we can paint
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
    CALL CHECK_DOTYXC               ; Check if we can paint the square
    POP DE
    LD A, (COLLISION)               ; A = Collision result
    CP 0                            ; Collision?
    JP NZ, COLLISION_DETECTED       ; Yes - Collision detected
    INC C                           ; Next column
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
    JP NO_COLLISION_DETECTED            ; If row = 0, then no collision detected
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; COLLISION_DETECTED - Adjust variables to the last position before the collision.
;     OUT - COLLISION = 1
;           ROWS = Row of the screen in which we must paint.
;           COLUMNS = Column of the screen in which we must paint.
;           GAME_Y_POS = Row of the screen in which we must paint (game struct).
;           GAME_X_POS = Column of the screen in which we must paint (game struct).
;-----------------------------------------------------------------------------------------
COLLISION_DETECTED:
    LD A, 1                     ; A = 1 - Collision detected
    LD (COLLISION), A           ; COLLISION = 1
    LD A, (GAME_Y_POS)          ; A = GAME_Y_POS = Previous row
    LD (ROWS), A                ; ROWS = A = Previous row
    LD A, (GAME_X_POS)          ; A = GAME_X_POS = Previous column
    LD (COLUMNS), A             ; COLUMNS = A = Previous column
    LD IX, (TETROMINO_POINTER)  ; IX = Previous tetromino
    CALL PAINT_TETROMINO        ; Paint the tetromino in the previous position
    JP END_CHECK_TETROMINO      ; End of the CHECK_TETROMINO routine
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; NO_COLLISION_DETECTED - Adjust variables to the new position.
;     OUT - COLLISION = 0
;           ROWS = Row of the screen in which we must paint.
;           COLUMNS = Column of the screen in which we must paint.
;           GAME_Y_POS = Row of the screen in which we must paint (game struct).
;           GAME_X_POS = Column of the screen in which we must paint (game struct).
;-----------------------------------------------------------------------------------------
NO_COLLISION_DETECTED:
    LD A, 0            ; A = 0 - No collision detected
    LD A, (ROWS)       ; A = ROWS = Row of the screen in which we must paint
    LD (GAME_Y_POS), A ; GAME_Y_POS = A = Row of the screen in which we must paint
    LD A, (COLUMNS)    ; A = COLUMNS = Column of the screen in which we must paint
    LD (GAME_X_POS), A ; GAME_X_POS = A = Column of the screen in which we must paint
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; END_CHECK_TETROMINO - End of the CHECK_TETROMINO routine.
;-----------------------------------------------------------------------------------------
END_CHECK_TETROMINO:
    POP BC
    POP AF
    RET
;-----------------------------------------------------------------------------------------
