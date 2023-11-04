;-----------------------------------------------------------------------------------------
; LOADENDINGSCREEN -  Set values to paint the graphic.
;-----------------------------------------------------------------------------------------
LOADENDINGSCREEN:
    LD HL, LOADSTARTINGSCREEN_END ; HL = Starting addres of screen data

    ; Save used registers
    PUSH BC
    PUSH DE

    LD DE, $4000 ; Display to video memory area
    LD BC, 6912  ; VidkeoRAM size
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; LOADENDINGSCREEN_LOOP - Displays the end screen graphic.
;-----------------------------------------------------------------------------------------
LOADENDINGSCREEN_LOOP:
    LDI ; (DE) = (HL) , DE++, HL++, BC--

    LD A, B ; Check if BC is 0
    OR C ; BC = 0 <=> B|C=0
    JP NZ, LOADENDINGSCREEN_LOOP ; Next display byte

    ; Retrieve used registers
    POP DE
    POP BC

    RET
;-----------------------------------------------------------------------------------------

LOADSTARTINGSCREEN_END: INCBIN "EndingScreenTetris.scr"
