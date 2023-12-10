;-----------------------------------------------------------------------------------------
; ENDINGSCREEN - Displays the end screen with its corresponding messages.
;-----------------------------------------------------------------------------------------
ENDINGSCREEN:
        CALL CLEARSCR   ; Clean screen.
        CALL LOADENDINGSCREEN

        ; Bye!
        LD A, $3B               ; Attribute - Pink font with white background
        LD B, 4                 ; Row
        LD C, 0                 ; Column
        LD IX, BYEMESSAGE       ; Bye!
        CALL PRINTAT

        ; Play again? (Y/N)
        LD A, $3B               ; Attribute - Pink font with white background
        LD B, 6                 ; Row
        LD C, 0                 ; Column
        LD IX, PLAYAGAINMESSAGE ; Play again? (Y/N)
        CALL PRINTAT

        ; Cursor
        LD HL, $5800 + 6 * 32 + 17    ; Row 6, column 17
        LD (HL), $9F                  ; Attribute - White font with pink background

        XOR A                ; A = 0
        CALL READYKEY        ; Wait for a key to be pressed
        LD A, (PRESSED_KEY)  ; A = Key pressed
        CP 'Y'
        JP Z, STARTINGSCREEN    ; If Y, go to starting screen

        ; End!
        LD A, $3B              ; Attribute - Pink font with white background
        LD B, 8                ; Row
        LD C, 11               ; Column
        LD IX, ENDMESSAGE       ; End!
        CALL PRINTAT
        LD HL, $5800 + 6 * 32 + 17    ; Row 10, column 23
        LD (HL), $38                  ; Attribute - White background.

        JP ENDOFCODE
;-----------------------------------------------------------------------------------------
