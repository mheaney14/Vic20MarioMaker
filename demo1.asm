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
	
;***************Initialize score to zero
	lda #'0
	sta $1004
	jsr drawScore
;***************Timer initialization	
	lda #'2
	sta $1001
	lda #'0
	sta $1002	;sets timer to arbitrary initial value
	jsr RDTIM
	stx $1bfe
	
	jsr timerLoadandDisplay
	
;**************Initialize Mario (should be replaced to read in the location specific to loaded in map)
	ldx #16
	ldy #1
	stx $1008
	sty $1007
	jsr drawPlayerMario
	
;**********Loop that continuously checks if internal clock has changed and updates timer if it does (could also be good place to put the check for user input)
playTimerLoop:
	jsr RDTIM
	cpx $1bfe
	beq finishPlayTimerTest	
	jsr decrementTimer
	jsr timerLoadandDisplay
	jsr RDTIM
	stx $1bfe
finishPlayTimerTest:
;************user input would go here
	
	ldx #16			;This is just a test to confirm that user input is working while timer is running (just prints the inputted character)
	ldy #2			;This should be replaced with the actual user input when it is implemented
	clc				;
	jsr keyChecks
	
	jmp playTimerLoop
	
	jmp end

keyChecks:
	jsr CHRIN
	cmp #'A
	beq aKeyPlay
	cmp #'D
	beq dKeyPlay
	cmp #'W
	beq wKeyPlay
	rts
aKeyPlay:
	lda $1007
	cmp #0
	beq endKeyChecks
	jsr clearCharacter
	ldx $1007
	dex
	stx $1007
	jsr drawPlayerMario
	rts
	
dKeyPlay:
	
	lda $1007
	cmp #21
	beq endKeyChecks
	jsr clearCharacter
	ldx $1007
	inx
	stx $1007
	jsr drawPlayerMario
	rts
	
wKeyPlay:
	jsr clearCharacter
	ldy $1008
	dey
	sty $1008
	jsr drawPlayerMario
waitForFall:
	jsr RDTIM
	cpx $1bfe
	beq waitForFall
	jsr clearCharacter
	ldy $1008
	iny
	sty $1008
	jsr drawPlayerMario
	rts
	
endKeyChecks:
	rts

drawPlayerMario:
	ldx $1008
	ldy $1007
	clc
	jsr $FFF0
	lda #'@
	jsr CHROUT
	rts
	
drawScore:	;Draw current score (single digit) at top-center of screen
	ldx #0
	ldy #11
	clc
	jsr $fff0
	lda #'0
	jsr CHROUT
	
	ldx #0
	ldy #12
	clc
	jsr $fff0
	lda $1004
	jsr CHROUT
	rts
	
gainPoint:		;Call on collision with coin, coin-block, or any other object that increases score
	ldx $1004
	inx
	stx $1004
	jsr drawScore
	rts
	
	
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
	lda #'1
	sta $1001
	lda #'9
	sta $1002	;sets timer to arbitrary initial value
	jsr RDTIM
	stx $1bfe
	
	jsr timerLoadandDisplay
	lda #0
	sta $1011

	ldy #-1
	jsr drawingBlock

	; 1006 = x position, 1007 is y position, 1008 is the current symbol
	lda #1
	sta $1008
	ldy #0
	sty $1006
	ldx #0
	stx $1007
	ldy $1006
	ldx $1007
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
	jsr RDTIM					; Continuously checks if the internal clock has changed and updates timer if it has
	cpx $1bfe					;
	beq finishTimerTest			;
	jsr decrementTimer			;
	jsr timerLoadandDisplay		;
	jsr RDTIM					;
	stx $1bfe					;

finishTimerTest:
	
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
	jmp userInput		; If there is no input


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

; ;The codes are too long that we can't directly branching out
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
	lda $1006
	sta $1013,x
	ldx $1011
	inx 
	stx $1011

	; Save the y position to stack, increment stack counter by 1
	ldx $1011
	lda $1007 
	sta $1013,x 
	ldx $1011 
	inx 
	stx $1011

	; Save the type of character in the stack, increment by 1
	ldx $1011
	lda $1008
	sta $1013,x
	ldx $1011
	inx
	stx $1011

nkeyInput:
	; Reset the $1006 $1007 memory
	lda #0
	sta $1006
	lda #0
	sta $1007

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
	sta $1008
	jmp jumpDrawing
Key2:
	lda #2
	sta $1008
	jmp jumpDrawing
Key3:
	lda #3
	sta $1008
	jmp jumpDrawing
Key4:
	lda #4
	sta $1008
	jmp jumpDrawing
Key5:
	lda #5
	sta $1008
	jmp jumpDrawing
Key6:
	lda #6
	sta $1008
	jmp jumpDrawing
Key7:
	lda #7
	sta $1008
	jmp jumpDrawing
Key8:
	lda #8
	sta $1008
jumpDrawing:
	jsr drawing
	jmp userInput

qKey:			;When user hit Q,  end game message, and allow player to choose betwwen 							end game or play created map
	jsr CLEARSCREEN			;clear screen
	LDY #0
	jmp printEndGameMessage

; After finished writing the message, init choosing option
doneEndMessageInit:
	lda #4
	sta $1007
doneEndMessage:
	ldy #5
	ldx $1007
	clc 
	jsr $FFF0
	lda #'@
	jsr CHROUT

;Getting user input, W S to move up down, space to enter 
qInput:
	lda #0
	jsr CHRIN
	cmp #'W
	beq endUp
	cmp #'S
	beq endDown
	cmp #' 
	beq endSelect
	jmp doneEndMessage
	
endUp:
	lda $1007
	cmp #4
	beq endUpEnd
	ldx $1007
	ldy #5
	clc
	jsr $fff0
	lda #' 
	jsr CHROUT
	ldx $1007
	dex 
	dex
	stx $1007
	jmp qInput
endUpEnd:
	ldx $1007
	ldy #5
	clc
	jsr $fff0
	lda #' 
	jsr CHROUT
	lda #6
	sta $1007
	jmp qInput

endDown:
	lda $1007
	cmp #6
	beq endDownEnd
	ldx $1007
	ldy #5
	clc
	jsr $fff0
	lda #' 
	jsr CHROUT
	lda $1007
	adc #2
	sta $1007
	jmp qInput
endDownEnd:
	ldx $1007
	ldy #5
	clc
	jsr $fff0
	lda #' 
	jsr CHROUT
	lda #4
	sta $1007
	jmp qInput
endSelect:	
	lda $1007
	cmp #4
	beq jumpToPlayCreatedMap
	cmp #6
	jmp start

jumpToPlayCreatedMap:
	jmp playCreatedMap


dKey:						;press D to move right
	; Check if the current position is at the end of the line, if yes go back to userInput
	lda $1006
	cmp #21
	beq dKeyEnd
	; Erase the current position Mario
	jsr clearCharacter
	; Otherwise increment x position by 1 
	ldx $1006
	inx
	stx $1006
	jsr drawing
dKeyEnd:
	jmp userInput


wKey:
	; If y = 0 then you can't move up and thus the move can't be made
	lda $1007 
	cmp #0
	beq wKeyEnd
	; Erase the current position Mario
	jsr clearCharacter
	; y = y - 1, store back into 1007
	ldx $1007
	dex
	stx $1007
	; go to drawing
	jsr drawing
wKeyEnd:
	jmp userInput

aKey:
	; Check if x = 0 then you can't move left anymore, go back to userInput
	lda $1006
	cmp #0
	beq aKeyEnd
	; Otherwise clearCharacter, decrement x by 1 and go to drawing
	jsr clearCharacter
	ldx $1006
	dex
	stx $1006
	jsr drawing
aKeyEnd:
	jmp userInput

; Move down
sKey:
	; You can't go down if you're at the bottom of the screen
	lda $1007
	cmp #22
	beq sKeyEnd
	; if you're not at the bottom, clear the screen, increment y position and draw
	jsr clearCharacter
	ldx $1007
	inx
	stx $1007
	jsr drawing
sKeyEnd:
	jmp userInput


drawing:
	ldy $1006
	ldx $1007
	clc 
	jsr $FFF0

	; Check $1008 for the current symbol needed to be drawn
	lda $1008
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
	rts 

clearCharacter:
	ldy $1007
	ldx $1008
	clc
	jsr $FFF0
	lda #' 
	jsr CHROUT
	rts

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
	jmp	doneEndMessageInit

playCreatedMap:
	jsr CLEARSCREEN
	lda $1011
	sta $1012
	lda #0
	sta $1011

drawCreatedMap:
	lda $1011
	cmp $1012
	beq doneDrawMap

	ldx $1011
	lda $1013,x
	inx
	stx $1011
	sta $1006
	
	ldx $1011
	lda $1013,x
	inx
	stx $1011
	sta $1007

	ldx $1011
	lda $1013,x
	sta $1008
	
	ldx $1007
	ldy $1006
	lda $1008
	cmp #1
	beq draw1
	cmp #2
	beq draw2
	clc
	jsr $FFF0
	lda #'%
	jsr CHROUT
	jmp last

draw1:
	clc
	jsr $FFF0
	lda #'@
	jsr CHROUT
	jmp	last
draw2
	clc
	jsr $FFF0
	lda #'#
	jsr CHROUT
	jmp last
last:
	ldy $1011
	iny 
	sty $1011
	jmp drawCreatedMap


doneDrawMap:
	jmp end



end:
	jmp end
	
	
	
timerLoadandDisplay:		;Loading timer value from $1001 and $1002 and displaying it in top right
	ldx #0          ; Row
    ldy #20          ; Column
    clc             ; Clear carray flag
	jsr $fff0       ; Plot - move the cursor there
	lda $1001
	jsr CHROUT
	ldx #0          ; Row
    ldy #21          ; Column
	jsr $fff0       ; Plot - move the cursor there
	lda $1002
	jsr CHROUT
	rts

decrementTimer:	;decrements the current value in $1002. If the value is zero it wraps around to 9 and decrements value in $1001. If $1001 is 0 when it attempts to decrement, the timer does not decrement
	lda $1002
zeroTest:
	cmp #'0
	bne subTimer
endTest:
	lda $1001
	cmp #'0
	bne continueDecrement
	jsr CLEARSCREEN
continueDecrement:
	tax
	dex
	txa
	sta $1001
	lda #'9
	sta	$1002
	jmp finishDecrement
subTimer:
	tax
	dex
	txa
	sta $1002
finishDecrement:
	rts
	
		
endGameMessage:
	.byte "WHAT WOULD YOU LIKE TO        DO?                                                             PLAY THE MAP                                END GAME", 0
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

	
	
	
	
	
	
	
	
	
	