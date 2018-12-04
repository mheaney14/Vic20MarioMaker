CHROUT		= $FFD2
CHRIN		= $FFE4
CLEARSCREEN = $E55F
GRAPHSTART1	= $1C00
GRAPHSTART2	= $1D00
RDTIM = $FFDE

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

	


; moveMyChar:
; 	ldx #$08			; HERE FOR TESTING
; 	ldy #$10			; HERE FOR TESTING (moves goomba)
; moveRight:		; store address of characters to move right in x and y
; 	lda #$01
; 	and GRAPHSTART2,Y
; 	lsr			; set carry bit to bit 0 of Y (automatically uses accumulator)
; 	ror GRAPHSTART2,X
; 	txa
; 	pha			; push X to stack
; 	tya
; 	tax			; put Y in X register
; 	ror GRAPHSTART2,X
; 	pla
; 	tax			; put X back from stack
; 	inx			; move next line of character
; 	iny
; 	txa
; 	and #$07	; if more lines need to be done (x ends with a number 1-7 or 9-F, 0/8 => done)
; 	bne moveRight
	
; 	ldx #0
; 	lda #$10	; overlap space with all mario places
; overlapSetUp:
; 	sta overChars,X
; 	inx
; 	cpx #4
; 	bne overlapSetUp
; 	jmp marioOverlap
	
; marioOverlap:	; 4 character starting locations, top left, top right, bottom left and bottom right collision chars (-$1D00) stored in overChars
; 	lda #0			; counter for mario char to add to overlap
; 	sta countChar
; 	sta countPixel
; OverlapLoop:
; 	ldx countChar
; 	lda marMem,X		; mar[countChar] memory location
; 	clc
; 	adc countPixel
; 	tax
; 	ldy GRAPHSTART2,X	; countPixel row of pixels in countChar area of Mario
; 	ldx countChar
; 	lda overChars,X		; overChars[countChar] memory location
; 	clc
; 	adc countPixel		; memory location of overlapping countPixel row of pixels in countChar area of overlapChars
; 	tax	
; 	tya
; 	ora GRAPHSTART2,X	; new row of pixels
; 	tay
; 	ldx countChar
; 	lda overMem,X		; overMem[countChar] memory location
; 	clc
; 	adc countPixel		; memory location of overlapping countPixel row of pixels in countChar area of overlapChars
; 	tax
; 	tya
; 	sta GRAPHSTART2,X
; 	inc countPixel
; 	lda countPixel
; 	cmp #8				; if more rows of pixels are needed
; 	bne OverlapLoop		; go and loop again
; 	lda #0				; reset pixel rows count
; 	sta countPixel
; 	inc countChar
; 	lda countChar
; 	cmp #4				; if more characters need to be overlapped
; 	bne OverlapLoop		; go and loop again	
	
; 	jmp getKeyInput
; jmpMoveMyChar:
; 	jmp moveMyChar
	
; charCollision:
; 	lda #0			; counter for mario char to add to overlap
; 	sta countChar
; 	sta countPixel
; collisionLoop:
; 	ldx countChar
; 	lda marMem,X		; mar[countChar] memory location
; 	clc
; 	adc countPixel
; 	tax
; 	ldy GRAPHSTART2,X	; countPixel row of pixels in countChar area of Mario
; 	ldx countChar
; 	lda overChars,X		; overChars[countChar] memory location
; 	clc
; 	adc countPixel		; memory location of overlapping countPixel row of pixels in countChar area of overlapChars
; 	tax	
; 	tya
; 	and GRAPHSTART2,X	; if any bits of Accumulator set then collision has occured

; 	bne collisionOccured
	
; 	inc countPixel
; 	lda countPixel
; 	cmp #8				; if more rows of pixels are needed
; 	bne collisionLoop		; go and loop again
; 	lda #0				; reset pixel rows count
; 	sta countPixel
; 	inc countChar
; 	lda countChar
; 	cmp #4				; if more characters need to be overlapped
; 	bne collisionLoop		; go and loop again	
; 	jmp getKeyInput
	
; collisionOccured:
; 	lda #'@
; 	jsr CHROUT
; 	jmp end	
	
	
; getKeyInput:
; 	lda #0
; 	jsr	CHRIN
; 	cmp #'W		; if w pressed 
; 	beq jmpMoveMyChar
; 	cmp #'C		; if c pressed 
; 	beq charCollision
; 	jmp getKeyInput


	; jsr $e55f		; clear screen
start:		
	jsr CLEARSCREEN
    lda #0			; screen and border colors
    sta $900F
	lda #1			;Set the background of the character to white
	sta $286		;Store it in $286 memory

	;print out menu
	lda #' 
	ldx #$B2		; counter for number of spaces remaining
printSpacesMenu:
	jsr CHROUT		; print space
	dex
	cpx #0			; check if more spaces to print
	bne printSpacesMenu
	ldy #0


printMenu1:
	lda menuMessage1,Y
	cmp #0			; if there is more message to print
	beq donePrintMenu
	JSR CHROUT
	iny
	jmp printMenu1
	ldy #0
printMenu2:
	lda menuMessage2,Y
	cmp #0			; if there is more message to print
	beq donePrintMenu
	JSR CHROUT
	iny
	jmp printMenu2
	
donePrintMenu:
	lda #0
	jsr CHRIN
	cmp #0
	beq donePrintMenu
	
	ldx #0
	ldy #0
	jsr CLEARSCREEN

cll:				;Printing the white screen among the black background
    lda #32+128
    sta 7680,x      ; screen memory
    sta 7680+256,x
    dex
    bne cll

	lda #'*  			; load mario
	jsr CHROUT		; print char in accumulator
	lda #'/=' 
	jsr CHROUT
	
	lda #1
	sta $0110

main:
	lda #0
	jsr	CHRIN		;accept user input for test number 
	cmp #'W			; Branch to the coressponding key
	beq jumpToWKey
	cmp #'A
	beq jumpToAKey
	cmp #'S
	beq jumpToSKey
	cmp #'D
	beq jumpToDKey
	cmp #'Q
	beq jumpToQKey
	cmp #'N
	beq jumpToNKey
	jmp main		; If there is no input

mainEnd:
	jsr CLEARSCREEN
	jmp end

;The codes are too long that we can't directly branching out
jumpToWKey:
	lda #1
	sta $0101
	jmp jmpEnd
jumpToAKey:
	lda #2
	sta $0101
	jmp jmpEnd
jumpToSKey:
	lda #3
	sta $0101
	jmp jmpEnd
jumpToDKey:
	lda #4
	sta $0101
	jmp jmpEnd
jumpToQKey:
	lda #5
	sta $0101
	jmp jmpEnd
jumpToNKey:
	lda #6
	sta $0101
	jmp jmpEnd
jmpEnd:

nKey:				;Press N to create a new block
	ldy $0101
	cpy #6
	bne nkeyInput
	ldy #0
	lda $0113
	adc #1
	sta $0113
	ldx $0113
nKeyIncrease:
	inx
	iny
	iny
	iny
	cpx $0113
	bne nKeyIncrease
	iny
	lda $0111
	sta $0113,y
	iny 
	lda $0112
	sta $0113,y
	iny
	lda $0110
	sta $0113,y
	lda #0
	sta $0110
	lda #0
	sta $0111
	lda #0
	sta $0112
	; get input for the item index
nkeyInput:
	ldy $0101
	cpy #6
	bne qKey

	lda #0
	jsr	CHRIN
	cmp #'1
	beq Key1
	cmp #'2
	beq Key2
	cmp #'3
	beq Key3
	cmp #'4
	beq Key4
	cmp #'5
	beq Key5
	cmp #'6
	beq Key6
	cmp #'7
	beq Key7
	cmp #'8
	beq Key8
	jmp nkeyInput
Key1:					;Some extra function that needed to work on later
	lda #1
	sta $0110
	jmp nKeyEnd
Key2:
	lda #2
	sta $0110
	jmp nKeyEnd
Key3:
	lda #3
	sta $0110
	jmp nKeyEnd
Key4:
	lda #4
	sta $0110
	jmp nKeyEnd
Key5:
	lda #5
	sta $0110
	jmp nKeyEnd
Key6:
	lda #6
	sta $0110
	jmp nKeyEnd
Key7:
	lda #7
	sta $0110
	jmp nKeyEnd
Key8:
	lda #8
	sta $0110
nKeyEnd:
	jmp drawing

qKey:						;When user hit Q, quit the game and print end game message
	ldy $0101
	cpy #5
	bne dKey				;The codes are too long so how to do another branching
	jsr CLEARSCREEN			;clear screen
	LDY #0
	jmp printEndGameMessage
	jsr CLEARSCREEN
	jmp start

dKey:						;press D to move right
	ldy $0101
	cpy #4
	bne wKey
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
	lda #' 
	jsr CHROUT
	lda $0111
	cmp #255
	beq dKeyDown
	lda $0111
	adc #1
	sta $0111
	jmp drawing
dKeyDown:
	lda $0112
	cmp #255
	beq jumpToDrawing
	lda $0112
	adc #1
	sta $0112
	jmp drawing

wKey:
	ldy $0101
	cpy #1
	bne aKey
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
	lda #' 
	jsr CHROUT
	ldx #0
wKey1:
	lda $0112
	cmp #0
	beq wKey2
	lda $0112
	sbc #1
	sta $0112
	jmp wkeyEnd
wKey2:
	lda $0111
	cmp #0
	beq wkeyEnd
	lda $0111
	sbc #1
	sta $0111
wkeyEnd:
	cpx #21
	beq jumpToDrawing
	inx 
	jmp wKey1

jumpToDrawing:
	jmp drawing
	rts

aKey:
	ldy $0101
	cpy #2
	bne sKey
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
	lda #' 
	jsr CHROUT
	lda $0112
	cmp #0
	beq aKeyUp
	lda $0112
	sbc #1
	sta $0112
	jmp drawing
aKeyUp:
	lda $0111
	cmp #0
	beq drawing
	lda $0111
	sbc #1
	sta $0111
	jmp drawing

; offset is 242 to make it correctly
sKey:
	ldy $0101
	cpy #3
	bne sound
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
	lda #' 
	jsr CHROUT
	ldx #0
sKey1:
	lda $0111
	cmp #255
	beq sKey2
	lda $0111
	adc #1
	sta $0111
	jmp sKeyEnd
sKey2:
	lda $0112
	cmp #255
	beq sKeyEnd
	lda $0112
	adc #1
	sta $0112
sKeyEnd:
	cpx #21
	beq drawing
	inx
	jmp sKey1

sound:
	lda #168
	sta $900c		; -- effect sound if input
	lda #0
	sta $900c
	jmp	main

drawing:
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
decideSymbol:
	lda $0110
	cmp #1
	bne drawNext1
	lda #'@
	jmp drawingOut
drawNext1:
	cmp #2
	bne drawNext2
	lda #'[
	jmp drawingOut
drawNext2:
	cmp #3
	bne drawNext3
	lda #']
	jmp drawingOut
drawNext3:
	cmp #4
	bne drawNext4
	lda #'<			; -- change before compile
	jmp drawingOut
drawNext4:
	cmp #5
	bne drawNext5
	lda #'#
	jmp drawingOut
drawNext5:
	cmp #6
	bne drawNext6
	lda #'&
	jmp drawingOut
drawNext6:
	cmp #7
	bne drawNext7
	lda #'$
	jmp drawingOut
drawNext7:
	lda #'?

drawingOut:
	jsr CHROUT
	jmp sound 

printEndGameMessage:				;Print end game message
	LDA endGameMessage,Y
	CMP #0
	BEQ endPrintEndGameMessage
	JSR	CHROUT
	INY 
	jmp printEndGameMessage
endPrintEndGameMessage:
	lda #0
	jsr CHRIN
	BEQ endPrintEndGameMessage
	jmp end

end:
	jmp end
		
endGameMessage:
	.byte "END GAME", 0
menuMessage1:
	.byte "SUPER MARIO MAKER   PRESS ANY KEY TO PLAY", 0	
menuMessage2:
	.byte " PRESS ANY KEY TO PLAY  ", 0	

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
