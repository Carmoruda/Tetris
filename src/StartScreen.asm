        DEVICE ZXSPECTRUM48
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
        org $8000               ; Program located at $8000 = 32768.

BEGIN:          
        DI              ; Disable interruptions.
        LD SP, 0        ; Set the stack pointer to the top of memory.
        LD HL, $5800    ; First square of the screen. 

MAIN:
        CALL CLEARSCR   ; Clean screen.

;-----------------------------------------------------------------------------------------
; STARTINGSCREEN - Displays the start screen with its corresponding messages.
;-----------------------------------------------------------------------------------------
STARTINGSCREEN:
        CALL LOADSTARTINGSCREEN
        ; Would you like to play? (y/n)
        LD A, $39              ; Attribute - Blue font with white background
        LD B, 6                ; Row
        LD C, 16               ; Column
        LD IX, PLAYMESSAGE1    ; Would you
        CALL PRINTAT
        
        LD A, $39              ; Attribute - Blue font with white background
        LD B, 8                ; Row
        LD C, 14               ; Column
        LD IX, PLAYMESSAGE2    ; like to play
        CALL PRINTAT

        LD A, $39              ; Attribute - Blue font with white background
        LD B, 10               ; Row
        LD C, 16               ; Column
        LD IX, PLAYMESSAGE3    ; (Y/N)
        CALL PRINTAT
        
        ; Cursor
        LD HL, $5800 + 10 * 32 + 23    ; Row 10, column 23
        LD (HL), $8F

        XOR A
        CALL READYKEY
        CP 1            
        JP Z, GAMESCREEN        ; Y - Game
        JR ENDINGSCREEN         ; N - End screen
;-----------------------------------------------------------------------------------------

ENDOFCODE:            
        JR ENDOFCODE

PLAYMESSAGE1: DB "WOULD YOU ", 0
PLAYMESSAGE2: DB "LIKE TO PLAY?", 0
PLAYMESSAGE3: DB " (Y/N)", 0

        INCLUDE "GameScreen.asm"
        INCLUDE "EndScreen.asm"
        INCLUDE "ReadKey.asm"
        INCLUDE "Printat.asm"
        INCLUDE "LoadStartingScreen.asm"
        INCLUDE "LoadEndingScreen.asm"
        INCLUDE "Tetris_3D.asm"