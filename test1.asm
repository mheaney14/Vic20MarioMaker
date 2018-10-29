
	processor 6502
	org $1001	


	dc.w basicend
	dc.w 1234			;line number for sys instruction (arbitrary?)
	dc.b $9e, "4109"	;sys instruction and memory location
	dc.b 0				; end of instruction
basicend	
		dc.w 0	;end of basic program



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
	rts
	
