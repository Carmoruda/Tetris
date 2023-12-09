ROTATE_INI:
    CALL ERASE_TETROMINO    ; Erase current tetromino
    LD IX, (TETROMINO_POINTER)
    RET


;-----------------------------------------------------------------------------------------
; ROTATE_TETROMINO_LEFT - Rotates the tetromino to the left.
;-----------------------------------------------------------------------------------------
ROTATE_TETROMINO_LEFT:
    CALL ROTATE_INI
    LD HL, (IX + 8)
    CALL ROTATE_END
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; ROTATE_TETROMINO_RIGHT - Rotates the tetromino to the right.
;-----------------------------------------------------------------------------------------
ROTATE_TETROMINO_RIGHT:
    CALL ROTATE_INI
    LD HL, (IX + 9)
    CALL ROTATE_END
;-----------------------------------------------------------------------------------------

ROTATE_END:
    LD IX, HL
    LD (TETROMINO_POINTER), IX

    LD A, (IX)           ; Tetromino height
    LD (PIECE_HEIGHT), A ; Save tetromino height

    JP END_MOVE             ; Jump to END_MOVE
