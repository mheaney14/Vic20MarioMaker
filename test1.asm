

	
	;.segment	"BASIC"
	processor 6502
	org $1001	
;	.word	RUN
	
;RUN:	.word	@end

	dc.w basicend
	dc.w 2010
	dc.b $9e
	
	dc.a " "
	dc.a "4110"
	dc.b 0
	
	
;	.byte	<(MAIN / 1000 .mod 10) + $30
;	.byte	<(MAIN / 100 .mod 10) + $30
;	.byte	<(MAIN / 10 .mod 10) + $30
;	.byte	<(MAIN / 1 .mod 10) + $30
;	.byte	0		

	
;	.segment "STARTUP"

basicend	
		dc.w 0



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
	jmp end
	
start:
	rts