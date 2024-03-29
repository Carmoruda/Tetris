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
DELAY_DOWN: DW 500      ; Delay for the tetromino to move down.
DELAY_DOWN_MIN: DB 50   ; Minimum delay for the tetromino to move down (threshold).
DELAY_MOVE: DW 3500     ; Delay for the tetromino to move left or right.
DELAY_MOVE_MIN: DB 100  ; Minimum delay for the tetromino to move left or right (threshold).
ACTIVE_DELAY: DW 0      ; Time delay that is currently active.
COLLISION: DB 0         ; Collision with other tetrominos.
TETRIS_WIDTH EQU 19     ; Space between the U borders.
TETRIS_MAX_WIDTH EQU 24 ; Last column of the U borders.
TETRIS_HEIGHT EQU 21    ; Last row of the U borders.
PIECE_HEIGHT: DB 0      ; Tetromino height.
TETROMINO_WIDTH EQU T_I1 - T_0 ; Width of a tetromino in bytes


; -------- SCREEN TEXTS -------
PLAYMESSAGE1: DB "WOULD YOU ", 0
PLAYMESSAGE2: DB "LIKE TO PLAY?", 0
PLAYMESSAGE3: DB " (Y/N)", 0
BYEMESSAGE: DB "BYE!", 0
PLAYAGAINMESSAGE: DB "PLAY AGAIN? (Y/N)", 0
END_CURSOR: DB "N", 0
START_CURSOR: DB "Y", 0
ENDMESSAGE: DB "END!", 0
GAMEMESSAGE: DB "GAME", 0
SCOREMESSAGE: DB "SCORE", 0


; -------- GAMESTATUS -------
GAME_STATUS_STRUCT:
GAME_SCORE: DB 0          ; Score.
GAME_X_POS: DB 0                ; X position of the current tetromino.
GAME_Y_POS: DB 0                ; Y position of the current tetromino.
TETROMINO_POINTER: DW 0         ; Pointer to the current tetromino.
NEXT_TETROMINO_POINTER: DW 0    ; Pointer to the next tetromino.


; -------- GRAPHIC SCREENS --------
LOADSTARTINGSCREEN_END: INCBIN "./GraphicScreens/EndingScreenTetris.scr"
LOADSTARTINGSCREEN_START: INCBIN "./GraphicScreens/StartingScreenTetris.scr"


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
; TODO: Press enter to drop tetromino faster.
; TODO: User manual.
; TODO: Include score.
; TODO: When a line is completed, it must be deleted and the rest of the tetrominos must be moved down.
