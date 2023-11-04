;-----------------------------------------------------------------------------------------
; LOADSTARTINGSCREEN_LOOP - Set values to paint the graphic.
;-----------------------------------------------------------------------------------------
LOADSTARTINGSCREEN:
    LD HL, LOADSTARTINGSCREEN_START ; HL = Starting addres of screen data

    ; Save used registers
    PUSH BC
    PUSH DE

    LD DE, $4000 ; Display to video memory area
    LD BC, 6912  ; VidkeoRAM size
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; LOADSTARTINGSCREEN_LOOP - Displays the start screen graphic.
;-----------------------------------------------------------------------------------------
LOADSTARTINGSCREEN_LOOP:
    LDI ; (DE) = (HL) , DE++, HL++, BC--

    LD A, B ; Check if BC is 0
    OR C ; BC = 0 <=> B|C=0
    JP NZ, LOADSTARTINGSCREEN_LOOP ; Next display byte

    ; Retrieve used registers
    POP DE
    POP BC

    RET
;-----------------------------------------------------------------------------------------

LOADSTARTINGSCREEN_START: INCBIN "StartingScreenTetris.scr"
