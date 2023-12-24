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

	LD A, $3B ; Attribute - Pink font with white background
	LD B, 6   ; Row
	LD C, 17  ; Column

	JP Z, PLAY_AGAIN_SELECTED    ; If Y, go to starting screen

	LD IX, END_CURSOR        ; IX = "N"
	CALL PRINTAT             ; Paint "N" in the cursor position
	LD HL, (DELAY_MOVE)      ; HL = DELAY_MOVE = 3500
	LD (ACTIVE_DELAY), HL    ; ACTIVE_DELAY = HL = 3500
	CALL DELAY               ; Delay 3500 ms

	; End!
	LD A, $3B              ; Attribute - Pink font with white background
	LD B, 8                ; Row
	LD C, 11               ; Column
	LD IX, ENDMESSAGE      ; End!
	CALL PRINTAT

	JP ENDOFCODE
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; PLAY_AGAIN_SELECTED - Displays the cursor "Y" and the start screen
;-----------------------------------------------------------------------------------------
PLAY_AGAIN_SELECTED:
	LD IX, START_CURSOR	  ; IX = "Y"
	CALL PRINTAT	      ; Print "Y" at the cursor position
	LD HL, (DELAY_MOVE)   ; HL = DELAY_MOVE = 3500
	LD (ACTIVE_DELAY), HL ; ACTIVE_DELAY = HL = 3500
	CALL DELAY            ; Delay 3500 ms
	CALL BEGIN			  ; Go to the starting screen
;-----------------------------------------------------------------------------------------


