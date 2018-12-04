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
	beq donePrintMenuInit
	JSR CHROUT
	iny
	jmp printMenu1


donePrintMenuInit:
	ldx #12
	stx $1000
donePrintMenu:
	ldx $1000
	ldy #3
	clc
	jsr $fff0
	lda #'@
	jsr CHROUT

	lda #0
	jsr CHRIN
	cmp #'S
	beq menuDown
	cmp #'W
	beq menuUp
	cmp #' 
	beq menuSelect
	jmp donePrintMenu

menuUp:
	lda $1000
	cmp #12
	beq MenuUpEnd
	ldx $1000
	ldy #3
	clc
	jsr $fff0
	lda #' 
	jsr CHROUT
	ldx $1000
	dex 
	dex
	stx $1000
	jmp donePrintMenu
MenuUpEnd:
	ldx $1000
	ldy #3
	clc
	jsr $fff0
	lda #' 
	jsr CHROUT
	lda #16
	sta $1000
	jmp donePrintMenu

menuDown:
	lda $1000
	cmp #16
	beq MenuDownEnd
	ldx $1000
	ldy #3
	clc
	jsr $fff0
	lda #' 
	jsr CHROUT
	lda $1000
	adc #2
	sta $1000
	jmp donePrintMenu
MenuDownEnd:
	ldx $1000
	ldy #3
	clc
	jsr $fff0
	lda #' 
	jsr CHROUT
	lda #12
	sta $1000
	jmp donePrintMenu
menuSelect:
	lda $1000
	cmp #12
	beq toPlayMode
	cmp #14
	beq toCreateMode
; 	cmp #16
; 	beq toPlayCreated
toPlayMode:
	jmp playModeInit
toCreateMode:
	jmp createMode
; toPlayCreated:
; 	jmp PlayCreated

;***********************************************************
;Enter the play mode
playModeInit:
	ldx #0
	ldy #0
	jsr CLEARSCREEN
	

	ldx #0
	ldy #0
	clc
	jsr $FFF0
	ldy #0
printMap1:
	lda GameMap1,y
	cmp #0			
	beq printMap1RestInit
	JSR CHROUT
	iny
	jmp printMap1
printMap1RestInit:
	ldy #0
printMap1Rest:
	lda GameMap1+243,y
	cmp #0			
	beq printMap1FinalInit
	JSR CHROUT
	iny
	jmp printMap1Rest
printMap1FinalInit:
	ldy #0
printMap1Final:
	lda GameMap1+486,y
	cmp #0			
	beq printMap1End
	JSR CHROUT
	iny
	jmp printMap1Final
printMap1End:
	ldx #21
	ldy #43
	clc 
	jsr $fff0
	lda #'&
	jsr CHROUT
	
	ldx #3
	stx $1003
	jsr displayLives

	jmp end


displayLives:
	ldx $1003
	cpx #1
	beq drOneLife
	cpx #2
	beq drOneLife
	cpx #3
	beq drThreeLife
	jmp drLifeDone
drThreeLife:
	ldx #0
	ldy #2
	clc 
	jsr $FFF0
	lda #'@
	jsr CHROUT
drTwoLife:
	ldy #1
	clc 
	jsr $FFF0
	lda #'@
	jsr CHROUT
drOneLife:
	ldy #0
	clc
	jsr $FFF0
	lda #'@
	jsr CHROUT
drLifeDone:
	rts

createMode:				;Printing the white screen among the black background
	jsr CLEARSCREEN


	ldy #-1
	jsr drawingBlock

	ldx #0
	stx $1006
	ldy #0
	sty $1007
	ldx $1006
	ldy $1007
	clc
	jsr $FFF0
	lda #'@			; load mario
	jsr CHROUT		; print char in accumulator



main:
	jsr	music
	jmp userInput
drawingBlock:
	cpy #43
	bne drawingBlockLoop
	rts

drawingBlockLoop:
	iny
	ldx #21
	CLC
	JSR $FFF0
	lda #'#
	jsr CHROUT
	jmp drawingBlock

userInput:
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


waitLoop:
	iny 
	cpy #20
	bne waitLoop
	rts

music:
	lda #0
	sta $900e
	lda #159
	sta $900c
	ldy #0	
	jsr waitLoop
	lda #179
	sta $900c
	ldy #0
	jsr waitLoop
	lda #199
	sta $900c
	ldy #0
	jsr waitLoop
	rts

mainEnd:
	jsr CLEARSCREEN
	jmp end

;The codes are too long that we can't directly branching out
jumpToWKey:
	jmp wKey
jumpToAKey:
	jmp aKey
jumpToSKey:
	jmp sKey
jumpToDKey:
	jmp dKey
jumpToQKey:
	jmp qKey
jumpToNKey:
	jmp nKey

nKey:				;Press N to create a new block
	;Saving the x position to stack, increment stack counter
	ldx $1011
	lda $D1 
	sta $1013,x
	ldx $1011
	inx 
	stx $1011

	ldx $1011
	lda $D3 
	sta $1013,x 
	ldx $1011 
	inx 
	stx $1011

nKeyIncrease:
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
	jmp drawing
Key2:
	lda #2
	sta $0110
	jmp drawing
Key3:
	lda #3
	sta $0110
	jmp drawing
Key4:
	lda #4
	sta $0110
	jmp drawing
Key5:
	lda #5
	sta $0110
	jmp drawing
Key6:
	lda #6
	sta $0110
	jmp drawing
Key7:
	lda #7
	sta $0110
	jmp drawing
Key8:
	lda #8
	sta $0110
	jmp drawing


qKey:						;When user hit Q, quit the game and print end game message
	jsr CLEARSCREEN			;clear screen
	LDY #0
	jmp printEndGameMessage
	jsr CLEARSCREEN
	jmp start

dKey:						;press D to move right
	ldx $1006
	ldy $1007
	clc
	jsr $FFF0
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
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
	lda #' 
	jsr CHROUT
	ldx #0
wKey1:
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
	jmp userInput 

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
	.byte "SUPER MARIO MAKER ?                                                                         PLAY MODE                                  CREATE MODE                                 PLAY CREATED", 0

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
	
MARIO_C:
	.byte "'*/="
MARIO_OVLP_C:
	.byte "<>()"
GOOMBA_C:
	.byte "!",'"
KOOPA1_C:
	.byte "+,"
KOOPA2_C:
	.byte "-."
BOX_C:
	.byte "#"
COIN_BLOCK_C:
	.byte "$"
SOLID_BLOCK_C:
	.byte "&"
QUESTION_BLOCK_C:
	.byte "?"

GameMap1:
	.byte "                      "
	.byte "                      "
	.byte "                      "
	.byte "                      "
	.byte "                      "
	.byte "                      "
	.byte "                      "
	.byte "                      "
	.byte "                      "
	.byte "                      "
	.byte "                      ",0
	.byte "                      "
	.byte "                      "
	.byte "              ?       "
	.byte "                      "
	.byte "                      "
	.byte "    #        ]     [  "
	.byte "&&&&&&  &&&&&&&&&&&&&&"
	.byte "&&&&&&  &&&&&&&&&&&&&&"
	.byte "&&&&&&  &&&&&&&&&&&&&&"
	.byte "&&&&&&  &&&&&&&&&&&&&&"
	.byte "&&&&&&  &&&&&&&&&&&&&&",0
	.byte "&&&&&&  &&&&&&&&&&&&&",0

	
	
	
	
	
	
	
	
	
	