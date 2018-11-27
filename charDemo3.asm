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

; Koopa characters represented by alternating '+ with '-, and ', with '.
	; Starts at $1D58, $1D68, $1D60 and $1D70
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
; Mario + colliding entity will be stored in '', '*, '/, or '= (top left, top right, bottom left, bottom right)
	; Starts at $1D38, $1D50, $1D78, $1DE8

setNewChars:
	lda #$02
	sta $1D58
	lda #$10
	sta $1D5D
	sta $1D6C
	lda #$18
	sta $1D0A
	sta $1D0E
	sta $1D42
	lda #$1C
	sta $1D5B
	lda #$1E
	sta $1D6A
	lda #$24
	sta $1D0F
	sta $1D46
	lda #$28
	sta $1D5E
	sta $1D5F
	sta $1D6D
	sta $1D6E
	lda #$30
	sta $1D68
	lda #$36
	sta $1D59
	sta $1D5A
	lda #$37
	sta $1D69
	lda #$3C
	sta $1D0B
	sta $1D40
	sta $1D41
	sta $1D44
	sta $1D45
	lda #$70
	sta $1D5C
	sta $1D6B
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
	sta $1D6F
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
	ldx #$40			; HERE FOR TESTING
	ldy #$48			; HERE FOR TESTING
moveRight2:		; store address of characters to move right in x and y
	lda #$01
	and GRAPHSTART2,Y
	lsr			; set carry bit to bit 0 of Y (automatically uses accumulator)
	ror GRAPHSTART2,X
	txa
	pha			; push X to stack
	tya
	tax			; put Y in X register
	ror GRAPHSTART2,X
	pla
	tax			; put X back from stack
	inx			; move next line of character
	iny
	txa
	and #$07	; if more lines need to be done (x ends with a number 1-7 or 9-F, 0/8 => done)
	bne moveRight2

	; Starts at $1DE0, $1DF0, $1D40 and $1D48 (Mario)
	; Starts at $1D38, $1D50, $1D78 and $1DE8 (Mario + other entities)
marioOverlap:		; top of stack should hold 4 character starting locations, top left, top right, bottom left and bottom right collision chars (-$1D00)
	
	ldy #0
overlapInitLoop:		; puts just mario into overlap char memory
	lda $1DE0,Y
	sta $1D38,Y
	lda $1DF0,Y
	sta $1D50,Y
	lda $1D40,Y
	sta $1D78,Y
	lda $1D48,Y
	sta $1DE8,Y
	iny
	cpy #8
	bne overlapInitLoop	; after this have mario only in collision char memory
	lda #0
	pha					; start with 0 (iteration number for overlapCharLoop1) on top of stack
overlapCharLoop1:
	pla					; get iteration number
	tay
	pla					; get next char to do overlap with
	tax
	iny
	tya
	pha					; store next iteration number
	dey
	tya
	cmp #0
	bne overlapCheck2
	ldy #$38
	jmp overlapCharLoop2
overlapCheck2:
	cmp #1
	bne overlapCheck3
	ldy #$50
	jmp overlapCharLoop2
overlapCheck3:
	cmp #2
	bne overlapCheck4
	ldy #$78
	jmp overlapCharLoop2
overlapCheck4:
	cmp #3
	bne getKeyInput
	ldy #$E8
overlapCharLoop2:
	lda $1D00,X			; row of pixels of overlap char	
	and $1D00,Y			; bitwise and with mario
	cmp #0
	; set memory location triggering collision / branch to collision code
	ora $1D00,Y			; bitwise or with mario
	sta $1D00,Y			; store new overlapped mario image
	inx
	cpx #8
	bne overlapCharLoop2
	jmp overlapCharLoop1
	
	
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





	
	
	