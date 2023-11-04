; -------------------------------
; ZX Spectrum Text print library
; Daniel León - AOC - UFV 2020
; -------------------------------


; ----------------------------------------------------------------------------------------   
; PRINTAT - Print a string in a position and attributes as per registers:
;		IN	A	: Bit 7=1 For Flash / Bit 6=1 For Brigh / Bit 5,4,3 for Paper / Bit 2,1,0 for Ink
;		IN	B	: Row 0..23
;		IN	C	: Column 0..31
;		IN	IX	: Address of text (Text must end in a 0)
; ---------------------------------------------------------------------------------------- 
PRINTAT:	CALL PREP_PRT				; Update Attribute var &Screen & Attributes pointers
; ---------------------------------------------------------------------------------------- 
;		VVV Do not move PRINTSTR below as PRINTAT continues into PRINTSTR routine
; ----------------------------------------------------------------------------------------   
; PRINTSTR - Prints String - IX Points to the String start
; ----------------------------------------------------------------------------------------      
PRINTSTR:   LD A,(IX)					; A Contains first char to print
			OR A						; check for end of string (0)
			RET Z						; Finish printing if 0
			CALL PRINTCHNUM			
			INC IX						; Move to next char in string
			JR PRINTSTR					; Start over printing sequence	
; ----------------------------------------------------------------------------------------  


;-----------------------------------------------------------------------------------------
; PREP_PRT - Updates Print_Attr, SCR & ATTR Vars
;-----------------------------------------------------------------------------------------
PREP_PRT:	LD (PRINT_ATTR),A			; Set Attribute
PREP_PRT_2:	CALL CRtoSCREEN
			JP CRtoATTR				
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; CRtoSCREEN - Converts a scr char coord into a SCREEN Address   b,c = y,x positions
;	IN  - B=Row, C=Column
;	OUT - HL=Address in screen also stored in (SCR_CUR_PTR)
;	Conversion:
;			Row FFfff   Column CCCCC
;			HL=%010FF000 fffCCCCC
;-----------------------------------------------------------------------------------------
CRtoSCREEN:
			LD A,B						; %___FFfff
			OR #40						; %010FFfff
			AND #F8						; %010FF000
			LD H,A
	
			LD A,B						; %___FFfff
			AND #7						; %00000fff
			RRCA						; %f00000ff
			RRCA						; %ff00000f
			RRCA						; %fff00000
			OR C						; %fffCCCCC
			LD L,A
            LD (SCR_CUR_PTR),HL			; Update Variable
            RET
; ---------------------------------------------------------------------------------------- 



;-----------------------------------------------------------------------------------------
; CRtoATTR - Converts a screen char coord  into a ATTR Address  b,c = y,x positions
;	IN  - B=Row, C=Column
;	OUT - HL=Address in screen also stored in (SCR_ATTR_PTR)
;	Conversion:
;			Row FFfff   Column CCCCC
;			HL=%010110FF fffCCCCC
;-----------------------------------------------------------------------------------------
CRtoATTR:	
			LD A,B						; %___FFfff
			RRCA						; %f000FFff
			RRCA						; %ff000FFf
			RRCA						; %fff000FF
			LD L,A
			AND 3						; %000000FF	value of FF can be only 00,01,10
			OR #58						; %010110FF value will be #58, #59 or #5A
			LD H,A

			LD A,L						; %fff000FF
			AND #E0						; %fff00000
			OR C						; %fffCCCCC
			LD L,A

            LD (SCR_ATTR_PTR),HL		; Update Variable
            RET
; ----------------------------------------------------------------------------------------



; ----------------------------------------------------------------------------------------   
; PRINTCHNUM - Prints Char Number N (stored in A)
;----------------------------------------------------------------------------------------- 
PRINTCHNUM:	;SUB 32						; Adjust Ascii to charset
			LD H,0						; Multiply value by 8 to get to right Char in Charset
			LD L,A
			ADD HL,HL
			ADD HL,HL
			ADD HL,HL
			LD DE, CHARSET-(8*32)		; Optimize in compile time (instead of sub 32)
			ADD HL,DE
			EX  DE,HL					;Value in DE
			; Continues to printchar below
; ----------------------------------------------------------------------------------------

		
; ----------------------------------------------------------------------------------------   
; PRINTCHAR - Prints Char  (DE points to the char. Uses HL as last Cur Pointer)
; ----------------------------------------------------------------------------------------  
PRINTCHAR:
			LD B,8						; 8 Lines per char
            LD HL, (SCR_CUR_PTR)		; Load Cursor Pointer y,x 
            
BYTEPCHAR:	LD A,(DE)					; Get Char to be printed, first line
			LD (HL),A					; Move to Printing location           
            INC H						; inc H so next line in char (ZX Spectrum Screen RAM)
            INC DE 						; next line to be printed
            DJNZ BYTEPCHAR				; Repeat 8 lines
            LD A,(PRINT_ATTR) 			; Load Attributes to print char with
            LD HL, (SCR_ATTR_PTR)		
            LD (HL),A
            LD HL, SCR_ATTR_PTR			; Get pointer to ATTR
            INC (HL)					; Move Attribute cursor to next char
			LD HL, SCR_CUR_PTR
			INC (HL)					; update Cursor pointer to next position
            RET
; ----------------------------------------------------------------------------------------  



; ----------------------------------------------------------------------------------------   
; INK2PAPER - moves ink of attribute stored in (PRINT_ATTR) to paper and sets ink to 0
; 				Sets bright 1 and flash 0
; ---------------------------------------------------------------------------------------- 
INK2PAPER:	LD A, (PRINT_ATTR)		    ; Get storedAttribute         
            AND 7						; get Attr INK in A
			RLCA
			RLCA
			RLCA						; move Ink to Paper
			OR 64						; ink 0 bright 1
			LD (PRINT_ATTR),A		    ; Get storedAttribute     
			RET
; ---------------------------------------------------------------------------------------- 




CLEARSCR:	LD HL,$4000					; Erases screen by writing 0 to all pixels and attributes
			LD DE,$4001
			LD BC,6911
			LD (HL),0
			LDIR
			RET


SCR_CUR_PTR : 	db $00, $00				; Cursor Pointer in Screen (2 bytes) (HL)
SCR_ATTR_PTR: 	db $00, $00				; Attr Pointer in Screen (2 bytes) (HL)
PRINT_ATTR:		db $00					; Attribute used by printchar routine (1 byte)

CHARSET: incbin "charset.bin"			; Charset used

