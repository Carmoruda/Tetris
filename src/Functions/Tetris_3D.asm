Tetro_3D:   DB $FF, $81, $81, $85, $85, $9D, $81, $FF ; Block pattern

;-----------------------------------------------------------------------------------------
; TETRIS_3D - Paint the 3D Tetris effect.
; OUT - D: Number of pixel blocks to paint.
;       IX: VRAM address.
;-----------------------------------------------------------------------------------------
TETRIS_3D:
    LD D, 3              ; 3 blocks of pixels
    LD IX, $4000         ; VRAM starting address
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; T3D3 - Set first byte and number of bytes of the pattern.
; IN - D: Number of pixel blocks to paint.
;      IX: VRAM address.
; OUT - IX: VRAM address.
;       IY: First byte of the pattern.
;       C: Number of bytes of the pattern.
;       D: Number of pixel blocks to paint.
;-----------------------------------------------------------------------------------------
T3D3:
    LD IY, Tetro_3D      ; First byte of the pattern
    LD C, 8              ; 8 bytes of the pattern
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; T3D2 - Set first byte and number of bytes of the pattern.
; IN - IX: VRAM address.
;      IY: First byte of the pattern.
;      C: Number of bytes of the pattern.
;      D: Number of pixel blocks to paint.
; OUT - IX: VRAM address.
;       IY: First byte of the pattern.
;       A: Pattern value.
;       B: Number of bytes for each line of the pattern.
;       C: Number of bytes of the pattern.
;       D: Number of pixel blocks to paint.
;-----------------------------------------------------------------------------------------
T3D2:
    LD B, 0              ; 256 bytes for each line of the pattern
    LD A, (IY)           ; Load pattern value
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; T3D1 - Paint the pattern.
; IN - IX: VRAM address.
;      IY: First byte of the pattern.
;      A: Pattern value.
;      B: Number of bytes for each line of the pattern.
;      C: Number of bytes of the pattern.
;      D: Number of pixel blocks to paint.
;-----------------------------------------------------------------------------------------
T3D1:
    LD (IX), A          ; Load the pattern into the VideoRam
    INC IX              ; Next 8 pixels
    DJNZ T3D1           ; End of the 1st loop

    DEC C               ; End of the 2nd loop
    INC IY              ; Next byte of the pattern
    JR NZ, T3D2

    DEC D               ; End of the 3rd loop
    JR NZ, T3D3

    RET
;-----------------------------------------------------------------------------------------
