

	
	;.segment	"BASIC"
	processor 6502
	org $1100	
;	.word	RUN
	
;RUN:	.word	@end

	dc.w basicend
;	dc.w 1234

	
	
	dc.w 4362	;memory address where assembly starts (org + size of everthing loaded)
	dc.w " "	;space between sys and memory location (?)
	dc.b $9e	;sys instruction


	dc.w 0		;0 to terminate instruction
	
	
;	.byte	<(MAIN / 1000 .mod 10) + $30
;	.byte	<(MAIN / 100 .mod 10) + $30
;	.byte	<(MAIN / 10 .mod 10) + $30
;	.byte	<(MAIN / 1 .mod 10) + $30
;	.byte	0		

	
;	.segment "STARTUP"

basicend	
		dc.b 0	;end of basic program



MAIN:	
	jsr	$e55f
	lda	#'H	;H
	jsr	$ffd2
	lda	#'E	;E
	jsr	$ffd2
	lda	#'L	;L
	jsr	$ffd2
	lda	#'L	;L
	jsr	$ffd2
	lda	#'O	;O
	jsr	$ffd2
	lda	#' 	;space
	jsr	$ffd2
	lda	#'W	;W
	jsr	$ffd2
	lda	#'O	;O
	jsr	$ffd2
	lda	#'R	;R
	jsr	$ffd2
	lda	#'L	;L
	jsr	$ffd2
	lda	#'D	;D
	jsr	$ffd2
	lda	#'!	;!
	jsr	$ffd2
	
end:
	rts
	
start:
	rts