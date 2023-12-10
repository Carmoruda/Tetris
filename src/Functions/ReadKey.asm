;-----------------------------------------------------------------------------------------
; READYKEY - Identifies whether the user presses the Y key.
;	OUT - PRESSED_KEY = 'Y' if Y key is pressed.
;-----------------------------------------------------------------------------------------
READYKEY:
	LD BC, $DFFE       ; Keys: Y, U, I, O, P
	IN A, (C)          ; Read the keyboard
	BIT 4, A           ; Key Y
	JR NZ, READNKEY    ; Y isn't pressed, check N key
LOOPY:
	IN A, (C)           ; Wait for key release
	CP $FF              ; Key released?
	JR NZ, LOOPY        ; No, wait
	LD A, 'Y'           ; Yes, A = 'Y'
	LD (PRESSED_KEY), A ; Save the pressed key
	RET
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; READNKEY - Identifies whether the user presses the N key.
;	OUT - PRESSED_KEY = 'N' if N key is pressed.
;-----------------------------------------------------------------------------------------
READNKEY:
	LD A, $7F       ; Keys: B, N, M, SYMB, SPACE
	IN A, ($FE)     ; Read the keyboard
	BIT 3, A        ; Key N
	JR NZ, READYKEY ; N isn't pressed, check Y key
LOOPN:
	IN A, (C)           ; Wait for key release
	CP $FF              ; Key released?
	JR NZ, LOOPN        ; No, wait
	LD A, 'N'           ; Yes, A = 'N'
	LD (PRESSED_KEY), A ; Save the pressed key
	RET
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; READ_ACTION_KEYS - Identifies whether the user pressed a key to move or rotate the
; 					 tetromino.
;	OUT - PRESSED_KEY = key pressed by the user.
;-----------------------------------------------------------------------------------------
READ_ACTION_KEYS:
	PUSH BC
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; READ_ACTION_KEYS_LOOP - Specifies the row of keys to read.
;-----------------------------------------------------------------------------------------
READ_ACTION_KEYS_LOOP:
	LD A, $BF       ; Keys: H, J, K, L, ENTER
	IN A, ($FE)     ; Read the keyboard
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; J_KEY - Identifies whether the user presses the J key.
;-----------------------------------------------------------------------------------------
J_KEY:
	BIT 3, A 				; Key J
	JR NZ, L_KEY			; J isn't pressed, check L key
	LD A, 'J' 				; J pressed, A = 'J'
	LD (PRESSED_KEY), A 	; Save the pressed key
	JP WAIT_FOR_KEY_RELEASE ; Wait for key release
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; L_KEY - Identifies whether the user presses the L key.
;-----------------------------------------------------------------------------------------
L_KEY:
	BIT 1, A 				; Key L
	JR NZ, C_KEY			; L isn't pressed, check C key
	LD A, 'L'				; L pressed, A = 'L'
	LD (PRESSED_KEY), A		; Save the pressed key
	JP WAIT_FOR_KEY_RELEASE	; Wait for key release
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; C_KEY - Identifies whether the user presses the C key.
;-----------------------------------------------------------------------------------------
C_KEY:
	LD A, $FE      ; Keys: V, C, X, Z, CAPS
	IN A, ($FE)    ; Read the keyboard

	BIT 3, A 				; Key c
	JR NZ, Z_KEY 			; C isn't pressed, check Z key
	LD A, 'C' 				; C pressed, A = 'C'
	LD (PRESSED_KEY), A 	; Save the pressed key
	JP WAIT_FOR_KEY_RELEASE ; Wait for key release
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; Z_KEY - Identifies whether the user presses the Z key.
;-----------------------------------------------------------------------------------------
Z_KEY:
	BIT 1, A 					; Key Z
	JR NZ, END_READ_ACTION_KEYS ; Z isn't pressed, end check
	LD A, 'Z'					; Z pressed, A = 'Z'
	LD (PRESSED_KEY), A 		; Save the pressed key
	JP WAIT_FOR_KEY_RELEASE		; Wait for key release
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; WAIT_FOR_KEY_RELEASE - Waits for the user to release the key.
;-----------------------------------------------------------------------------------------
WAIT_FOR_KEY_RELEASE:
	IN A, (C)           		; Wait for key release
	CP $FF              		; Key released?
	JR NZ, WAIT_FOR_KEY_RELEASE	; No, wait
	JP END_READ_ACTION_KEYS		; Yes, end routine
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; END_READ_ACTION_KEYS - Ends the READ_ACTION_KEYS routine.
;-----------------------------------------------------------------------------------------
END_READ_ACTION_KEYS:
	POP BC
	RET
;-----------------------------------------------------------------------------------------
