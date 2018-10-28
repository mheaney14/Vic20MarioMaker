BCPL
tokenized
	processor 6502
	org $1100
	
	dc.w	end
	dc.w	#1234
	dc.b $9e, " ", 0
	
end:
	dc.w 0
	
start:
	rts