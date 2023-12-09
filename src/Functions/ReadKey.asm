;-----------------------------------------------------------------------------------------
; READYKEY - Identifies whether the user presses the Y key.
;	OUT - A = 1 if Y key is pressed.
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
;	OUT - A = 2 if N key is pressed.
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

READ_ACTION_KEYS:
	PUSH BC
	LD B, 252
READ_ACTION_KEYS_LOOP:
	LD A, $BF       ; Keys: H, J, K, L, ENTER
	IN A, ($FE)     ; Read the keyboard
J_KEY:
	BIT 3, A ; Key J
	JR NZ, L_KEY
	LD A, 'J'
	LD (PRESSED_KEY), A
	JP WAIT_FOR_KEY_RELEASE
L_KEY:
	BIT 1, A ; Key L
	JR NZ, C_KEY
	LD A, 'L'
	LD (PRESSED_KEY), A
	JP WAIT_FOR_KEY_RELEASE
C_KEY:
	LD A, $FE      ; Keys: V, C, X, Z, CAPS
	IN A, ($FE)    ; Read the keyboard

	BIT 3, A ; Key c
	JR NZ, Z_KEY
	LD A, 'C'
	LD (PRESSED_KEY), A
	JP WAIT_FOR_KEY_RELEASE
Z_KEY:
	BIT 1, A ; Key Z
	JR NZ, END_LOOP
	LD A, 'Z'
	LD (PRESSED_KEY), A
	JP WAIT_FOR_KEY_RELEASE

WAIT_FOR_KEY_RELEASE:
	IN A, (C)           ; Wait for key release
	CP $FF              ; Key released?
	JR NZ, WAIT_FOR_KEY_RELEASE        ; No, wait

END_LOOP:
	DJNZ READ_ACTION_KEYS_LOOP

END_READ_ACTION_KEYS:
	POP BC
	RET
