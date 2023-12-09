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
; GENERATE_FIRST_TETROMINO - Save in TETROMINO_POINTER a pointer to the first tetromino.
;                      OUT - TETROMINO_POINTER = Pointer to current tetromino in play.
;-----------------------------------------------------------------------------------------
GENERATE_FIRST_TETROMINO:
    CALL RANDOM_NUMBER          ; Returns a random tetromino in the IX register
    LD (TETROMINO_POINTER), IX  ; Save pointer to TETROMINO_POINTER
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; GAME_TETROMINO - Paints a random tetromino in the game screen (row 1, column 15).
;             IN - TETROMINO_POINTER = Pointer to the tetromino we want to paint.
;-----------------------------------------------------------------------------------------
GAME_TETROMINO:
    LD A, 0             ; Screen row
    LD (ROWS), A        ; Save row
    LD (GAME_Y_POS), A  ; Save row to the GAME_STATUS_STRUCT

    LD A, 15           ; Screen column
    LD (COLUMNS), A    ; Save column
    LD (GAME_X_POS), A ; Save column to the GAME_STATUS_STRUCT

    LD A, (IX)           ; Tetromino height
    LD (PIECE_HEIGHT), A ; Save tetromino height

    LD IX, (TETROMINO_POINTER) ; IX = Pointer to the tetromino
    CALL PAINT_TETROMINO       ; Paint tetromino

TETROMINO_ACTIONS:
    CALL READ_ACTION_KEYS
    LD A, (PRESSED_KEY)
    CP 'Z'
    JP Z, MOVE_LEFT
    CP 'C'
    JP Z, MOVE_RIGHT
    JP TETROMINO_ACTIONS
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; GAME_TETROMINO - Save in NEXT_TETROMINO_POINTER a pointer to the next tetromino
;                  and paint it in the game screen (row 7, column 28).
;             IN - GAME_X_POS = Column where the current tetromino should be painted.
;                  GAME_Y_POS = Row where the the current tetromino should be painted.
;             OUT - NEXT_TETROMINO_POINTER = Pointer to the next tetromino.
;                   ROWS = Current tetromino row position.
;                   COLUMNS = Current tetromino column position.
;-----------------------------------------------------------------------------------------
GAME_NEXT_TETROMINO:
    PUSH AF
    CALL RANDOM_NUMBER ; Returns a random tetromino in the IX register
    LD (NEXT_TETROMINO_POINTER), IX ; Save pointer to the tetromino

    LD A, 7         ; Screen row for the next tetromino
    LD (ROWS), A    ; Save row for the next tetromino

    LD A, 28        ; Screen column for the next tetromino
    LD (COLUMNS), A ; Save column for the next tetromino

    CALL PAINT_TETROMINO ; Paint next tetromino

    LD A, (GAME_Y_POS) ; A = Row where the current tetromino should be painted.
    LD (ROWS), A       ; ROWS = Current tetromino row position

    LD A, (GAME_X_POS) ; A = Column where the current tetromino should be painted.
    LD (COLUMNS), A    ; COLUMNS = Current tetromino column position
    POP AF
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; MOVE_TETROMINO_DOWN - Moves the tetromino down until it reaches the bottom border.
;-----------------------------------------------------------------------------------------
MOVE_TETROMINO_DOWN:
    LD IX, (TETROMINO_POINTER) ; IX = Pointer to the tetromino
    CALL ERASE_TETROMINO       ; Erase tetromino
    LD A, (ROWS)               ; A = Rows
    INC A                      ; A = Rows + 1
    LD (ROWS), A               ; Save Rows
    LD (GAME_Y_POS), A         ; Save row to the GAME_STATUS_STRUCT

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
    LD (GAME_Y_POS), A
    CALL PAINT_TETROMINO ; Paint tetromino

    LD IX, (NEXT_TETROMINO_POINTER) ; IX = Pointer to the tetromino

    LD A, 7         ; Screen row
    LD (ROWS), A    ; Save row

    LD A, 28        ; Screen column
    LD (COLUMNS), A ; Save column

    CALL ERASE_TETROMINO

    LD (TETROMINO_POINTER), IX      ; Save pointer to the tetromino
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
    LD HL, 20000
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
