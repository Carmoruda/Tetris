        DEVICE ZXSPECTRUM48
        SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
        org $8000               ; Program located at $8000 = 32768.

BEGIN:
        DI              ; Disable interruptions.
        LD SP, 0        ; Set the stack pointer to the top of memory.
        LD HL, $5800    ; First square of the screen.

MAIN:
        CALL CLEARSCR       ; Clean screen.
        CALL STARTINGSCREEN ; Initial screen.
        CALL GAMESCREEN     ; Game screen.
        CALL ENDINGSCREEN   ; End screen.

;-----------------------------------------------------------------------------------------
; STARTINGSCREEN - Displays the start screen with its corresponding messages.
;-----------------------------------------------------------------------------------------
STARTINGSCREEN:
        CALL LOADSTARTINGSCREEN
        ; Would you like to play? (y/n)
        LD A, $39              ; Attribute - Blue font with white background
        LD B, 6                ; Row
        LD C, 16               ; Column
        LD IX, PLAYMESSAGE1    ; Would you
        CALL PRINTAT

        LD A, $39              ; Attribute - Blue font with white background
        LD B, 8                ; Row
        LD C, 14               ; Column
        LD IX, PLAYMESSAGE2    ; like to play
        CALL PRINTAT

        LD A, $39              ; Attribute - Blue font with white background
        LD B, 10               ; Row
        LD C, 16               ; Column
        LD IX, PLAYMESSAGE3    ; (Y/N)
        CALL PRINTAT

        ; Cursor
        LD HL, $5800 + 10 * 32 + 23    ; Row 10, column 23
        LD (HL), $8F

        XOR A
        CALL READYKEY
        CP 1
        JP Z, GAMESCREEN        ; Y - Game
        JP ENDINGSCREEN         ; N - End screen
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; GAMESCREEN - Selects the row for the first U border square and calls the TETRIS_3D
;              routine.
;-----------------------------------------------------------------------------------------
GAMESCREEN:
        CALL CLEARSCR   ; Clean screen.
        CALL TETRIS_3D
        LD B, 1     ; Square Row
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; VERTICAL_BORDER - Display the U vertical sides.
;-----------------------------------------------------------------------------------------
VERTICAL_BORDER:
        LD C, 6     ; Square Column
        LD A, $38   ; Square color (hex) -> White
        CALL DOTYXC ; Paint square

        PUSH AF
        LD A, C
        ADD TETRIS_WIDTH
        LD C, A
        POP AF
        CALL DOTYXC

        LD A, B
        INC B
        CP TETRIS_HEIGHT
        JR NZ, VERTICAL_BORDER

        LD C, 6     ; Square Column
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; HORIZONTAL_BORDER - Display the U bottom side.
;-----------------------------------------------------------------------------------------
HORIZONTAL_BORDER:
        LD A, $38   ; Square color (hex) -> White
        CALL DOTYXC ; Paint square

        LD A, C
        INC C
        CP TETRIS_MAX_WIDTH
        JR NZ, HORIZONTAL_BORDER
;-----------------------------------------------------------------------------------------

GAME_TETROMINO:
        LD IX, T_0     ; Tetromino

        LD A, 1         ; Screen row
        LD (ROWS), A    ; Save row

        LD A, 15        ; Screen column
        LD (COLUMNS), A ; Save column

        CALL PAINT_TETROMINO

MOVE_TETROMINO_DOWN:
        CALL ERASE_TETROMINO
        LD A, (ROWS)
        INC A
        LD (ROWS), A
        PUSH AF
        CALL PAINT_TETROMINO
        POP AF
        CP 19
        JR NZ, MOVE_TETROMINO_DOWN
        CALL ERASE_TETROMINO
        LD A, (ROWS)
        INC A
        LD (ROWS), A
        CALL PAINT_TETROMINO

;-----------------------------------------------------------------------------------------
; GAMELOOP - Game simulation.
;-----------------------------------------------------------------------------------------
GAMELOOP:
        JR GAMELOOP
;-----------------------------------------------------------------------------------------

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
        RET
;-----------------------------------------------------------------------------------------

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
        ADD HL, HL  ; HL = HL * 32

        LD E, C
        LD D, 0     ; DE = C

        ADD HL, DE
        LD DE, $5800

        ADD HL, DE  ; HL = Y*32 + X + $5800

        LD (HL), A
        POP AF
        RET
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; ERASE_TETROMINOS - Erase a tetromino.
;	  IN -  IX = Tetromino we want to ERASE.
;           ROWS = Row of the screen in which we want to ERASE.
;           COLUMNS = Column of the screen in which we want to ERASE.
;-----------------------------------------------------------------------------------------
ERASE_TETROMINO:
        LD IY, IX
        LD E, (IX)      ; Number of rows
        INC IY: INC IY
        LD A, (ROWS)
        LD B, A

ERASE_TETROMINO_OUTERLOOP:
        LD D, (IX + 1)  ; Number of columns
        LD A, (COLUMNS)
        LD C, A
ERASE_TETROMINO_INNERLOOP:
        PUSH DE
        LD A, $00
        CALL DOTYXC         ; Erase square
        POP DE
        INC C               ; Next column
ERASE_TETROMINOS_CHECK_LOOPS:
        LD A, D                             ; A = D
        CP 0                                ; Column = 0?
        DEC D                               ; Column -= 1
        JP NZ, ERASE_TETROMINO_INNERLOOP    ; Yes - Erase
        INC B                               ; Next row
        LD A, E                             ; A = E
        CP 0                                ; Row = 0?
        DEC E                               ; Row -= 1
        JP NZ, ERASE_TETROMINO_OUTERLOOP    ; No - Loop
        RET
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; PAINT_TETROMINOS - Paint a tetromino.
;	  IN -  IX = Tetromino we want to paint.
;           ROWS = Row of the screen in which we want to paint.
;           COLUMNS = Column of the screen in which we want to paint.
;-----------------------------------------------------------------------------------------
PAINT_TETROMINO:
        LD IY, IX
        LD E, (IX)      ; Number of rows
        INC IY: INC IY
        LD A, (ROWS)
        LD B, A

PAINT_TETROMINO_OUTERLOOP:
        LD D, (IX + 1)  ; Number of columns
        LD A, (COLUMNS)
        LD C, A
PAINT_TETROMINO_INNERLOOP:
        LD A, (IY)                  ; A = Square
        INC IY                      ; IY = Next square
        CP 0                        ; Square = 0?
        JP NZ, PAINT_TETROMINO_LOOP ; No - Paint
        INC C                       ; Next column
        JP PAINT_TETROMINO_CHECK_LOOPS               ; Yes - Check loop conditions

PAINT_TETROMINO_LOOP:
        PUSH DE
        CALL DOTYXC         ; Paint square
        POP DE
        INC C               ; Next column
PAINT_TETROMINO_CHECK_LOOPS:
        LD A, D                             ; A = D
        CP 0                                ; Column = 0?
        DEC D                               ; Column -= 1
        JP NZ, PAINT_TETROMINO_INNERLOOP    ; Yes - Paint
        INC B                               ; Next row
        LD A, E                             ; A = E
        CP 0                                ; Row = 0?
        DEC E                               ; Row -= 1
        JP NZ, PAINT_TETROMINO_OUTERLOOP    ; No - Loop
        RET
;-----------------------------------------------------------------------------------------

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
        LD (HL), $9F

        XOR A
        CALL READYKEY
        CP 1
        JP Z, STARTINGSCREEN    ; Y - Start screen
        LD A, $3B               ; N - End of code.
        LD B, 8
        LD C, 11
        LD IX, ENDMESSAGE       ; End!
        CALL PRINTAT
        LD HL, $5800 + 6 * 32 + 17    ; Row 10, column 23
        LD (HL), $38

        JP ENDOFCODE
;-----------------------------------------------------------------------------------------

ENDOFCODE:
        JR ENDOFCODE

PLAYMESSAGE1: DB "WOULD YOU ", 0
PLAYMESSAGE2: DB "LIKE TO PLAY?", 0
PLAYMESSAGE3: DB " (Y/N)", 0
BYEMESSAGE: DB "BYE!", 0
PLAYAGAINMESSAGE: DB "PLAY AGAIN? (Y/N)", 0
ENDMESSAGE: DB "END!", 0
GAMEMESSAGE: DB "GAME", 0        ; 0 = delimitador de array.
ROWS: DB 0
COLUMNS: DB 0
TETRIS_WIDTH EQU 19
TETRIS_MAX_WIDTH EQU 25
TETRIS_HEIGHT EQU 21

;-----------------------------------------------------------------------------------------
; Name: DB rows, columns, i, i, i, i, i, i: DW left, right
;-----------------------------------------------------------------------------------------

; O block (Yellow) - All four rotations are the same
T_0: DB 2, 2, $30, $30, $30, $30, 0, 0: DW T_0, T_0

; I block (Cyan) - Vertical and horizontal rotations are the same among them
T_I1: DB 4, 1, $28, $28, $28, $28, 0, 0: DW T_I2, T_I2
T_I2: DB 1, 4, $28, $28, $28, $28, 0, 0: DW T_I1, T_I1

; Z block (Red) - Vertical and horizontal rotations are the same among them
T_Z1: DB 2, 3, $10, $10, 0, 0, $10, $10: DW T_Z2, T_Z2
T_Z2: DB 3, 2, 0, $10, $10, $10, $10, 0: DW T_Z1, T_Z1

; S block (Green) - Vertical and horizontal rotations are the same among them
T_S1: DB 2, 3, 0, $20, $20, $20, $20, 0: DW T_S2, T_S2
T_S2: DB 3, 2, $20, 0, $20, $20, 0, $20: DW T_S1, T_S1

; L block (Dark Yellow) -  Four rotations
T_L1: DB 3, 2, $70, 0, $70, 0, $70, $70: DW T_L4, T_L2
T_L2: DB 2, 3, $70, $70, $70, $70, 0, 0: DW T_L1, T_L3
T_L3: DB 3, 2, $70, $70, 0, $70, 0, $70: DW T_L2, T_L4
T_L4: DB 2, 3, 0, 0, $70, $70, $70, $70: DW T_L3, T_L1

; J block (Dark Blue) - Four rotations
T_J1: DB 3, 2, 0, $08, 0, $08, $08, $08: DW T_J4, T_J2
T_J2: DB 2, 3, $08, 0, 0, $08, $08, $08: DW T_J1, T_J3
T_J3: DB 3, 2, $08, $08, $08, 0, $08, 0: DW T_J2, T_J4
T_J4: DB 2, 3, $08, $08, $08, 0, 0, $08: DW T_J3, T_J1

; T block (Purple) - Four rotations
T_T1: DB 2, 3, $18, $18, $18, 0, $18, 0: DW T_T4, T_T2
T_T2: DB 3, 2, 0, $18, $18, $18, 0, 3*8: DW T_T1, T_T3
T_T3: DB 2, 3, 0, $18, 0, $18, $18, 3*8: DW T_T2, T_T4
T_T4: DB 3, 2, $18, 0, $18, $18, $18, 0: DW T_T3, T_T1
;-----------------------------------------------------------------------------------------


        INCLUDE "Printat.asm"
