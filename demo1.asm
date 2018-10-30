CHROUT		= $FFD2
CHRIN		= $FFE4
CLEARSCREEN = $E55F

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
	; for x = $0 to $7F get from $8000+x, store at $1C00+x
	ldx $0
loadChar:
	lda $8000,X		; load x from ROM
	sta $1C00,X		; store previous char in RAM
	inx				; increment x
	cpx #$4C		; if x < $80 then do loop again
	bne loadChar
	
	lda #$FF
	sta $9005		; characters are stored at $1C00 - $1DFF and use 8 bytes of memory each

;******************* Start of Graphics *******************
; characters are 8 bytes
; each byte in binary represents a line of the char (1 => pixel on, 0 => pixel off)

;******************* number 0 *******************
	lda #$3C		; replaces '0 (doesn't work for some reason??)
	sta $1D80
	lda #$42
	sta $1D81
	lda #$46
	sta $1D82
	lda #$5A
	sta $1D83
	lda #$62
	sta $1D84
	lda #$42
	sta $1D85
	lda #$3C
	sta $1D86
	lda #$00
	sta $1D87

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
	lda #$00		; replaces ':
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

	lda #'@			; load mario
	jsr CHROUT		; print char in accumulator
	; lda #'[			; load koopa1
	; jsr CHROUT		; print char in accumulator
	; lda #']			; load koopa2
	; jsr CHROUT		; print char in accumulator
	; lda #'"			; load goomba
	; jsr CHROUT		; print char in accumulator
	; lda #'&			; load block
	; jsr CHROUT		; print char in accumulator
	; lda #'#			; load box
	; jsr CHROUT		; print char in accumulator
	; lda #'$			; load coin block
	; jsr CHROUT		; print char in accumulator
	; lda #'?			; load question block
	; jsr CHROUT		; print char in accumulator
	
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
	; ldy $0111
	; lda #1
	; sta 38400,y
	lda $0111
	adc #1
	sta $0111
	jmp drawing
dKeyDown:
	lda $0112
	cmp #255
	beq jumpToDrawing
	; ldy $0112
	; lda #1
	; sta 38400+255,y
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
	; ldy $0112
	; lda #1
	; sta 38400+255,y
	lda $0112
	sbc #1
	sta $0112
	jmp wkeyEnd
wKey2:
	lda $0111
	cmp #0
	beq wkeyEnd
	; ldy $0111
	; lda #1
	; sta 38400,y
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
	; ldy $0112
	; lda #1
	; sta 38400+255,y
	lda $0112
	sbc #1
	sta $0112
	jmp drawing
aKeyUp:
	lda $0111
	cmp #0
	beq drawing
	; ldy $0111
	; lda #1
	; sta 38400,y
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
	; ldy $0111
	; lda #1
	; sta 38400,y
	lda $0111
	adc #1
	sta $0111
	jmp sKeyEnd
sKey2:
	lda $0112
	cmp #255
	beq sKeyEnd
	; ldy $0112
	; lda #1
	; sta 38400+255,y
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

;********************
; This part has bug
; drawExist:
; 	ldx #0
; 	ldy #0
; drawExistLoop:
; 	inx
; 	iny
; 	lda #0113,y
; 	sta $D1 
; 	iny 
; 	lda #0113,y 
; 	sta $D3 
; 	iny
; 	lda #0113,y
; 	cmp #1
; 	bne drawExistNext1
; 	lda #'@
; 	jmp darwingExistOut
; drawExistNext1:
; 	cmp #2
; 	bne drawExistNext2
; 	lda #'[
; 	jmp darwingExistOut
; drawExistNext2:
; 	cmp #3
; 	bne drawExistNext3
; 	lda #']
; 	jmp darwingExistOut
; drawExistNext3:
; 	cmp #4
; 	bne drawExistNext4
; 	lda #'<			; -- change before compile
; 	jmp darwingExistOut
; drawExistNext4:
; 	cmp #5
; 	bne drawExistNext5
; 	lda #'#
; 	jmp darwingExistOut
; drawExistNext5:
; 	cmp #6
; 	bne drawExistNext6
; 	lda #'&
; 	jmp darwingExistOut
; drawExistNext6:
; 	cmp #7
; 	bne drawExistNext7
; 	lda #'$
; 	jmp darwingExistOut
; drawExistNext7:
; 	lda #'?
; 	jmp darwingExistOut
; darwingExistOut:
; 	jsr CHROUT
; 	cpx $0113
; 	bne drawExist
; 	jmp sound


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