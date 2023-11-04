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
    LD A, $38
    CALL DOTYXC

    LD A, C
    INC C
    CP TETRIS_MAX_WIDTH
    JR NZ, HORIZONTAL_BORDER
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; GAMELOOP - Game simulation.
;-----------------------------------------------------------------------------------------
GAMELOOP:
    JR GAMELOOP
;-----------------------------------------------------------------------------------------

TETRIS_WIDTH EQU 19
TETRIS_MAX_WIDTH EQU 25
TETRIS_HEIGHT EQU 21
GAMEMESSAGE: DB "GAME", 0        ; 0 = delimitador de array.
