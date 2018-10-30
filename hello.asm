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
	sta 52
	lda #28
	sta 56			; the above 4 lines cause memory not to be used for code (used for storing 64 new characters)
	
	; this stores the regular set of characters, we can then swap new ones in their places
	; for x = $0 to $199 get from $8000+x, store at $1C00+x
	ldx $0
loadChar:
	lda $8000,X		; load x from ROM
	sta $1C00,X		; store previous char in RAM
	inx				; increment x
	cpx $200		; if x < $200 then do loop again
	bne loadChar
	
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
	lda #$00		; replaces '"
	sta $1D10
	lda #$00
	sta $1D11
	lda #$18
	sta $1D12
	lda #$3C
	sta $1D13
	lda #$7E
	sta $1D14
	lda #$7E
	sta $1D15
	lda #$18
	sta $1D16
	lda #$24
	sta $1D17
	
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
    lda #0        ; screen and border colors
    sta $900F
	lda #1			;Set the background of the character to white
	sta $286		;Store it in $286 memory

	ldx #0
	ldy #0
cll:
    lda #32+128
    sta 7680,x      ; screen memory
    sta 7680+256,x
    dex
    bne cll

	; lda #'@			; load mario
	; jsr CHROUT		; print char in accumulator
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

nKey:
	ldy $0101
	cpy #6
	bne qKey
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
	lda $0110
	sta $0113,y
	iny 
	lda $0111
	sta $0113,y
	iny
	lda $0112
	sta $0113,y
	lda #0
	sta $0110
	lda #0
	sta $0111
	lda #0
	sta $0112

qKey:						;When user hit Q, quit the game and print end game message
	ldy $0101
	cpy #5
	bne dKey
	jsr CLEARSCREEN
	LDY $0
	jmp printEndGameMessage
	jmp end

dKey:
	ldy $0101
	cpy #4
	bne wKey
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
	lda #'1
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
	jmp darwing
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
	jmp darwing

wKey:
	ldy $0101
	cpy #1
	bne aKey
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
	lda #'1
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
	jmp darwing
	rts

aKey:
	ldy $0101
	cpy #2
	bne sKey
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
	lda #'1
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
	jmp darwing
aKeyUp:
	lda $0111
	cmp #0
	beq darwing
	; ldy $0111
	; lda #1
	; sta 38400,y
	lda $0111
	sbc #1
	sta $0111
	jmp darwing

; offset is 242 to make it correctly
sKey:
	ldy $0101
	cpy #3
	bne sound
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
	lda #'1
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
	beq darwing
	inx
	jmp sKey1

sound:
	lda #168
	sta $900c		; -- effect sound if input
	lda #0
	sta $900c
	jmp	main

darwing:
	lda $0112
	cmp #0
	bne darwingCurrentBlockDown
	; ldx $0111		; position
	; lda $0110		; item type
	; sta 38400,x
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
	lda #'@
	jsr CHROUT
	jmp sound
darwingCurrentBlockDown:
	; ldx $0112
	; lda $0110
	; sta 38400+255,x
	ldx $0111
	stx $D1
	ldx $0112
	stx $D3
	lda #'@
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
	rts


end:
	jmp end
	rts


endGameMessage:
	.byte "END GAME", 0