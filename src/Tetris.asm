    DEVICE ZXSPECTRUM48
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    org $8000               ; Program located at $8000 = 32768.

BEGIN:
    DI              ; Disable interruptions.
    LD SP, 0        ; Set the stack pointer to the top of memory.
    LD HL, $5800    ; First square of the screen.

MAIN:
    CALL CLEARSCR       ; Clean screen.
    CALL STARTINGSCREEN ; Initial screen.
    CALL GAMESCREEN     ; Game screen.
    CALL ENDINGSCREEN   ; End screen.

ENDOFCODE:
    JR ENDOFCODE

; -------- VARIABLES -------
WAITING_TIME: DW $1FFF  ; Wait time (in ms).
WAITING_TIME_SUBTRACT EQU $10   ; Wait time decrement.
WAITING_TIME_TRESHOLD EQU $05

ROWS: DB 0
COLUMNS: DB 0

; -------- SCREENS --------
    INCLUDE "./Screens/StartScreen.asm"
    INCLUDE "./Screens/GameScreen.asm"
    INCLUDE "./Screens/EndScreen.asm"
    INCLUDE "./Screens/LoadStartingScreen.asm"
    INCLUDE "./Screens/LoadEndingScreen.asm"

; -------- TETROMINOS --------
    INCLUDE "./Tetrominos/Tetrominos.asm"
    INCLUDE "./Tetrominos/PaintTetrominos.asm"
    INCLUDE "./Tetrominos/EraseTetrominos.asm"
    INCLUDE "./Tetrominos/RandomTetrominos.asm"

; -------- FUNCTIONS --------
    INCLUDE "./Functions/ReadKey.asm"
    INCLUDE "./Functions/Printat.asm"
    INCLUDE "./Functions/Tetris_3D.asm"
    INCLUDE "./Functions/AtributeCoordinate.asm"
