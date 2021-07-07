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
	
;**************************************************************************************************************;

moveLeft:		; store address of characters to move left in x and y
	lda #$80
	and GRAPHSTART2,X
	adc #$80	; set carry bit to bit 7 of X
	txa
	pha			; push X to stack
	tya
	tax			; put Y in X register
	rol GRAPHSTART2,X
	pla
	tax			; put X back from stack
	rol GRAPHSTART2,X
	inx			; move next line of character
	iny
	txa
	and #$07	; if more lines need to be done (x ends with a number 1-7 or 9-F, 0/8 => done)
	bne moveLeft
	
	;**************************************************************************************************************;

moveUp:		; store address of characters to move left in x and y
	lda GRAPHSTART2,X
	pha			; push value at input X to stack
	tya
	pha			; pushed input Y to stack
	txa
	tay
	iny			; Y = X+1
upLoop1:
	lda GRAPHSTART2,Y	; load at X+1
	sta GRAPHSTART2,X	; store at X
	inx			; increment to move to next line down
	iny
	tya
	and #7		; stop looping when last 3 bits of y are 0
	bne up2Loop1
	pla
	tay			; input y is back from stack
	lda GRAPHSTART2,Y
	sta GRAPHSTART2,X
	tya
	tax
	inx			; X = Y+1
upLoop2:
	lda GRAPHSTART2,X	; load at Y+1
	sta GRAPHSTART2,Y ; store at Y
	inx			; increment to move to next line down
	iny
	txa
	and #7		; stop looping when last 3 bits of x are 0
	bne up2Loop2
	pla
	sta GRAPHSTART2,Y
	
;**************************************************************************************************************;

moveDown:		; store address of characters to move left in x and y
	lda #0
	asl			; set carry bit to 0 (automatically uses accumulator)
	txa
	adc #7		; shouldn't set carry bit
	tax			; x = input+7
	tya
	adc #7		;shouldn't set carry bit
	tay			; y = input+7
	lda GRAPHSTART2,Y
	pha			; push value at input Y + 7 to stack
	txa
	pha			; pushed input X + 7 to stack
	tya
	tax
	dex			; X = Y-1 (Y=inputY+7, X=Y-1)
	lda GRAPHSTART2,X	; load at Y-1
	sta GRAPHSTART2,Y	; store at Y
downLoop1:
	dex			; decrement to move to next line up
	dey
	lda GRAPHSTART2,X	; load at Y-1
	sta GRAPHSTART2,Y	; store at Y
	txa
	and #7		; stop looping when last 3 bits of y are 0
	bne down2Loop1
	dex			; decrement to move to next line up
	dey
	lda GRAPHSTART2,X	; load at Y-1
	sta GRAPHSTART2,Y	; store at Y
	pla
	tax			; input X+7 is back from stack
	lda GRAPHSTART2,X
	sta GRAPHSTART2,Y
	txa
	tay
	dey			; Y = X-1
downLoop2:
	lda GRAPHSTART2,Y	; load at X-1
	sta GRAPHSTART2,X ; store at X
	dex			; decrement to move to next line up
	dey
	tya
	and #7		; stop looping when last 3 bits of x are 0
	bne down2Loop2
	lda GRAPHSTART2,Y	; load at X-1
	sta GRAPHSTART2,X ; store at X
	dex
	pla
	sta GRAPHSTART2,X
	