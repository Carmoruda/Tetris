Tetro_3D:   DB $FF, $81, $81, $85, $85, $9D, $81, $FF ; Patrón para los bloques

TETRIS_3D:
    LD D,3              ; Los 3 bloques de píxeles
    LD IX,$4000         ; Dirección de comienzo de la VRAM

T3D3:
    
    LD IY,Tetro_3D      ; Primer byte del patrón

    LD C,8              ; 8 bytes del patrón
T3D2:
    LD B,0              ; 256 bytes de cada línea del patrón
    LD a,(IY)           ; Cargo el valor del patrón
T3D1:
    LD (IX),a           ; Cargo el patrón en la VideoRam
    INC IX              ; Siguientes 8 pixels
    DJNZ T3D1           ; Fin del bucle

    DEC C               ; Fin del 2º Bucle
    inc IY              ; Siguiente byte del patrón
    JR NZ,T3D2

    DEC D               ; Fin del 3º bucle
    JR NZ, T3D3

    RET
