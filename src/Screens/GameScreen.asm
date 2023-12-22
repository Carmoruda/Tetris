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
    ;CALL RANDOM_NUMBER          ; Returns a random tetromino in the IX register
    LD IX, T_S1
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
    CALL CHECK_TETROMINO       ; Check if the tetromino can be painted

    LD A, (COLLISION)          ; A = COLLISION
    CP 0
    JP NZ, COLLISION_ACTION_END    ; If A != 0 (No collision), jump to COLLISION_ACTION

    CALL PAINT_TETROMINO       ; Paint tetromino
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; GAME_NEXT_TETROMINO - Save in NEXT_TETROMINO_POINTER a pointer to the next tetromino
;                  and paint it in the game screen (row 7, column 28).
;             IN - GAME_X_POS = Column where the current tetromino should be painted.
;                  GAME_Y_POS = Row where the the current tetromino should be painted.
;             OUT - NEXT_TETROMINO_POINTER = Pointer to the next tetromino.
;                   ROWS = Current tetromino row position.
;                   COLUMNS = Current tetromino column position.
;-----------------------------------------------------------------------------------------
GAME_NEXT_TETROMINO:
    PUSH AF
    PUSH IX
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
    POP IX
    POP AF
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; MODIFY_DELAY_TIME - Modify the delay time until the threshold is reached.
;-----------------------------------------------------------------------------------------
MODIFY_DELAY_TIME:
    LD A, (DELAY_DOWN_MIN)  ; A = DELAY_DOWN_MIN = 50
    LD B, A                 ; B = DELAY_DOWN_MIN = 50

    LD A, (DELAY_DOWN)      ; A = DELAY_DOWN = 1000
    CP B                    ; If DELAY_DOWN == DELAY_DOWN_MIN
    JP Z, TETRIS_ACTION     ; Go to TETRIS_ACTION
    SUB 100                 ; Else DELAY_DOWN = DELAY_DOWN - 50
    LD (DELAY_DOWN), A      ; Save DELAY_DOWN

    LD A, (DELAY_MOVE_MIN)  ; A = DELAY_MOVE_MIN = 100
    LD B, A                 ; B = DELAY_MOVE_MIN = 100

    LD A, (DELAY_MOVE)      ; A = DELAY_MOVE = 3500
    CP B                    ; If DELAY_MOVE == DELAY_MOVE_MIN
    JP Z, TETRIS_ACTION     ; Go to TETRIS_ACTION
    SUB 100                 ; Else DELAY_MOVE = DELAY_MOVE - 100
    LD (DELAY_MOVE), A      ; Save DELAY_MOVE
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; TETRIS_ACTION - Controls tetrominos rotation and movement.
;-----------------------------------------------------------------------------------------
TETRIS_ACTION:
    LD HL, (DELAY_MOVE)     ; HL = DELAY_MOVE = 3500
    LD (ACTIVE_DELAY), HL   ; ACTIVE_DELAY = HL = 3500
    CALL DELAY              ; Time delay

    LD A, (PRESSED_KEY)          ; A = PRESSED_KEY
    CP 'Z'                       ; If PRESSED_KEY == 'Z'
    JP Z, MOVE_TETROMINO_LEFT    ; Move tetromino to the left
    CP 'C'                       ; If PRESSED_KEY == 'C'
    JP Z, MOVE_TETROMINO_RIGHT   ; Move tetromino to the right
    CP 'J'                       ; If PRESSED_KEY == 'J'
    JP Z, ROTATE_TETROMINO_LEFT  ; Rotate tetromino to the left
    CP 'L'                       ; If PRESSED_KEY == 'L'
    JP Z, ROTATE_TETROMINO_RIGHT ; Rotate tetromino to the right
    ;CP 'E'
    ;JP Z, MOVE_TETROMINO_FAST

    LD A, 0
    LD (PRESSED_KEY), A          ; PRESSED_KEY = 0
    CALL MOVE_TETROMINO_DOWN     ; Move tetromino down
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; NEXT_TETROMINO - Erases the current next tetromino and changes the TETROMINO_POINTER
;                  to point to the next tetromino.
;             IN - NEXT_TETROMINO_POINTER = Pointer to the next tetromino.
;             OUT - TETROMINO_POINTER = Pointer to the new currecnt tetromino.
;-----------------------------------------------------------------------------------------
NEXT_TETROMINO:
    LD IX, (NEXT_TETROMINO_POINTER) ; IX = Pointer to the tetromino

    LD A, 7         ; Screen row
    LD (ROWS), A    ; Save row

    LD A, 28        ; Screen column
    LD (COLUMNS), A ; Save column

    CALL ERASE_TETROMINO       ; Erase tetromino
    LD (TETROMINO_POINTER), IX ; Save pointer to the tetromino
    JP GAME_TETROMINO
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; COLLISION_ACTION - When a collision is detected, the tetromino is painted in its
;                    previous position and the next tetromino is generated.
;-----------------------------------------------------------------------------------------
COLLISION_ACTION:
    CALL PAINT_TETROMINO
    CALL NEXT_TETROMINO
;-----------------------------------------------------------------------------------------

COLLISION_ACTION_END:
    CALL ENDINGSCREEN

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
    LD HL, (ACTIVE_DELAY)
DELAY_LOOP:
    CALL READ_ACTION_KEYS   ; Check if a key has been pressed
    DEC HL                  ; HL = HL--
    LD A, H                 ; A = H
    OR 0
    JR NZ, DELAY_LOOP       ; If HL != 0, repeat
    RET
;-----------------------------------------------------------------------------------------
