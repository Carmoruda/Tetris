;-----------------------------------------------------------------------------------------
; GAMESCREEN - Selects the row for the first U border square and calls the TETRIS_3D
;              routine.
;-----------------------------------------------------------------------------------------
GAMESCREEN:
    CALL CLEARSCR   ; Clean screen.
    CALL TETRIS_3D  ; Paint the 3D Tetris effect
    LD B, 1         ; Row
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; VERTICAL_BORDER - Display the U vertical sides.
;-----------------------------------------------------------------------------------------
VERTICAL_BORDER:
    LD C, 6     ; Column
    LD A, $38   ; Square color (hex) -> White
    CALL DOTYXC ; Paint square

    PUSH AF
    LD A, C          ; A = Column
    ADD TETRIS_WIDTH ; A = Column + TETRIS_WIDTH
    LD C, A          ; C = Column + TETRIS_WIDTH
    POP AF

    CALL DOTYXC            ; Paint square
    LD A, B                ; A = Row
    INC B                  ; B = Row + 1
    CP TETRIS_HEIGHT
    JR NZ, VERTICAL_BORDER ; If Row < TETRIS_HEIGHT, repeat

    LD C, 6     ; Column
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; HORIZONTAL_BORDER - Display the U bottom side.
;-----------------------------------------------------------------------------------------
HORIZONTAL_BORDER:
    LD A, $38   ; Square color (hex) -> White
    CALL DOTYXC ; Paint square

    LD A, C                  ; A = Column
    INC C                    ; C = Column + 1
    CP TETRIS_MAX_WIDTH
    JR NZ, HORIZONTAL_BORDER ; If Column < TETRIS_MAX_WIDTH, repeat
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; GAME_TETROMINO - Paints a random tetromino in the game screen (row 1, column 15).
;-----------------------------------------------------------------------------------------
GAME_TETROMINO:
    CALL RANDOM_NUMBER ; Returns a random tetromino in the IX register.
    LD (TETROMINO_POINTER), IX

    LD A, 0         ; Screen row
    LD (ROWS), A    ; Save row

    LD A, 15        ; Screen column
    LD (COLUMNS), A ; Save column

    LD A, (IX)           ; Tetromino height
    LD (PIECE_HEIGHT), A ; Save tetromino height

    CALL PAINT_TETROMINO ; Paint tetromino
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; MOVE_TETROMINO_DOWN - Moves the tetromino down until it reaches the bottom border.
;-----------------------------------------------------------------------------------------
MOVE_TETROMINO_DOWN:
    CALL ERASE_TETROMINO ; Erase tetromino
    LD A, (ROWS)         ; A = Rows
    INC A                ; A = Rows + 1
    LD (ROWS), A         ; Save Rows

    PUSH AF
    CALL PAINT_TETROMINO ; Paint tetromino
    CALL DELAY           ; Time delay
    LD A, (PIECE_HEIGHT) ; A = Tetromino height
    LD B, A              ; B = Tetromino height
    LD A, 21             ; A = 21
    SUB B                ; A = 21 - Tetromino height
    LD B, A              ; B = 21 - Tetromino height
    POP AF

    CP B
    JR NZ, MOVE_TETROMINO_DOWN ; If A != B, repeat

    CALL ERASE_TETROMINO ; Erase tetromino
    LD A, (ROWS)         ; A = Rows
    INC A                ; A = Rows + 1
    LD (ROWS), A         ; Save Rows
    CALL PAINT_TETROMINO ; Paint tetromino
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; GAMELOOP - Game simulation.
;-----------------------------------------------------------------------------------------
GAMELOOP:
    JP GAME_TETROMINO
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; DELAY - Time delay.
;-----------------------------------------------------------------------------------------
DELAY:
    LD HL, 10000
DELAY_LOOP:
    DEC HL            ; HL = HL--
    LD A, H           ; A = H
    OR 0
    JR NZ, DELAY_LOOP ; If HL != 0, repeat
    RET
;-----------------------------------------------------------------------------------------


; -------- VARIABLES -------
TETRIS_WIDTH EQU 19     ; Space between the U borders.
TETRIS_MAX_WIDTH EQU 25 ; Last column of the U borders.
TETRIS_HEIGHT EQU 21   ; Last row of the U borders.
PIECE_HEIGHT: DB 0     ; Tetromino height.
GAMEMESSAGE: DB "GAME", 0
