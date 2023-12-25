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
    LD A, (ROWS)    ; A = Current Y postion
    ADD B           ; A = Game Y position + Rows to add to the tetromino
    LD (ROWS), A    ; ROWS = Tetromino Y position after rotation

    LD A, (IX + 13) ; Columns to add to the tetromino
    LD B, A         ; B = Columns to add to the tetromino
    LD A, (COLUMNS) ; A = Current X position
    ADD B           ; A = Game X position + Columns to add to the tetromino
    LD (COLUMNS), A ; COLUMNS = Tetromino X position after rotation

    LD IX, HL            ; IX = Tetromino rotation to the left
    PUSH HL
    CALL CHECK_TETROMINO ; Check if we may rotate the tetromino
    POP HL

    LD A, (COLLISION)          ; A = COLLISION
    CP 0
    JP NZ, ROTATE_COLLISION    ; If A != 0 (Collision), jump to ROTATE_COLLISION

    LD A, (ROWS)               ; A = Rows
    LD (GAME_Y_POS), A         ; Save rows to the GAME_STATUS_STRUCT
    LD A, (COLUMNS)            ; A = Columns
    LD (GAME_X_POS), A         ; Save columns to the GAME_STATUS_STRUCT

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
    LD A, (ROWS)    ; A = Current Y position
    ADD B           ; A = Game Y position + Rows to add to the tetromino
    LD (ROWS), A    ; ROWS = Tetromino Y postion after rotation

    LD A, (IX + 15) ; Columns to add to the tetromino
    LD B, A         ; B = Columns to add to the tetromino
    LD A, (COLUMNS) ; A = Current X position
    ADD B           ; A = Game X position + Columns to add to the tetromino
    LD (COLUMNS), A ; COLUMNS = Tetromino X position after rotation

    LD IX, HL            ; IX = Tetromino rotation to the left
    PUSH HL
    CALL CHECK_TETROMINO ; Check if we may rotate the tetromino
    POP HL

    LD A, (COLLISION)          ; A = COLLISION
    CP 0
    JP NZ, ROTATE_COLLISION    ; If A != 0 (Collision), jump to ROTATE_COLLISION

    LD A, (ROWS)               ; A = Rows
    LD (GAME_Y_POS), A         ; Save rows to the GAME_STATUS_STRUCT
    LD A, (COLUMNS)            ; A = Columns
    LD (GAME_X_POS), A         ; Save columns to the GAME_STATUS_STRUCT

    JP ROTATE_END ; End rotation routine
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; ROTATE_COLLISION - Handles the collision after a rotation.
;-----------------------------------------------------------------------------------------
ROTATE_COLLISION:
    LD A, (GAME_X_POS)  ; A = Previous X position
    LD (COLUMNS), A     ; COLUMNS = Previous X position
    LD A, (GAME_Y_POS)  ; A = Previous Y position
    LD (ROWS), A        ; ROWS = Previous Y position
    JP END_MOVE         ; Jump to END_MOVE
;-----------------------------------------------------------------------------------------


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
