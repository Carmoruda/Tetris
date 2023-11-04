;-----------------------------------------------------------------------------------------
; DOTYXC - Identifies whether the user presses the Y key.
;	  IN - B = Y coordinate.
;          C = X coordinate.
;          A = Color (hex).
;-----------------------------------------------------------------------------------------
DOTYXC:
    PUSH AF
    LD L, B
    LD H, 0     ; HL = B

    ADD HL, HL
    ADD HL, HL
    ADD HL, HL
    ADD HL, HL
    ADD HL, HL  ; HL = HL *32

    LD E,C 
    LD D, 0     ; DE = C

    ADD HL, DE
    LD DE, $5800

    ADD HL, DE  ; HL = Y*32 + X + $5800

    LD (HL), A
    POP AF
    RET
;-----------------------------------------------------------------------------------------
