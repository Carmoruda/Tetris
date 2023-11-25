;-----------------------------------------------------------------------------------------
; READYKEY - Identifies whether the user presses the Y key.
;	OUT - A = 1 if Y key is pressed.
;-----------------------------------------------------------------------------------------
READYKEY:
        LD BC, $DFFE       ; Keys: Y, U, I, O, P
        IN A, (C)
        BIT 4, A        ; Key Y
        JR NZ, READNKEY
LOOPY:
        IN A, (C)
        CP $FF
        JR NZ, LOOPY
        LD A, 1
        RET
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; READNKEY - Identifies whether the user presses the N key.
;	OUT - A = 2 if N key is pressed.
;-----------------------------------------------------------------------------------------
READNKEY:
        LD A, $7F       ; Keys: B, N, M, SYMB, SPACE
        IN A, ($FE)
        BIT 3, A        ; Key N
        JR NZ, READYKEY
LOOPN:
        IN A, (C)
        CP $FF
        JR NZ, LOOPN
        LD A, 2
        RET
;-----------------------------------------------------------------------------------------
