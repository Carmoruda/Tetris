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
PRESSED_KEY: DB " ", 0  ; Pressed key.
ROWS: DB 0              ; Position of the tetromino in the rows.
COLUMNS: DB 0           ; Position of the tetromino in the columns.
DELAY_DOWN: DW 1000     ; Delay for the tetromino to move down.
DELAY_MOVE: DW 3500     ; Delay for the tetromino to move left or right.
COLLISION: DB 0         ; Collision with other tetrominos.
COLOUR: DB 0            ; Colour of a square of the screen.

; -------- GAMESTATUS -------
GAME_STATUS_STRUCT:
GAME_X_POS: DB 0                ; X position of the current tetromino.
GAME_Y_POS: DB 0                ; Y position of the current tetromino.
TETROMINO_POINTER: DW 0         ; Pointer to the current tetromino.
NEXT_TETROMINO_POINTER: DW 0    ; Pointer to the next tetromino.

; -------- SCREENS --------
    INCLUDE "./Screens/StartScreen.asm"
    INCLUDE "./Screens/GameScreen.asm"
    INCLUDE "./Screens/EndScreen.asm"
    INCLUDE "./Screens/LoadStartingScreen.asm"
    INCLUDE "./Screens/LoadEndingScreen.asm"

; -------- TETROMINOS --------
    INCLUDE "./Tetrominos/Tetrominos.asm"
    INCLUDE "./Tetrominos/PaintTetrominos.asm"
    INCLUDE "./Tetrominos/CheckTetrominos.asm"
    INCLUDE "./Tetrominos/EraseTetrominos.asm"
    INCLUDE "./Tetrominos/RandomTetrominos.asm"
    INCLUDE "./Tetrominos/MoveTetrominos.asm"
    INCLUDE "./Tetrominos/RotateTetrominos.asm"

; -------- FUNCTIONS --------
    INCLUDE "./Functions/ReadKey.asm"
    INCLUDE "./Functions/Printat.asm"
    INCLUDE "./Functions/Tetris_3D.asm"
    INCLUDE "./Functions/PaintSquareScreen.asm"
    INCLUDE "./Functions/CheckSquareScreen.asm"

; -------- TODOs --------
; TODO: Cursor must echo the key pressed (StarttingScreen and EndingScreen).
; TODO: Speeded-up delay.
; TODO: Lower threshold delay.
; TODO: Rotate tetromino (right and left).
; TODO: Press enter to drop tetromino faster.
; TODO: No blocking of movement through continuous key pressing.
; TODO: Press key just produces one tetromino movement.
; TODO: Detect collision with other tetrominos.
