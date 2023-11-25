;-----------------------------------------------------------------------------------------
; GAMESCREEN - Selects the row for the first U border square and calls the TETRIS_3D
;              routine.
;-----------------------------------------------------------------------------------------
GAMESCREEN:
    CALL CLEARSCR   ; Clean screen.
    CALL TETRIS_3D
    LD B, 1     ; Square Row
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; VERTICAL_BORDER - Display the U vertical sides.
;-----------------------------------------------------------------------------------------
VERTICAL_BORDER:
    LD C, 6     ; Square Column
    LD A, $38   ; Square color (hex) -> White
    CALL DOTYXC ; Paint square

    PUSH AF
    LD A, C
    ADD TETRIS_WIDTH
    LD C, A
    POP AF
    CALL DOTYXC

    LD A, B
    INC B
    CP TETRIS_HEIGHT
    JR NZ, VERTICAL_BORDER

    LD C, 6     ; Square Column
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; HORIZONTAL_BORDER - Display the U bottom side.
;-----------------------------------------------------------------------------------------
HORIZONTAL_BORDER:
    LD A, $38   ; Square color (hex) -> White
    CALL DOTYXC ; Paint square

    LD A, C
    INC C
    CP TETRIS_MAX_WIDTH
    JR NZ, HORIZONTAL_BORDER
;-----------------------------------------------------------------------------------------

GAME_TETROMINO:
    LD IX, T_0     ; Tetromino

    LD A, 1         ; Screen row
    LD (ROWS), A    ; Save row

    LD A, 15        ; Screen column
    LD (COLUMNS), A ; Save column

    CALL PAINT_TETROMINO

MOVE_TETROMINO_DOWN:
    CALL ERASE_TETROMINO
    LD A, (ROWS)
    INC A
    LD (ROWS), A
    PUSH AF
    CALL PAINT_TETROMINO

    CALL DELAY
    POP AF
    CP 20
    JR NZ, MOVE_TETROMINO_DOWN

END_MOVE_TETROMINO_DOWN:
    CALL ERASE_TETROMINO
    LD A, (ROWS)
    INC A
    LD (ROWS), A
    CALL PAINT_TETROMINO

;-----------------------------------------------------------------------------------------
; GAMELOOP - Game simulation.
;-----------------------------------------------------------------------------------------
GAMELOOP:
    JR GAMELOOP
;-----------------------------------------------------------------------------------------

DELAY:
    LD HL, 10000
DELAY_LOOP:
    DEC HL
    LD A, H
    OR 0
    JR NZ, DELAY_LOOP
    RET

TETRIS_WIDTH EQU 19
TETRIS_MAX_WIDTH EQU 25
TETRIS_HEIGHT EQU 21
GAMEMESSAGE: DB "GAME", 0

; CALL DIBUJA
; ESPERA (El tiempo de espera debe ser variable)
; BORRAMOS LA FORMA
; SUMAMOS 1 A LA FILA
