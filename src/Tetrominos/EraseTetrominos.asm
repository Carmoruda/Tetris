;-----------------------------------------------------------------------------------------
; ERASE_TETROMINOS - Erase a tetromino.
;	  IN -  IX = Tetromino we want to erase.
;           ROWS = Row of the screen in which we want to erase.
;           COLUMNS = Column of the screen in which we want to erase.
;     OUT - IX = Tetromino we want to erase.
;           IY = Pointer to the first square of the tetromino.
;           B = Row of the screen in which we want to erase.
;           E = Number of rows.
;-----------------------------------------------------------------------------------------
ERASE_TETROMINO:
    PUSH AF
    PUSH BC
    LD IY, IX       ; IY = Tetromino we want to erase
    INC IY: INC IY  ; IY = Pointer to the first square of the tetromino
    LD E, (IX)      ; E = Number of rows
    LD A, (ROWS)    ; A = Row of the screen in which we want to erase
    LD B, A         ; B = Row of the screen in which we want to erase
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; ERASE_TETROMINO_OUTERLOOP - Loops through the rows of the tetromino.
;	  IN -  IX = Tetromino we want to erase.
;           B = Row of the screen in which we want to erase.
;           E = Number of rows.
;     OUT - IX = Tetromino we want to erase.
;           IY = Pointer to the first square of the tetromino.
;           B = Row of the screen in which we want to erase.
;           C = Column of the screen in which we want to erase.
;           D = Number of columns.
;           E = Number of rows.
;-----------------------------------------------------------------------------------------
ERASE_TETROMINO_OUTERLOOP:
    LD D, (IX + 1)  ; D = Number of columns
    LD A, (COLUMNS) ; A = Column of the screen in which we want to erase
    LD C, A         ; C = Column of the screen in which we want to erase
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; ERASE_TETROMINO_INNERLOOP - Loops through the columns of a row and erases the squares.
;	  IN -  B = Row of the screen in which we want to ERASE.
;           C = Column of the screen in which we want to ERASE.
;           D = Number of columns.
;           E = Number of rows.
;-----------------------------------------------------------------------------------------
ERASE_TETROMINO_INNERLOOP:
    LD A, (IY)                      ; A = Tetromino square
    INC IY                          ; IY = Next square
    CP 0                            ; Square = 0?
    JP NZ, ERASE_TETROMINO_LOOP     ; If square != 0 (has colour), erase square
    INC C                           ; Next column
    JP ERASE_TETROMINOS_CHECK_LOOPS ; Check loop conditions

;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; ERASE_TETROMINO_LOOP - Erase a square.
;	  IN - IX = Tetromino we want to erase.
;          IY = Pointer to the next square of the tetromino.
;          A = Color of the square.
;          B = Row of the screen in which we want to erase.
;          C = Column of the screen in which we want to erase.
;          D = Number of columns.
;          E = Number of rows.
;	  OUT - IX = Tetromino we want to erase.
;           IY = Pointer to the next square of the tetromino.
;           A = Color of the square.
;           B = Row of the screen in which we want to erase.
;           C = Next column of the screen in which we want to erase.
;           D = Number of columns.
;           E = Number of rows.
;-----------------------------------------------------------------------------------------
ERASE_TETROMINO_LOOP:
    PUSH DE
    LD A, $00           ; Attribute - Black foreground and black background
    CALL DOTYXC         ; Erase square
    POP DE
    INC C               ; Next column
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; ERASE_TETROMINOS_CHECK_LOOPS - Check if we have to continue erasing the tetromino.
;	  IN -  D = Number of columns.
;           E = Number of rows.
;-----------------------------------------------------------------------------------------
ERASE_TETROMINOS_CHECK_LOOPS:
    LD A, D                             ; A = D
    CP 0                                ; Column = 0?
    DEC D                               ; Column = Column--
    JP NZ, ERASE_TETROMINO_INNERLOOP    ; If D != 0, inner loop
    INC B                               ; Next row
    LD A, E                             ; A = E
    CP 0                                ; Row = 0?
    DEC E                               ; Row = Row--
    JP NZ, ERASE_TETROMINO_OUTERLOOP    ; If E != 0, outer loop
    POP BC
    POP AF
    RET
;-----------------------------------------------------------------------------------------
