CHROUT	= $FFD2
CHRIN	= $FFE4
VIC 	= $9000

setwavefrequency = $59
setwaveshiftreg = $60

		PROCESSOR 6502
		.org $1100

start:	
	; jsr	$e55f
	; lda	#'H	;H
	; jsr	CHROUT
	; lda	#'E	;E
	; jsr	CHROUT
	; lda	#'L	;L
	; jsr	CHROUT
	; lda	#'L	;L
	; jsr	CHROUT
	; lda	#'O	;O
	; jsr	CHROUT
	; lda	#' 	;space
	; jsr	CHROUT
	; lda	#'W	;W
	; jsr	CHROUT
	; lda	#'O	;O
	; jsr	CHROUT
	; lda	#'R	;R
	; jsr	CHROUT
	; lda	#'L	;L
	; jsr	CHROUT
	; lda	#'D	;D
	; jsr	CHROUT
	; lda	#'!	;!
	; jsr	CHROUT
	
	jsr $E55F
    lda #8        ; screen and border colors
    sta 36879

	ldx #0                 ; clrscr
cll:
    lda #32+128
    sta 7680,x      ; screen memory
    sta 7680+256,x
    dex
    bne cll

ldx #21
brick:
	lda #3
	sta 38400 + 0,x
	lda #2
	sta 38400 + 22,x
	lda #3
	sta 38400 + 23,x
	lda #2
	sta 38400 + 1,x

end:
	jmp end
	rts