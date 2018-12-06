CHROUT		= $FFD2
CHRIN		= $FFE4
CLEARSCREEN = $E55F

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
	

; Function to draw play mode map


	jmp PlaymodeStart

PlaymodeStart:
	jsr printMap1Init
	lda #1
	sta $1800
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
	lda $1003
	cmp #0
	beq jmpGameOVer

	lda $1007
	cmp #17
	beq jmpGameOVer

	jsr playInput
	jmp playTimerLoop
	rts

; fallingPitch:
; 	jsr CLEARSCREEN
; 	ldx #0
; 	ldy #0
; 	clc 
; 	jsr $fff0
; 	jsr printMap1Init
; 	lda #'@				; Draw Mario at beginning *******Should change to ( in master
; 	sta $1008
; 	ldy #0
; 	sty $1006
; 	ldx #16
; 	stx $1007
; 	jsr drawing
; 	lda $1003
; 	sbc #1
; 	sta $1003
; 	jsr displayLives
; 	jmp finishPlayTimerTest

jmpGameOVer:
	jsr CLEARSCREEN
	ldx #0
	ldy #0
	clc 
	jsr $fff0
	jmp gameOverMessage

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
	ldy $1903
	lda $1013,y
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
	lda $100a
	cmp #'#
	beq pressDNP
	cmp #'$
	beq pressDNP
	cmp #'&
	beq pressDNP
	ldx #0
	ldy #0
	clc 
	jsr $FFF0
	lda #' 
	jsr CHROUT
	lda #' 
	jsr CHROUT
	lda #' 
	jsr CHROUT
	ldx $1003
	dex
	stx $1003
	jsr displayLives
pressDNP:
	rts
playdKeyEnd:
	jsr CLEARSCREEN
	lda $1800
	cmp #2
	beq playdkeyFinish
	adc #1
	sta $1800
	lda $1800
	cmp #2
	beq drawL2
	cmp #3
	beq drawL3
drawL2:
	jsr printMap2Init
	jmp renewChar
drawL3:
	jsr printMap3Init

renewChar:
	jsr displayLives
	jsr drawScore
	jsr timerLoadandDisplay
	lda #'@				; Draw Mario at beginning *******Should change to ( in master
	sta $1008
	ldy #0
	sty $1006
	ldx #16
	stx $1007
	jsr drawing
playdkeyFinish:
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
	bne playwKeyColli

	; Erase the current position Mario
	jsr clearCharacter
	; y = y - 1, store back into 1007
	ldx $1007
	dex
	stx $1007
	; go to drawing
	jsr drawing
	rts
playwKeyColli:
	lda $100a
	cmp #'$
	bne playwKeyEnd
	lda $1004
	adc #1
	sta $1004
	jsr drawScore
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
	bne playaKeyColli

	; Otherwise clearCharacter, decrement x by 1 and go to drawing
	jsr clearCharacter
	ldx $1006
	dex
	stx $1006
	jsr drawing
	rts
playaKeyColli:
	lda $100a
	cmp #'#
	beq pressANP
	cmp #'$
	beq pressANP
	cmp #'&
	beq pressANP
	ldx #0
	ldy #0
	clc 
	jsr $FFF0
	lda #' 
	jsr CHROUT
	lda #' 
	jsr CHROUT
	lda #' 
	jsr CHROUT
	ldx $1003
	dex
	stx $1003
	jsr displayLives
pressANP:
	rts
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
	bne pleysKeyColli

	; if you're not at the bottom, clear the screen, increment y position and draw
	jsr clearCharacter
	ldx $1007
	inx
	stx $1007
	jsr drawing
	rts
pleysKeyColli:
	lda $100a
	cmp #'[									;****************************** check goomba
	bne playsKeyEnd
	lda $1004
	adc #1
	sta $1004
	jsr drawScore
playsKeyEnd:
	rts

storeItem:
	ldx $1012
	sta $1013,x
	ldx $1012
	inx
	stx $1012
	rts

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
	ldx #0
	ldy #0
	clc
	jsr $fff0
	jmp gameOverMessage
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
	lda $1003
	cmp #1
	beq drOneLife
	cmp #2
	beq drTwoLife
	cmp #3
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
	ldx #0
	ldy #1
	clc 
	jsr $FFF0
	lda #'@
	jsr CHROUT
drOneLife:
	ldx #0
	ldy #0
	clc
	jsr $FFF0
	lda #'@
	jsr CHROUT
drLifeDone:
	rts

gameOverMessage:				;Print end game message
	LDA GameOver,Y
	CMP #0
	BEQ playModeGameEnd
	JSR	CHROUT
	INY 
	jmp gameOverMessage

playModeGameEnd:
	jmp playModeGameEnd

printMap1Init:
	lda #0
	sta $1011
	lda #0
	sta $1012
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
	rts

; Draw Game Map 2
printMap2Init:
	ldx #0
	ldy #0
	clc 
	jsr $fff0
	lda #0
	sta $1011
	lda #0
	sta $1012
	ldy #0
printMap2:
	lda GameMap2,y
	cmp #0			
	beq printMap1RestInit
	jsr CHROUT
	iny
	jmp printMap2
printMap2RestInit:
	ldy #0
printMap2Rest:
	lda GameMap2+177,y
	cmp #0			
	beq printMap2FinalInit
	jsr storeItem
	lda GameMap2+177,y
	jsr CHROUT
	iny
	jmp printMap2Rest
printMap2FinalInit:
	ldy #0
printMap2Final:
	lda GameMap2+398,y
	cmp #0			
	beq printMap2End
	jsr CHROUT
	iny
	jmp printMap2Final
printMap2End:
	ldx #21
	ldy #43
	clc 
	jsr $fff0
	lda #'&
	jsr CHROUT
	rts

; Draw Game map 3
printMap3Init:
	lda #0
	sta $1011
	lda #0
	sta $1012
	ldy #0
printMap3:
	lda GameMap3,y
	cmp #0			
	beq printMap3RestInit
	jsr CHROUT
	iny
	jmp printMap3
printMap3RestInit:
	ldy #0
printMap3Rest:
	lda GameMap3+177,y
	cmp #0			
	beq printMap3FinalInit
	jsr storeItem
	lda GameMap3+177,y
	jsr CHROUT
	iny
	jmp printMap3Rest
printMap3FinalInit:
	ldy #0
printMap3Final:
	lda GameMap3+398,y
	cmp #0			
	beq printMap3End
	jsr CHROUT
	iny
	jmp printMap3Final
printMap3End:
	ldx #21
	ldy #43
	clc 
	jsr $fff0
	lda #'&
	jsr CHROUT
	rts
























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

end:
	jmp end


menuMessage1:
	.byte "SUPER MARIO MAKER ?                                                                         PLAY MODE                                  CREATE MODE                                 PLAY CREATED", 0

GameOver:
	.byte "                                                                                                                                           GAME OVER    ",0

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
	.byte "                      " ;14		;6
	.byte "               $      " ;15		;7
	.byte "                      " ;16		;8
	.byte "    #        ]     [  " ;17		;9
	.byte "&&&&&&  &&&&&&&&&&&&&&",0 ;18		;10
	.byte "&&&&&&  &&&&&&&&&&&&&&" ;19
	.byte "&&&&&&  &&&&&&&&&&&&&&" ;20
	.byte "&&&&&&  &&&&&&&&&&&&&&" ;21
	.byte "&&&&&&  &&&&&&&&&&&&&&" ;22
	.byte "&&&&&&  &&&&&&&&&&&&&",0 ;23

GameMap2:
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
	.byte "                      " ;14		;6
	.byte "                      " ;15		;7
	.byte "                     ?" ;16		;8
	.byte "    !      !       !  " ;17		;9
	.byte "&&&&&&  &&&&&&&  &&&&&",0 ;18		;10
	.byte "&&&&&&  &&&&&&&  &&&&&" ;19
	.byte "&&&&&&  &&&&&&&  &&&&&" ;20
	.byte "&&&&&&  &&&&&&&  &&&&&" ;21
	.byte "&&&&&&  &&&&&&&  &&&&&" ;22
	.byte "&&&&&&  &&&&&&&  &&&&",0 ;23


GameMap3:
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
	.byte "                      " ;14		;6
	.byte "                      " ;15		;7
	.byte "        $             " ;16		;8
	.byte "    !        !     !  " ;17		;9
	.byte "&&&&&&&&&&&&&&&  &&&&&",0 ;18		;10
	.byte "&&&&&&&&&&&&&&&  &&&&&" ;19
	.byte "&&&&&&&&&&&&&&&  &&&&&" ;20
	.byte "&&&&&&&&&&&&&&&  &&&&&" ;21
	.byte "&&&&&&&&&&&&&&&  &&&&&" ;22
	.byte "&&&&&&&&&&&&&&&  &&&&",0 ;23

; GameMap3:
; 	.byte "                      "	;1
; 	.byte "                      "	;2
; 	.byte "                      "	;3
; 	.byte "                      "	;4
; 	.byte "                      "	;5
; 	.byte "                      "	;6
; 	.byte "                      "	;7
; 	.byte "                      ",0	;8
; 	.byte "                      "	;9		;1
; 	.byte "                     #"	;10		;2
; 	.byte "                    ##"  ;11		;3
; 	.byte "                   ###" ;12		;4
; 	.byte "                  ####" ;13		;5
; 	.byte "                 #####" ;14		;6
; 	.byte "                ######" ;15		;7
; 	.byte "               #######" ;16		;8
; 	.byte "              ########" ;17		;9
; 	.byte "&&&&&&&  &&&&&&&&&&&&&",0 ;18		;10
; 	.byte "&&&&&&&  &&&&&&&&&&&&&" ;19
; 	.byte "&&&&&&&  &&&&&&&&&&&&&" ;20
; 	.byte "&&&&&&&  &&&&&&&&&&&&&" ;21
; 	.byte "&&&&&&&  &&&&&&&&&&&&&" ;22
; 	.byte "&&&&&&&  &&&&&&&&&&&&",0 ;23