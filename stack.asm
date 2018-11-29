    processor 6502
	org $1001

	dc.w basicend
	dc.w 1024			;line number for sys instruction (arbitrary?)
	dc.b $9e, "4109"	;sys instruction and memory location
	dc.b 0				; end of instruction
basicend	
		dc.w 0	;end of basic program

;Game part
;$0000 - time
;$0001 - lives
;$0002 - score
;$0003 - music time
;$0004 - character status


;Map part
;$0011 - Stack counter
;$0012 - Stack end

    jsr $e55f

    ; Prepare
    lda #0
    sta $0011       ; Initialize the stack counter to 0
    lda #0
    sta $0012       ; Initialize the stack end pointer to 0
    ldy #5

store:
    ldx $0012       ; load stack end pointer
    lda #1          ; The value that you need to store
    sta $0013,x     ; store to the stack end
    ldx $0012       ; load stack end pointer
    inx             ; increment by one to point to the next address
    stx $0012       ; Sotre the pointer back

    dey             ; just for test purpose, to store 5 times
    cpy #0
    bne store

load:
    ldx $0011       ; Load the stack counter out
    cpx $0012       ; Compare with the stack end pointer to see whether it hit the end
    beq end         ; if hit the end, the all the data in the stack is read
    lda $0013,x     ; Load the corresponding data out from the stack
    ldx $0011       ; Increase the counter for next data 
    inx
    stx $0011


    ;==========================================
    ; for test purpose
    cmp #1
    bne drawB
    lda #'A
    jmp out
    
drawB:
    lda #'B
     
out:
    jsr $ffd2
    jmp load

end:
    jmp end