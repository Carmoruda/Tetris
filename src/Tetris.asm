    DEVICE ZXSPECTRUM48
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    org $8000       ; Program located at $8000 = 32768.


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
PRESSED_KEY: DB " ", 0    ; Pressed key.
ROWS: DB 0                ; Position of the tetromino in the rows.
COLUMNS: DB 0             ; Position of the tetromino in the columns.

; -------- GAMESTATUS -------
GAME_STATUS_STRUCT:
GAME_X_POS: DB 0               ; X position of the current tetromino.
GAME_Y_POS: DB 0               ; Y position of the current tetromino.
TETROMINO_POINTER: DW 0        ; Pointer to the current tetromino.
NEXT_TETROMINO_POINTER: DW 0   ; Pointer to the next tetromino.

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
