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
	beq jmpGetKeyInput
	jsr CHROUT
	iny
	jmp printChars

moveMyChar:
	ldx #$08			; HERE FOR TESTING
	ldy #$10			; HERE FOR TESTING (moves goomba)
moveRight:		; store address of characters to move right in x and y
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
	bne moveRight
	
	ldx #0
	lda #$10	; overlap space with all mario places
overlapSetUp:
	sta overChars,X
	inx
	cpx #4
	bne overlapSetUp
	jmp marioOverlap
	
jmpGetKeyInput:
	jmp getKeyInput
	
	
	
marioOverlap:	; 4 character starting locations, top left, top right, bottom left and bottom right collision chars (-$1D00) stored in overChars
	lda #0			; counter for mario char to add to overlap
	sta countChar
	sta countPixel
OverlapLoop:
	ldx countChar
	lda marMem,X		; mar[countChar] memory location
	clc
	adc countPixel
	tax
	ldy GRAPHSTART2,X	; countPixel row of pixels in countChar area of Mario
	ldx countChar
	lda overChars,X		; overChars[countChar] memory location
	clc
	adc countPixel		; memory location of overlapping countPixel row of pixels in countChar area of overlapChars
	tax	
	tya
	ora GRAPHSTART2,X	; new row of pixels
	tay
	ldx countChar
	lda overMem,X		; overMem[countChar] memory location
	clc
	adc countPixel		; memory location of overlapping countPixel row of pixels in countChar area of overlapChars
	tax
	tya
	sta GRAPHSTART2,X
	inc countPixel
	lda countPixel
	cmp #8				; if more rows of pixels are needed
	bne OverlapLoop		; go and loop again
	lda #0				; reset pixel rows count
	sta countPixel
	inc countChar
	lda countChar
	cmp #4				; if more characters need to be overlapped
	bne OverlapLoop		; go and loop again	
	
	jmp getKeyInput
jmpMoveMyChar:
	jmp moveMyChar
	
charCollision:
	lda #0			; counter for mario char to add to overlap
	sta countChar
	sta countPixel
collisionLoop:
	ldx countChar
	lda marMem,X		; mar[countChar] memory location
	clc
	adc countPixel
	tax
	ldy GRAPHSTART2,X	; countPixel row of pixels in countChar area of Mario
	ldx countChar
	lda overChars,X		; overChars[countChar] memory location
	clc
	adc countPixel		; memory location of overlapping countPixel row of pixels in countChar area of overlapChars
	tax	
	tya
	and GRAPHSTART2,X	; if any bits of Accumulator set then collision has occured

	bne collisionOccured
	
	inc countPixel
	lda countPixel
	cmp #8				; if more rows of pixels are needed
	bne collisionLoop		; go and loop again
	lda #0				; reset pixel rows count
	sta countPixel
	inc countChar
	lda countChar
	cmp #4				; if more characters need to be overlapped
	bne collisionLoop		; go and loop again	
	jmp getKeyInput
	
collisionOccured:
	lda #'@
	jsr CHROUT
	jmp donePrg
	
	
	
getKeyInput:
	lda #0
	jsr	CHRIN
	cmp #'W		; if w pressed 
	beq jmpMoveMyChar
	cmp #'C		; if c pressed 
	beq charCollision
	jmp getKeyInput
	
donePrg:
	jmp donePrg

chars:
	.byte "& <> & '* & +- &      ","& () & /= &    &      &    & !",'","             &    &                ", 0

marMem:
	.byte $E0,$F0,$40,$48, 0	; Starts at $1DE0, $1DF0, $1D40 and $1D48
overMem:
	.byte $38,$50,$78,$E8, 0	; Starts at $1D38, $1D50, $1D78, $1DE8
overChars:
	.byte $00,$00,$00,$00, 0

countChar:
	.byte $0, 0
countPixel:
	.byte $0, 0

;	.byte "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[] !", '", "#$%&'()*+,-./0123456789:;<=>?", 0
;	#		== empty box
; 	$		== coin box
;	&		== solid box
;	?		== question box

;	! "		== goomba
;	+ -		== koopa1
;	, .		== koopa2

;	' *		== mario + colliding entity
;	/ =

;	< >		== mario
;	( )

; UNUSED:	% : ;
; Reserving 0-9
; Can't use ABCDEFGHIJKLMNOPQRSTUVWXYZ @ []




	
	
