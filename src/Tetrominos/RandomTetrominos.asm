
;-----------------------------------------------------------------------------------------
; RANDOM_NUMBER - Generate a random number between 0 and 19.
;	  OUT - IX = Random tetromino.
;-----------------------------------------------------------------------------------------
RANDOM_NUMBER:
    LD A, R               ; Generate a random number between 0 and 255.
    AND 31                ; Mask out the lower 5 bits.
    CP 19                 ; Is the number between 0 and 19?
    JR C, CONTINUE_RANDOM ; Yes, continue.
    SUB 19                ; No, subtract 19.
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; CONTINUE_RANDOM - Generate a random tetromino.
;   IN - A = Random number between 0 and 19.
;   OUT - IX = Random tetromino.
;-----------------------------------------------------------------------------------------
CONTINUE_RANDOM:
    LD IX, T_0              ; Set IX to the first tetromino.
    LD DE, TETROMINO_WIDTH  ; Set DE to the width of a tetromino.
    OR A
    JR Z, END_RANDOM ; If Z flag is set, return.
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; OTHER - Generate a random tetromino between the 2nd and last tetromino.
;   IN - A = Random number between 0 and 19.
;        IX = First tetromino memory address.
;        DE = Width of a tetromino.
;   OUT - IX = Random tetromino.
;-----------------------------------------------------------------------------------------
OTHER:
    ADD IX, DE            ; Add the width of a tetromino to IX.
    DEC A                 ; Decrement A.
    JR NZ, OTHER          ; If A is not zero, continue.
;-----------------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------------
; END_RANDOM - Return.
;-----------------------------------------------------------------------------------------
END_RANDOM:
    RET
;-----------------------------------------------------------------------------------------
