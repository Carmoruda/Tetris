;-----------------------------------------------------------------------------------------
; STARTINGSCREEN - Displays the start screen with its corresponding messages.
;-----------------------------------------------------------------------------------------
STARTINGSCREEN:
        CALL CLEARSCR   ; Clean screen.
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
        LD (HL), $8F                   ; Attribute - White font with blue background

        XOR A                ; A = 0
        CALL READYKEY        ; Wait for a key to be pressed
        LD A, (PRESSED_KEY)  ; A = Key pressed
        CP 'Y'
        JP NZ, ENDINGSCREEN ; Y - Game
        RET                 ; N - End
;-----------------------------------------------------------------------------------------
