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

	ldx #$0
loadNewChars:
	lda newChars1,X
	sta GRAPHSTART2,X
	inx
	cpx #$81
	bne loadNewChars
	ldx #$E0
	ldy #$0
loadNewChars2:
	lda newChars2,Y
	sta GRAPHSTART2,X
	inx
	iny
	cpy #$20
	bne loadNewChars2

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
	
newChars1:									;	start replacing at GRAPHSTART2
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	SPACE ' 
	.byte	$00,$00,$18,$3C,$7E,$7E,$18,$24	;	GOOMBA_1 '!
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	GOOMBA_2 '"
	.byte	$FF,$81,$81,$81,$81,$81,$81,$FF	;	BOX '#
	.byte	$FF,$81,$99,$B5,$AD,$99,$81,$FF	;	COIN_BLOCK '$
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	UNUSED '%
	.byte	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	;	SOLID_BLOCK '&					
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	MARIO_COLLIDING_TL ''			
	.byte	$3C,$3C,$18,$FF,$3C,$3C,$24,$C3	;	MARIO_BL '(								********** FIX
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	MARIO_BR ')						
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	MARIO_COLLIDING_TR '*
	.byte	$02,$36,$36,$1C,$70,$10,$28,$28 ;	KOOPA_1A '+
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	KOOPA_2A ',
	.byte	$30,$37,$1E,$70,$10,$28,$28,$00	;	KOOPA_1B '-
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	KOOPA_2B '.
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	MARIO_COLLIDING_BL '/
	
	; NUMBERS WOULD GO HERE BUT DON'T NEED TO REPLACE

newChars2:									;	start replacing at GRAPHSTART2 + $E0
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	MARIO_TL '<
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	MARIO_COLLIDING_BR '=
	.byte	$00,$00,$00,$00,$00,$00,$00,$00	;	MARIO_TR '>
	.byte	$FF,$81,$9D,$A5,$89,$81,$91,$FF	;	QUESTION_BLOCK '?
	
	
; UNUSED:	% : ;
; Reserving 0-9
; Can't use ABCDEFGHIJKLMNOPQRSTUVWXYZ @ []

	
	
	