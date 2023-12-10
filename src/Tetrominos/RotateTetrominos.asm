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
    CALL ROTATE_END ; End rotation routine
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; ROTATE_TETROMINO_RIGHT - Rotates the tetromino to the right.
;-----------------------------------------------------------------------------------------
ROTATE_TETROMINO_RIGHT:
    CALL ROTATE_INI ; Initialize rotation routine
    LD HL, (IX + 9) ; HL = Tetromino rotation to the right
    CALL ROTATE_END ; End rotation routine
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
