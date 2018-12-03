CHROUT		= $FFD2
CHRIN		= $FFE4
CLEARSCREEN = $E55F
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
; 	cmp #14
; 	beq toCreateMode
; 	cmp #16
; 	beq toPlayCreated
toPlayMode:
	jmp playModeInit
; toCreateMode:
; 	jmp createMode
; toPlayCreated:
; 	jmp PlayCreated

;***********************************************************
;Enter the play mode
playModeInit:
	ldx #0
	ldy #0
	jsr CLEARSCREEN
	lda #'1
	sta $1001
	lda #'2
	sta $1002	;sets timer to arbitrary initial value
	lda #3
	sta $1003 ;initialize number of lives to 3
	lda #'0
	sta $1004 ;initialize score to 0
	

	
cll:				;Printing the white screen among the black background
    lda #32+128
    sta 7680,x      ; screen memory
    sta 7680+256,x
    dex
    bne cll

;Print the Map 1
;It is like the print message function
;But since the map is bigger than the message, so the y will greater than 255, which is overflow
;In order to deal with it, I divide the map into several part, so that the y will not out of range
;However, there is a magical spot in the screen, which is the bottom right most corner, if we touch it with the normal way
;it would return a new page, which will push the map up and leave bottom blank
;in order to solve this, we will use "printMap1End" function to deal with it, and make it ground forever to make our lives easier
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

;*******Score Display
displayScore:	
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
	
	
;*******Lives display
checkandDisplayLives:
	lda $1003
	cmp #0
	beq dead
	jsr displayLives
	jmp timerLoadandDisplay

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
    clc             ; Clear carray flag
	jsr $fff0       ; Plot - move the cursor there
	lda #'@
	jsr CHROUT
drTwoLife:
	ldx #0
	ldy #1
    clc             ; Clear carray flag
	jsr $fff0       ; Plot - move the cursor there
	lda #'@
	jsr CHROUT
drOneLife:
	ldx #0
	ldy #0
    clc             ; Clear carray flag
	jsr $fff0       ; Plot - move the cursor there
	lda #'@
	jsr CHROUT
drLifeDone:
	rts

dead:				;this is mainly just a placeholder flag, when lives run out it should instead trigger a gameover

;******* End of Lives code
;*******timer display and updating
timerLoadandDisplay:		;Loading timeer value from $1001 and displaying it in top right
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
	jsr checkTimeChange
	jsr decrementTimer
	jmp timerLoadandDisplay

decrementTimer:	;decrements the current value in $1002. If the value is zero it wraps around to 9 and decrements value in $1001. If $1001 is 0 when it attempts to decrement, the timer ends and the game is over
	lda $1002
zeroTest:
	cmp #'0
	bne subTimer
endTest:
	lda $1001
	cmp #'0
	bne continueDecrement
	jsr timerDone
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
	
checkTimeChange:	;delay the timer decrementing until the internal clock has decreased (currently every 5 seconds)
	jsr RDTIM
	stx $1bfe
waitForChange:
	jsr RDTIM
	cpx $1bfe
	beq waitForChange
	rts
	
timerDone:
	jsr printEndGameMessage
	jmp timerDone
	rts
;*******end of timer code	
	
test:
	jmp test


    ; Print out the mario 
    lda #255
    sta $D1
    lda #97
    sta $D3
    lda #'@
    jsr CHROUT
    lda #255
    sta $0005       ;Mario D1 position
    lda #97
    sta $0006       ;Mario D3 position



;***************************************
;end of the game
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

menuMessage1:
	.byte "SUPER MARIO MAKER ?                                                                         PLAY MODE                                  CREATE MODE                                 PLAY CREATED", 0

GameMap1:
	.byte "1                     "
	.byte "2                     "
	.byte "3                     "
	.byte "4                     "
	.byte "5                     "
	.byte "6                     "
	.byte "7                     "
	.byte "8                     "
	.byte "9                     "
	.byte "10                    "
	.byte "11                    ",0
	.byte "12                    "
	.byte "13                    "
	.byte "14            ?       "
	.byte "15                    "
	.byte "16                    "
	.byte "17  #        ]     [  "
	.byte "18&&&&&  &&&&&&&&&&&&&"
	.byte "19&&&&&  &&&&&&&&&&&&&"
	.byte "20&&&&&  &&&&&&&&&&&&&"
	.byte "21&&&&&  &&&&&&&&&&&&&"
	.byte "22&&&&&  &&&&&&&&&&&&&",0
	.byte "23&&&&&  &&&&&&&&&&&&",0

endGameMessage:
	.byte "END GAME", 0