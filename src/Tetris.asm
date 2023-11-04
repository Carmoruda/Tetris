    DEVICE ZXSPECTRUM48
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    org $8000               ; Program located at $8000 = 32768.

BEGIN:
    DI              ; Disable interruptions.
    LD SP, 0        ; Set the stack pointer to the top of memory.
    LD HL, $5800    ; First square of the screen.

MAIN:
    CALL CLEARSCR   ; Clean screen.
    CALL STARTINGSCREEN

ENDOFCODE:
    JR ENDOFCODE

; -------- SCREENS --------
    INCLUDE "./Screens/StartScreen.asm"
    INCLUDE "./Screens/GameScreen.asm"
    INCLUDE "./Screens/EndScreen.asm"
    INCLUDE "LoadStartingScreen.asm"
    INCLUDE "LoadEndingScreen.asm"

    INCLUDE "ReadKey.asm"
    INCLUDE "Printat.asm"

    INCLUDE "Tetris_3D.asm"
    INCLUDE "AtributeCoordinate.asm"
