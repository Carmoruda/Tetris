;-----------------------------------------------------------------------------------------
; MOVE_TETROMINO_LEFT - Moves the tetromino one column to the left.
;-----------------------------------------------------------------------------------------
MOVE_TETROMINO_LEFT:
    CALL ERASE_TETROMINO    ; Erase current tetromino

    LD A, (COLUMNS)         ; A = X position
    DEC A                   ; A = X position - 1 (Move left)
    LD (COLUMNS), A         ; Save X position

    CALL CHECK_TETROMINO    ; Check tetromino next position

    LD A, (COLLISION)       ; A = COLLISION
    CP 0
    JP NZ, END_MOVE         ; If A != 0 (Collision), jump to END_MOVE (Move down)

    LD (GAME_X_POS), A      ; Save X position to the GAME_STATUS_STRUCT
    JP END_MOVE             ; Jump to END_MOVE
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; MOVE_TETROMINO_RIGHT - Moves the tetromino one column to the right.
;-----------------------------------------------------------------------------------------
MOVE_TETROMINO_RIGHT:
    CALL ERASE_TETROMINO   ; Erase current tetromino

    LD A, (COLUMNS)        ; A = X position
    INC A                  ; A = X position + 1 (Move right)
    LD (COLUMNS), A        ; Save X position

    CALL CHECK_TETROMINO   ; Check tetromino next position

    LD A, (COLLISION)      ; A = COLLISION
    CP 0
    JP NZ, END_MOVE        ; If A != 0 (Collision), jump to END_MOVE (Move down)

    LD (GAME_X_POS), A     ; Save X position to the GAME_STATUS_STRUCT
    JP END_MOVE            ; Jump to END_MOVE
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; MOVE_TETROMINO_DOWN - Moves the tetromino down until it reaches the bottom border.
;-----------------------------------------------------------------------------------------
MOVE_TETROMINO_DOWN:
    LD IX, (TETROMINO_POINTER) ; IX = Pointer to the tetromino
    CALL ERASE_TETROMINO       ; Erase tetromino
    CALL CHECK_TETROMINO       ; Check tetromino next position

    LD A, (COLLISION)          ; A = COLLISION
    CP 0
    JP NZ, COLLISION_ACTION    ; If A != 0 (No collision), jump to COLLISION_ACTION

    LD A, (ROWS)               ; A = Rows
    INC A                      ; A = Rows + 1
    LD (ROWS), A               ; Save Rows
    LD (GAME_Y_POS), A         ; Save row to the GAME_STATUS_STRUCT

    PUSH AF
    CALL PAINT_TETROMINO  ; Paint tetromino
    LD HL, (DELAY_DOWN)   ; HL = DELAY_DOWN = 1000
    LD (ACTIVE_DELAY), HL ; ACTIVE_DELAY = HL = 1000
    CALL DELAY            ; Time delay
    LD A, (PIECE_HEIGHT)  ; A = Tetromino height
    LD B, A               ; B = Tetromino height
    LD A, 22              ; A = 21
    SUB B                 ; A = 21 - Tetromino height
    LD B, A               ; B = 21 - Tetromino height
    POP AF

    CP B
    JP NZ, TETRIS_ACTION ; If A != B, repeat
    RET
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; END_MOVE - Ends the movement of the tetromino when a key is pressed.
;-----------------------------------------------------------------------------------------
END_MOVE:
    LD A, ' '                  ; A = ' '
    LD (PRESSED_KEY), A        ; Save ' ' to PRESSED_KEY
    LD IX, (TETROMINO_POINTER) ; IX = Pointer to the tetromino
    CALL PAINT_TETROMINO       ; Paint tetromino
    CALL DELAY                 ; Time delay
    JP MOVE_TETROMINO_DOWN     ; Jump to MOVE_TETROMINO_DOWN
;-----------------------------------------------------------------------------------------
