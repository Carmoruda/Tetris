;-----------------------------------------------------------------------------------------
; ERASE_TETROMINOS - Erase a tetromino.
;	  IN -  IX = Tetromino we want to ERASE.
;           ROWS = Row of the screen in which we want to ERASE.
;           COLUMNS = Column of the screen in which we want to ERASE.
;-----------------------------------------------------------------------------------------
ERASE_TETROMINO:
    LD E, (IX)      ; E = Number of rows
    LD A, (ROWS)    ; A = Row of the screen in which we want to erase
    LD B, A         ; B = Row of the screen in which we want to erase
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; ERASE_TETROMINO_OUTERLOOP - Loops through the rows of the tetromino.
;	  IN -  IX = Tetromino we want to ERASE.
;           B = Row of the screen in which we want to ERASE.
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
    DEC D                               ; Column -= 1
    JP NZ, ERASE_TETROMINO_INNERLOOP    ; If D != 0, inner loop
    INC B                               ; Next row
    LD A, E                             ; A = E
    CP 0                                ; Row = 0?
    DEC E                               ; Row = Row--
    JP NZ, ERASE_TETROMINO_OUTERLOOP    ; If E != 0, outer loop
    RET
;-----------------------------------------------------------------------------------------
