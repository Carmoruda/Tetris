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
