CHROUT		= $FFD2
CHRIN		= $FFE4
CLEARSCREEN = $E55F
GRAPHSTART1	= $1C00
GRAPHSTART2	= $1D00


	processor 6502
	org $1001

	dc.w basicend
	dc.w 1234			;line number for sys instruction (arbitrary?)
	dc.b $9e, "4109"	;sys instruction and memory location
	dc.b 0				; end of instruction
basicend	
		dc.w 0	;end of basic program
		

	lda #28
	sta $34
	sta $36			; the above 3 lines cause memory not to be used for code (used for storing 64 new characters)
	
	; this stores the regular set of characters, we can then swap new ones in their places
	; for x = $0 to $FF get from $8000+x, store at $1C00+x (should get all characters in 1st set)
	; for x = $0 to $FF get from $8100+x, store at $1D00+x (should get all characters in 2nd set)
	ldx #$0
loadChar1:
	lda $8000,X		; load x from ROM
	sta GRAPHSTART1,X		; store previous char in RAM
	inx				; increment x (note X is 2 bytes so this value will become 0 after $FF iterations)
	bne loadChar1
loadChar2:
	lda $8100,X
	sta GRAPHSTART2,X
	inx
	bne loadChar2
	
	lda #$FF
	sta $9005		; characters are stored at $1C00 - $1DFF and use 8 bytes of memory each

;******************* Start of Graphics *******************
; characters are 8 bytes
; each byte in binary represents a line of the char (1 => pixel on, 0 => pixel off)

; Koopa characters represented by alternating '[ with '], and ', with '.
	; Starts at $1CD8, $1CE8, $1D60 and $1D70
; Goomba characters represented by '! and '"
	; Starts at $1D08, and $1D10
; Empty Box characters represented by '#
	; Starts at $1D18
; Coin Box characters represented by '$
	; Starts at $1D20
; Full Box characters represented by '&
	; Starts at $1D30
; Question Box characters represented by '?
	; Starts at 1DF8
; Mario Character represented by '<, '>, '(, and ') (top left, top right, bottom left, bottom right)
	; Starts at $1DE0, $1DF0, $1D40 and $1D48

setNewChars:
	lda #$02
	sta $1CD8
	lda #$10
	sta $1CDD
	sta $1CEC
	lda #$18
	sta $1D0A
	sta $1D0E
	sta $1D42
	lda #$1C
	sta $1CDB
	lda #$1E
	sta $1CEA
	lda #$24
	sta $1D0F
	sta $1D46
	lda #$28
	sta $1CDE
	sta $1CDF
	sta $1CED
	sta $1CEE
	lda #$30
	sta $1CE8
	lda #$36
	sta $1CD9
	sta $1CDA
	lda #$37
	sta $1CE9
	lda #$3C
	sta $1D0B
	sta $1D40
	sta $1D41
	sta $1D44
	sta $1D45
	lda #$70
	sta $1CDC
	sta $1CEB
	lda #$7E
	sta $1D0C
	sta $1D0D
	lda #$81
	sta $1D19
	sta $1D1A
	sta $1D1B
	sta $1D1C
	sta $1D1D
	sta $1D1E
	sta $1D21
	sta $1D26
	sta $1DF9
	sta $1DFD
	lda #$89
	sta $1DFC
	lda #$91
	sta $1DFE
	lda #$99
	sta $1D22
	sta $1D25
	lda #$9D
	sta $1DFA
	lda #$A5
	sta $1DFB
	lda #$AD
	sta $1D24
	lda #$B5
	sta $1D23
	lda #$C3
	sta $1D47
	lda #$FF
	sta $1D18
	sta $1D1F
	sta $1D20
	sta $1D27
	sta $1D30
	sta $1D31
	sta $1D32
	sta $1D33
	sta $1D34
	sta $1D35
	sta $1D36
	sta $1D37
	sta $1D43
	sta $1DF8
	sta $1DFF

	lda #0
	sta $1CEF
	sta $1D08
	sta $1D09
	ldx #0
set2ndChars:		; all these start initially blank
	sta $1D60,X		; Koopa 1 right side
	sta $1D70,X		; Koopa 2 right side
	sta $1D10,X		; Goomba right side
	sta $1D48,X		; Mario right down
	sta $1DE0,X		; Mario left up
	sta $1DF0,X		; Mario right up
	inx
	cpx #8
	bne set2ndChars

;******************* End of Graphics *******************

	jsr CLEARSCREEN
	ldy #0
printChars:
	lda chars,Y
	cmp #0			; if there is more to print
	beq getKeyInput
	jsr CHROUT
	iny
	jmp printChars

moveMyChar:
	ldx #$10			; HERE FOR TESTING
	ldy #$C0			; HERE FOR TESTING
moveDown1:
	lda #0
	asl			; set carry bit to 0 (automatically uses accumulator)
	txa
	adc #7		; shouldn't set carry bit
	tax			; x = input+7
	tya
	adc #7		;shouldn't set carry bit
	tay			; y = input+7
	lda GRAPHSTART1,Y
	pha			; push value at input Y + 7 to stack
	txa
	pha			; pushed input X + 7 to stack
	tya
	tax
	dex			; X = Y-1 (Y=inputY+7, X=Y-1)
	lda GRAPHSTART1,X	; load at Y-1
	sta GRAPHSTART1,Y	; store at Y
down1Loop1:
	dex			; decrement to move to next line up
	dey
	lda GRAPHSTART1,X	; load at Y-1
	sta GRAPHSTART1,Y	; store at Y
	txa
	and #7		; stop looping when last 3 bits of y are 0
	bne down1Loop1
	dex			; decrement to move to next line up
	dey
	lda GRAPHSTART1,X	; load at Y-1
	sta GRAPHSTART1,Y	; store at Y
	pla
	tax			; input X+7 is back from stack
	lda GRAPHSTART1,X
	sta GRAPHSTART1,Y
	txa
	tay
	dey			; Y = X-1
down1Loop2:
	lda GRAPHSTART1,Y	; load at X-1
	sta GRAPHSTART1,X ; store at X
	dex			; decrement to move to next line up
	dey
	tya
	and #7		; stop looping when last 3 bits of x are 0
	bne down1Loop2
	lda GRAPHSTART1,Y	; load at X-1
	sta GRAPHSTART1,X ; store at X
	dex
	pla
	sta GRAPHSTART1,X


	
getKeyInput:
	lda #0
	jsr	CHRIN
	cmp #'W		; if w pressed 
	beq moveMyChar
	jmp getKeyInput
	
donePrg:
	jmp donePrg

chars:
	.byte "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[] !", '", "#$%&'()*+,-./0123456789:;<=>?", 0	;note first 8 characters are replaced by custom ones
	





	
	
	