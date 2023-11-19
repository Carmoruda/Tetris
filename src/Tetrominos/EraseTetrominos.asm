;-----------------------------------------------------------------------------------------
; ERASE_TETROMINOS - Erase a tetromino.
;	  IN -  IX = Tetromino we want to ERASE.
;           ROWS = Row of the screen in which we want to ERASE.
;           COLUMNS = Column of the screen in which we want to ERASE.
;-----------------------------------------------------------------------------------------
ERASE_TETROMINO:
    LD IY, IX
    LD E, (IX)      ; Number of rows
    INC IY: INC IY
    LD A, (ROWS)
    LD B, A

ERASE_TETROMINO_OUTERLOOP:
    LD D, (IX + 1)  ; Number of columns
    LD A, (COLUMNS)
    LD C, A
ERASE_TETROMINO_INNERLOOP:
    PUSH DE
    LD A, $00
    CALL DOTYXC         ; Erase square
    POP DE
    INC C               ; Next column
ERASE_TETROMINOS_CHECK_LOOPS:
    LD A, D                             ; A = D
    CP 0                                ; Column = 0?
    DEC D                               ; Column -= 1
    JP NZ, ERASE_TETROMINO_INNERLOOP    ; Yes - Erase
    INC B                               ; Next row
    LD A, E                             ; A = E
    CP 0                                ; Row = 0?
    DEC E                               ; Row -= 1
    JP NZ, ERASE_TETROMINO_OUTERLOOP    ; No - Loop
    RET
;-----------------------------------------------------------------------------------------
