    DEVICE ZXSPECTRUM48
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    org $8000               ; Program located at $8000 = 32768.

BEGIN:
    DI              ; Disable interruptions.
    LD SP, 0        ; Set the stack pointer to the top of memory.
    LD HL, $5800    ; First square of the screen.

MAIN:
    CALL CLEARSCR       ; Clean screen.
    CALL STARTINGSCREEN
    CALL GAMESCREEN
    CALL ENDINGSCREEN

ENDOFCODE:
    JR ENDOFCODE

; -------- VARIABLES -------
WAITING_TIME: DW $1FFF  ; Wait time (in ms).
WAITING_TIME_SUBTRACT EQU $10   ; Wait time decrement.
WAITING_TIME_TRESHOLD EQU $05

; -------- SCREENS --------
    INCLUDE "./Screens/StartScreen.asm"
    INCLUDE "./Screens/GameScreen.asm"
    INCLUDE "./Screens/EndScreen.asm"
    INCLUDE "./Screens/LoadStartingScreen.asm"
    INCLUDE "./Screens/LoadEndingScreen.asm"

    INCLUDE "ReadKey.asm"
    INCLUDE "Printat.asm"

    INCLUDE "Tetris_3D.asm"
    INCLUDE "AtributeCoordinate.asm"
