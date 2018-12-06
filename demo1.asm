CHROUT		= $FFD2
CHRIN		= $FFE4
CLEARSCREEN = $E55F
GRAPHSTART1	= $1C00
GRAPHSTART2	= $1D00
RDTIM = $FFDE

    processor 6502
	org $1001

	dc.w basicend
	dc.w 1024			;line number for sys instruction (arbitrary?)
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
	sta $1C00,X		; store previous char in RAM
	inx				; increment x (note X is 2 bytes so this value will become 0 after $FF iterations)
	bne loadChar1
loadChar2:
	lda $8100,X
	sta $1D00,X
	inx
	bne loadChar2
	
	lda #$FF
	sta $9005		; characters are stored at $1C00 - $1DFF and use 8 bytes of memory each

;******************* Start of Graphics *******************
; characters are 8 bytes
; each byte in binary represents a line of the char (1 => pixel on, 0 => pixel off)

;******************* Mario Character *******************
	lda #$3C		; start of mario character (top of head)
	sta $1C00		; start of memory location for mario (mario replaces '@ => get mario in accumulator: lda #'@)
	lda #$3C
	sta $1C01
	lda #$18
	sta $1C02
	lda #$FF
	sta $1C03
	lda #$3C
	sta $1C04
	lda #$3C
	sta $1C05
	lda #$24
	sta $1C06
	lda #$C3		; feet
	sta $1C07		; end memory location for mario

;******************* number 1 *******************
	lda #$08		; replaces '1 (doesn't work for some reason??)
	sta $1D88
	lda #$18
	sta $1D89
	lda #$28
	sta $1D8A
	lda #$08
	sta $1D8B
	lda #$08
	sta $1D8C
	lda #$08
	sta $1D8D
	lda #$3E
	sta $1D8E
	lda #$00
	sta $1D8F

;******************* number 2 *******************
	lda #$3C		; replaces '2 (doesn't work for some reason??)
	sta $1D90
	lda #$42
	sta $1D91
	lda #$02
	sta $1D92
	lda #$0C
	sta $1D93
	lda #$30
	sta $1D94
	lda #$40
	sta $1D95
	lda #$7E
	sta $1D96
	lda #$00
	sta $1D97

;******************* number 3 *******************
	lda #$3C		; replaces '3 (doesn't work for some reason??)
	sta $1D98
	lda #$42
	sta $1D99
	lda #$02
	sta $1D9A
	lda #$1C
	sta $1D9B
	lda #$02
	sta $1D9C
	lda #$42
	sta $1D9D
	lda #$3C
	sta $1D9E
	lda #$00
	sta $1D9F

;******************* number 4 *******************
	lda #$04		; replaces '4 (doesn't work for some reason??)
	sta $1DA0
	lda #$0C
	sta $1DA1
	lda #$14
	sta $1DA2
	lda #$24
	sta $1DA3
	lda #$7E
	sta $1DA4
	lda #$04
	sta $1DA5
	lda #$04
	sta $1DA6
	lda #$00
	sta $1DA7

;******************* number 5 *******************
	lda #$7E		; replaces '5 (doesn't work for some reason??)
	sta $1DA8
	lda #$40
	sta $1DA9
	lda #$78
	sta $1DAA
	lda #$04
	sta $1DAB
	lda #$02
	sta $1DAC
	lda #$44
	sta $1DAD
	lda #$38
	sta $1DAE
	lda #$00
	sta $1DAF

;******************* number 6 *******************
	lda #$1C		; replaces '6 (doesn't work for some reason??)
	sta $1DB0
	lda #$20
	sta $1DB1
	lda #$40
	sta $1DB2
	lda #$7C
	sta $1DB3
	lda #$42
	sta $1DB4
	lda #$42
	sta $1DB5
	lda #$3C
	sta $1DB6
	lda #$00
	sta $1DB7

;******************* number 7 *******************
	lda #$7E		; replaces '7 (doesn't work for some reason??)
	sta $1DB8
	lda #$42
	sta $1DB9
	lda #$04
	sta $1DBA
	lda #$08
	sta $1DBB
	lda #$10
	sta $1DBC
	lda #$10
	sta $1DBD
	lda #$10
	sta $1DBE
	lda #$00
	sta $1DBF

;******************* number 8 *******************
	lda #$3C		; replaces '8 (doesn't work for some reason??)
	sta $1DC0
	lda #$42
	sta $1DC1
	lda #$42
	sta $1DC2
	lda #$3C
	sta $1DC3
	lda #$42
	sta $1DC4
	lda #$42
	sta $1DC5
	lda #$3C
	sta $1DC6
	lda #$00
	sta $1DC7

;******************* number 9 *******************
	lda #$3C		; replaces '9 (doesn't work for some reason??)
	sta $1DC8
	lda #$42
	sta $1DC9
	lda #$42
	sta $1DCA
	lda #$3E
	sta $1DCB
	lda #$02
	sta $1DCC
	lda #$04
	sta $1DCD
	lda #$38
	sta $1DCE
	lda #$00
	sta $1DCF

;******************* Mario Character *******************
	lda #$3C		; start of mario character (top of head)
	sta $1C00		; start of memory location for mario (mario replaces '@ => get mario in accumulator: lda #'@)
	lda #$3C
	sta $1C01
	lda #$18
	sta $1C02
	lda #$FF
	sta $1C03
	lda #$3C
	sta $1C04
	lda #$3C
	sta $1C05
	lda #$24
	sta $1C06
	lda #$C3		; feet
	sta $1C07		; end memory location for mario
	
;******************* Koopa 1 Character *******************
	lda #$02		; replaces '[
	sta $1CD8
	lda #$36
	sta $1CD9
	lda #$36
	sta $1CDA
	lda #$1C
	sta $1CDB
	lda #$70
	sta $1CDC
	lda #$10
	sta $1CDD
	lda #$28
	sta $1CDE
	lda #$28
	sta $1CDF
	
;******************* Koopa 2 Character *******************
	lda #$30		; replaces ']
	sta $1CE8
	lda #$37
	sta $1CE9
	lda #$1E
	sta $1CEA
	lda #$70
	sta $1CEB
	lda #$10
	sta $1CEC
	lda #$28
	sta $1CED
	lda #$28
	sta $1CEE
	lda #$00
	sta $1CEF
	
;******************* Goomba *******************
	lda #$00		; replaces '<
	sta $1DE0
	lda #$00
	sta $1DE1
	lda #$18
	sta $1DE2
	lda #$3C
	sta $1DE3
	lda #$7E
	sta $1DE4
	lda #$7E
	sta $1DE5
	lda #$18
	sta $1DE6
	lda #$24
	sta $1DE7
	
;******************* Box *******************
	lda #$FF		; replaces '# can be used as selector
	sta $1D18
	lda #$81
	sta $1D19
	lda #$81
	sta $1D1A
	lda #$81
	sta $1D1B
	lda #$81
	sta $1D1C
	lda #$81
	sta $1D1D
	lda #$81
	sta $1D1E
	lda #$FF
	sta $1D1F
	
;******************* Block *******************
	lda #$FF		; replaces '&
	sta $1D30
	lda #$FF
	sta $1D31
	lda #$FF
	sta $1D32
	lda #$FF
	sta $1D33
	lda #$FF
	sta $1D34
	lda #$FF
	sta $1D35
	lda #$FF
	sta $1D36
	lda #$FF
	sta $1D37
	
;******************* Coin Block *******************
	lda #$FF		; replaces '$
	sta $1D20
	lda #$81
	sta $1D21
	lda #$99
	sta $1D22
	lda #$B5
	sta $1D23
	lda #$AD
	sta $1D24
	lda #$99
	sta $1D25
	lda #$81
	sta $1D26
	lda #$FF
	sta $1D27

;******************* Question Block *******************
	lda #$FF		; replaces '?
	sta $1DF8
	lda #$81
	sta $1DF9
	lda #$9D
	sta $1DFA
	lda #$A5
	sta $1DFB
	lda #$89
	sta $1DFC
	lda #$81
	sta $1DFD
	lda #$91
	sta $1DFE
	lda #$FF
	sta $1DFF

;******************* End of Graphics *******************

	

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
	cmp #' 
	beq menuSelect
	jmp donePrintMenu
menuDown:
	lda $1000
	cmp #14
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
;***********************************************************
;***********************************************************
;***********************************************************
playModeInit:
	ldx #0
	ldy #0
	jsr CLEARSCREEN
cll:				;Printing the white screen among the black background
    lda #32+128
    sta 7680,x      ; screen memory
    sta 7680+256,x
    dex
    bne cll	

RDTIM = $FFDE



;Initialize stack counter ($1011) and stack end pointer ($1012) to 0
	lda #0
	sta $1011
	lda #0
	sta $1012

; Function to draw play mode map
printMap1Init:
	ldy #0
printMap1:
	lda GameMap1,y
	cmp #0			
	beq printMap1RestInit
	jsr CHROUT
	iny
	jmp printMap1
printMap1RestInit:
	ldy #0
printMap1Rest:
	lda GameMap1+177,y
	cmp #0			
	beq printMap1FinalInit
	jsr storeItem
	lda GameMap1+177,y
	jsr CHROUT
	iny
	jmp printMap1Rest
printMap1FinalInit:
	ldy #0
printMap1Final:
	lda GameMap1+398,y
	cmp #0			
	beq printMap1End
	jsr CHROUT
	iny
	jmp printMap1Final
printMap1End:
	ldx #21
	ldy #43
	clc 
	jsr $fff0
	lda #'&
	jsr CHROUT

	jmp PlaymodeStart

PlaymodeStart:
	lda #'@				; Draw Mario at beginning *******Should change to ( in master
	sta $1008
	ldy #0
	sty $1006
	ldx #16
	stx $1007
	jsr drawing
	ldx #3
	stx $1003
	jsr displayLives
	lda #'0
	sta $1004
	jsr drawScore
	lda #'2
	sta $1001
	lda #'0
	sta $1002	;sets timer to arbitrary initial value
	jsr RDTIM
	stx $1bfe
	jsr timerLoadandDisplay

	
playTimerLoop:
	jsr RDTIM
	cpx $1bfe
	beq finishPlayTimerTest	
	jsr decrementTimer
	jsr timerLoadandDisplay
	jsr RDTIM
	stx $1bfe

finishPlayTimerTest:
	jsr playInput
	jmp playTimerLoop
	rts
	
playInput:
	lda #0
	jsr	CHRIN		;accept user input for test number 
	cmp #'W			; Branch to the coressponding key
	beq playjmpWkey
	cmp #'A
	beq playjmpAkey
	cmp #'S
	beq playjmpSkey
	cmp #'D
	beq playjmpDkey
	rts

; ;The codes are too long that we can't directly branching out
playjmpWkey:
	jmp playwKey
playjmpAkey:
	jmp playaKey
playjmpSkey:
	jmp playsKey
playjmpDkey:
	jmp playdKey

checkCollide:
	lda $1900
	sta $1903
	ldx $1901
colliCal:
	lda $1903
	adc #21
	sta $1903
	dex
	cpx #0
	bne colliCal
	ldy $1903
	lda $1013,y
	cmp #' 
	bne collided
	lda #0
	sta $100a
	rts
collided:
	lda #1
	sta $100a
	rts

playdKey:						;press D to move right
	; Check if the current position is at the end of the line, if yes go back to rts
	lda $1006
	cmp #21
	beq playdKeyEnd

	; Check collision
	lda $1006
	adc #1
	sta $1900
	lda $1007
	sbc #7
	sta $1901
	jsr checkCollide

	; Check collision result
	lda $100a
	cmp #0
	bne playdkeyCollide

	; Erase the current position Mario
	jsr clearCharacter
	; Otherwise increment x position by 1 
	ldx $1006
	inx
	stx $1006
	jsr drawing
	rts
playdkeyCollide:
	cmp #'#
	beq pressDNP
	cmp #'$
	beq pressDNP
	cmp #'&
	beq pressDNP
	ldx $1006
	inx
	stx $1006
	jsr drawing
	ldx $1006
	dex
	stx $1006
	jsr drawing
pressDNP:
	rts
playdKeyEnd:
	jsr CLEARSCREEN
	jsr drawing
	rts

playwKey:
	; If y = 0 then you can't move up and thus the move can't be made
	lda $1007 
	cmp #0
	beq playwKeyEnd

	; Check collision
	lda $1006
	sta $1900
	lda $1007
	sbc #9
	sta $1901
	jsr checkCollide
	
	; Check collision result
	lda $100a
	cmp #0
	bne playwKeyEnd

	; Erase the current position Mario
	jsr clearCharacter
	; y = y - 1, store back into 1007
	ldx $1007
	dex
	stx $1007
	; go to drawing
	jsr drawing
playwKeyEnd:
	rts

playaKey:
	; Check if x = 0 then you can't move left anymore, go back to rts
	lda $1006
	cmp #0
	beq playaKeyEnd

	; Check collision
	lda $1006
	sbc #1
	sta $1900
	lda $1007
	sbc #8
	sta $1901
	jsr checkCollide

	; Check collision result
	lda $100a
	cmp #0
	bne playaKeyEnd

	; Otherwise clearCharacter, decrement x by 1 and go to drawing
	jsr clearCharacter
	ldx $1006
	dex
	stx $1006
	jsr drawing
playaKeyEnd:
	rts

; Move down
playsKey:
	; You can't go down if you're at the bottom of the screen
	lda $1007
	cmp #22
	beq playsKeyEnd

	; Check collision
	lda $1006
	sta $1900
	lda $1007
	sbc #6
	sta $1901
	jsr checkCollide

	; Check collision result
	lda $100a
	cmp #0
	bne playsKeyEnd

	; if you're not at the bottom, clear the screen, increment y position and draw
	jsr clearCharacter
	ldx $1007
	inx
	stx $1007
	jsr drawing
playsKeyEnd:
	rts

storeItem:
	ldx $1012
	sta $1013,x
	ldx $1012
	inx
	stx $1012
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
	jmp finishDecrement
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


createMode:				;Printing the white screen among the black background
	jsr CLEARSCREEN
	jsr	music

	; Set up current stack counter, x, y, type of character
	lda #0
	sta $1011
	lda #0
	sta $1006
	lda #0
	sta $1007
	; lda #'@
	; sta $1008

	; Set up and store the current map level into stack as well as $1000
	ldx $1011
	lda #201
	sta $1013,x
	inx 
	stx $1011

	lda #201
	sta $1000
	; increment stack pointer
	; ldy #-1
	; jsr drawingBlock
	lda $1011
	sta $1012
	lda #0
	sta $1011
	jsr drawMap

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
	jmp userInput		; If there is no input


waitLoop1:
	iny 
	cpy #20
	bne waitLoop1
	rts

music:
	lda #0
	sta $900e
	lda #159
	sta $900c
	ldy #0	
	jsr waitLoop1
	lda #179
	sta $900c
	ldy #0
	jsr waitLoop1
	lda #199
	sta $900c
	ldy #0
	jsr waitLoop1
	rts


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
	lda #'@
	sta $1008
	jmp jumpDrawing
Key2:
	lda #'[
	sta $1008
	jmp jumpDrawing
Key3:
	lda #']
	sta $1008
	jmp jumpDrawing
Key4:
	lda #'<
	sta $1008
	jmp jumpDrawing
Key5:
	lda #'#
	sta $1008
	jmp jumpDrawing
Key6:
	lda #'&
	sta $1008
	jmp jumpDrawing
Key7:
	lda #'$
	sta $1008
	jmp jumpDrawing
Key8:
	lda #'?
	sta $1008
jumpDrawing:
	jsr drawing
	jmp userInput

qKey:			;When user hit Q,  end game message, and allow player to choose betwwen 							end game or play created map
	jsr CLEARSCREEN			;clear screen
	LDY #0
	jmp jumpToPlayCreatedMap


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
	jmp userInput

dKeyEnd:
	jsr CLEARSCREEN

	; Mark the beginning of new map level onto the stack, increment $1000 by 1
	ldx $1000
	inx
	stx $1000


	; Check if the previous value in the stack is >= 200 => it's a level value 
	; Meaning you're moving around the maps without storing anything
	; Therefore you want to override the previous value 
	ldx $1011
	dex
	lda $1013,x
	cmp #200
	; Skip the increment to store the value at $1011 - 1
	bcs skipIncrement
	; Otherwise increment the $1011 again
	ldx $1011
	inx 
	stx $1011
skipIncrement:
	; Either x = $1011 or x = $1011 - 1, then increment it again
	ldx $1011
	lda $1000
	sta $1013,x
	inx
	stx $1011 
 	; store $1011 to $1012, reset $1011, go to drawMap
	lda $1011
	sta $1012
	lda #0
	sta $1011
	jsr drawMap

	lda #0
	sta $1006
	lda #0
	sta $1007
	jsr drawing
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
	jmp userInput

aKeyEnd:
	jsr CLEARSCREEN
	; Decrement the current map level
	ldx $1000
	dex 
	stx $1000

 	; store $1000 onto the stack, going back to the old map
	ldx $1011
	dex
	lda $1013,x
	cmp #200
	bcs aSkipIncrement
	ldx $1011
	inx
	stx $1011
aSkipIncrement:
	ldx $1011
	lda $1000
	sta $1013,x
	inx 
	stx $1011

	lda $1011
	sta $1012
	lda #0
	sta $1011
	jsr drawMap

 	lda #0
	sta $1006
	lda #0
	sta $1007
	jsr drawing
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
	jsr CHROUT
	rts 

clearCharacter:
	ldy $1006
	ldx $1007
	clc
	jsr $FFF0
	lda #' 
	jsr CHROUT
	rts

playCreatedMap:
	jsr CLEARSCREEN
	lda #201
	sta $1000

	lda $1011
	sta $1012
	lda #0
	sta $1011

	jsr drawMap
	jsr PlaymodeStart

drawMap:
	; Store the current stack counter to stack end pointer, reload stack counter to 0

	ldy #-1
	jsr drawingBlock

	; If counter >= stack end => doneDrawMap
	lda $1011
	cmp $1012
	bcs doneDrawMap


	ldx $1011
	lda $1013,x
	cmp $1000
	BNE endDrawMap
	
incrementDrawLoop:	
	ldx $1011
	inx 
	stx $1011
innerDrawLoop:
	; If counter >= stack end => doneDrawMap (check again in case the counter end within the inner loop)
	lda $1011
	cmp $1012
	beq doneDrawMap
	bcs doneDrawMap2
	;Otherwise, we start drawing characters within our current map level
	;Load the current x position from the stack
	ldx $1011
	lda $1013,x
	sta $1006
	inx
	stx $1011	
	; Load the current y postion from the stack
	ldx $1011
	lda $1013,x
	sta $1007
	inx
	stx $1011
	; Load the current symbol from the stack
	ldx $1011
	lda $1013,x
	sta $1008
	inx
	stx $1011
	jsr drawing	
	ldx $1011
	lda $1013,x
	cmp $1000
	bcs drawMap
	jmp innerDrawLoop
endDrawMap:
	; Increment the stack counter
	ldx $1011
	inx
	stx $1011
	jsr drawMap
doneDrawMap2:
	lda $1011
	sta $1012
doneDrawMap:
	lda #0
	sta $1006
	lda #0
	sta $1007
	lda #'@
	sta $1008
	jsr drawing
	rts
	; jmp userInput
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
	jsr PlaymodeStart
	
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

menuMessage1:
	.byte "SUPER MARIO MAKER ?                                                                         PLAY MODE                                  CREATE MODE", 0
GameMap1:
	.byte "                      "	;1
	.byte "                      "	;2
	.byte "                      "	;3
	.byte "                      "	;4
	.byte "                      "	;5
	.byte "                      "	;6
	.byte "                      "	;7
	.byte "                      ",0	;8
	.byte "                      "	;9		;1
	.byte "                      "	;10		;2
	.byte "                      "  ;11		;3
	.byte "                      " ;12		;4
	.byte "                      " ;13		;5
	.byte "              ?       " ;14		;6
	.byte "                      " ;15		;7
	.byte "#                     " ;16		;8
	.byte "    #        ]     [  " ;17		;9
	.byte "&&&&&&  &&&&&&&&&&&&&&",0 ;18		;10
	.byte "&&&&&&  &&&&&&&&&&&&&&" ;19
	.byte "&&&&&&  &&&&&&&&&&&&&&" ;20
	.byte "&&&&&&  &&&&&&&&&&&&&&" ;21
	.byte "&&&&&&  &&&&&&&&&&&&&&" ;22
	.byte "&&&&&&  &&&&&&&&&&&&&",0 ;23
