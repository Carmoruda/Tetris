;------------------------------------------------------------------------------------------
; ROTATE_INI - Initializes the rotation routine.
;------------------------------------------------------------------------------------------
ROTATE_INI:
    CALL ERASE_TETROMINO       ; Erase current tetromino
    LD IX, (TETROMINO_POINTER) ; Get tetromino pointer
    RET
;------------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; ROTATE_TETROMINO_LEFT - Rotates the tetromino to the left.
;-----------------------------------------------------------------------------------------
ROTATE_TETROMINO_LEFT:
    CALL ROTATE_INI ; Initialize rotation routine
    LD HL, (IX + 8) ; HL = Tetromino rotation to the left

    LD A, (IX + 12) ; Rows to add to the tetromino
    LD B, A         ; B = Rows to add to the tetromino
    LD A, (ROWS) ; A = Game Y position
    ADD B ; A = Game Y position + Rows to add to the tetromino
    LD (ROWS), A

    LD A, (IX + 13) ; Rows to add to the tetromino
    LD B, A         ; B = Rows to add to the tetromino
    LD A, (COLUMNS) ; A = Game Y position
    ADD B           ; A = Game Y position + Rows to add to the tetromino
    LD (COLUMNS), A

    LD IX, HL
    PUSH HL
    CALL CHECK_TETROMINO
    POP HL

    LD A, (COLLISION)          ; A = COLLISION
    CP 0
    JP NZ, ROTATE_COLLISION    ; If A != 0 (Collision), jump to COLLISION_ACTION

    LD A, (ROWS)               ; A = Rows
    INC A                      ; A = Rows + 1
    LD (ROWS), A               ; Save Rows
    LD (GAME_Y_POS), A         ; Save row to the GAME_STATUS_STRUCT

    JP ROTATE_END ; End rotation routine
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; ROTATE_TETROMINO_RIGHT - Rotates the tetromino to the right.
;-----------------------------------------------------------------------------------------
ROTATE_TETROMINO_RIGHT:
    CALL ROTATE_INI  ; Initialize rotation routine
    LD HL, (IX + 10) ; HL = Tetromino rotation to the right

    LD A, (IX + 14) ; Rows to add to the tetromino
    LD B, A         ; B = Rows to add to the tetromino
    LD A, (ROWS) ; A = Game Y position
    ADD B ; A = Game Y position + Rows to add to the tetromino
    LD (ROWS), A

    LD IX, HL
    PUSH HL
    CALL CHECK_TETROMINO
    POP HL

    LD A, (IX + 15) ; Rows to add to the tetromino
    LD B, A         ; B = Rows to add to the tetromino
    LD A, (COLUMNS) ; A = Game Y position
    ADD B ; A = Game Y position + Rows to add to the tetromino
    LD (COLUMNS), A

    LD A, (COLLISION)          ; A = COLLISION
    CP 0
    JP NZ, ROTATE_COLLISION    ; If A != 0 (Collision), jump to COLLISION_ACTION

    LD A, (COLUMNS)
    LD (GAME_X_POS), A
    LD A, (ROWS)
    LD (GAME_Y_POS), A

    JP ROTATE_END  ; End rotation routine
;-----------------------------------------------------------------------------------------


ROTATE_COLLISION:
    LD A, (GAME_X_POS)
    LD (COLUMNS), A
    LD A, (GAME_Y_POS)
    LD (ROWS), A
    LD HL, (TETROMINO_POINTER)
    JP END_MOVE

;-----------------------------------------------------------------------------------------
; ROTATE_END - Ends the rotation routine.
;-----------------------------------------------------------------------------------------
ROTATE_END:
    LD IX, HL                   ; IX = Tetromino rotation
    LD (TETROMINO_POINTER), IX  ; Save tetromino rotation to the tetromino pointer

    LD A, (IX)           ; Tetromino height
    LD (PIECE_HEIGHT), A ; Save tetromino height

    JP END_MOVE          ; Jump to END_MOVE
;-----------------------------------------------------------------------------------------
