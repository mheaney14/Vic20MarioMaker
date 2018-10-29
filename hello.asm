CHROUT	= $FFD2
CHRIN	= $FFE4

	processor 6502
	org $1001

	dc.w basicend
	dc.w 1234			;line number for sys instruction (arbitrary?)
	dc.b $9e, "4109"	;sys instruction and memory location
	dc.b 0				; end of instruction
basicend	
		dc.w 0	;end of basic program
		
start:		
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