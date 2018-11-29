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
    sta $0011
    lda #0
    sta $0012

store:
    ldx $0012
    lda #1          ; The value that you need to store
    sta $0013,x
    lda $0012       ; Increment the stack end pointer
    adc #1
    sta $0012

load:
    ldx $0011
    inx
    cpx $0012
    beq end
    lda $0012,x
    ldx $0011
    inx
    stx $0011


    ;==========================================
    ; compare and give the test result
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