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
	cpx #$40		; if x < $80 then do loop again
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

;******************* letter H *******************
	lda #$42		; replaces 'H (doesn't work for some reason??)
	sta $1C40
	lda #$42
	sta $1C41
	lda #$42
	sta $1C42
	lda #$7E
	sta $1C43
	lda #$42
	sta $1C44
	lda #$42
	sta $1C45
	lda #$42
	sta $1C46
	lda #$00
	sta $1C47

;******************* letter I *******************
	lda #$1C		; replaces 'I (doesn't work for some reason??)
	sta $1C48
	lda #$08
	sta $1C49
	lda #$08
	sta $1C4A
	lda #$08
	sta $1C4B
	lda #$08
	sta $1C4C
	lda #$08
	sta $1C4D
	lda #$1C
	sta $1C4E
	lda #$00
	sta $1C4F

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
	sta $1DD0
	lda #$00
	sta $1DD1
	lda #$18
	sta $1DD2
	lda #$3C
	sta $1DD3
	lda #$7E
	sta $1DD4
	lda #$7E
	sta $1DD5
	lda #$18
	sta $1DD6
	lda #$24
	sta $1DD7
	
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

	jsr $e55f		; clear screen
	lda #'@			; load mario
	jsr $FFD2		; print char in accumulator
	lda #'[			; load koopa1
	jsr $FFD2		; print char in accumulator
	lda #']			; load koopa2
	jsr $FFD2		; print char in accumulator
	lda #':			; load goomba
	jsr $FFD2		; print char in accumulator
	lda #'&			; load block
	jsr $FFD2		; print char in accumulator
	lda #'#			; load box
	jsr $FFD2		; print char in accumulator
	lda #'$			; load coin block
	jsr $FFD2		; print char in accumulator
	lda #'?			; load question block
	jsr $FFD2		; print char in accumulator

	lda #' 
	jsr $FFD2
	lda #'A
	jsr $FFD2
	lda #'B
	jsr $FFD2
	lda #'C
	jsr $FFD2
	lda #'D
	jsr $FFD2
	lda #'E
	jsr $FFD2
	lda #'F
	jsr $FFD2
	lda #'G
	jsr $FFD2
	lda #'H
	jsr $FFD2
	lda #'I
	jsr $FFD2
	lda #'J
	jsr $FFD2
	lda #'K
	jsr $FFD2
	lda #'L
	jsr $FFD2
	lda #'M
	jsr $FFD2
	lda #'N
	jsr $FFD2
	lda #'O
	jsr $FFD2
	lda #'P
	jsr $FFD2
	lda #'Q
	jsr $FFD2
	lda #'R
	jsr $FFD2
	lda #'S
	jsr $FFD2
	lda #'T
	jsr $FFD2
	lda #'U
	jsr $FFD2
	lda #'V
	jsr $FFD2
	lda #'W
	jsr $FFD2
	lda #'X
	jsr $FFD2
	lda #'Y
	jsr $FFD2
	lda #'Z
	jsr $FFD2
	lda #' 
	jsr $FFD2
	lda #'0
	jsr $FFD2
	lda #'1
	jsr $FFD2
	lda #'2
	jsr $FFD2
	lda #'3
	jsr $FFD2
	lda #'4
	jsr $FFD2
	lda #'5
	jsr $FFD2
	lda #'6
	jsr $FFD2
	lda #'7
	jsr $FFD2
	lda #'8
	jsr $FFD2
	lda #'9
	jsr $FFD2

endLoop:
	jmp endLoop
	
	lda #'a
	jsr $FFD2
	lda #'b
	jsr $FFD2
	lda #'c
	jsr $FFD2
	lda #'d
	jsr $FFD2
	lda #'e
	jsr $FFD2
	lda #'f
	jsr $FFD2
	lda #'g
	jsr $FFD2
	lda #'h
	jsr $FFD2
	lda #'i
	jsr $FFD2
	lda #'j
	jsr $FFD2
	lda #'k
	jsr $FFD2
	lda #'l
	jsr $FFD2
	lda #'m
	jsr $FFD2
	lda #'n
	jsr $FFD2
	lda #'o
	jsr $FFD2
	lda #'p
	jsr $FFD2
	lda #'q
	jsr $FFD2
	lda #'r
	jsr $FFD2
	lda #'s
	jsr $FFD2
	lda #'t
	jsr $FFD2
	lda #'u
	jsr $FFD2
	lda #'v
	jsr $FFD2
	lda #'w
	jsr $FFD2
	lda #'x
	jsr $FFD2
	lda #'y
	jsr $FFD2
	lda #'z
	jsr $FFD2