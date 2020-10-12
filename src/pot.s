; display number A at ptr2, only two digits if X is 0

.autoimport +

.export pot_number

.include "joytest.inc"

.bss
	
.rodata

digits_ten:
	.repeat 10, i
	.byte ' '
	.endrep
	.repeat 246, i
	.byte ((i + 10) / 10) .MOD 10 + $30
	.endrep

digits_one:
	.repeat 256, i
	.byte i .MOD 10 + $30
	.endrep
	
.code

pot_number:
	ldy #0
	cpx #0
	beq digit2
	tax
	cmp #200
	bcc :+
	lda #$32
	bne print_digit3
:	cmp #100
	bcc :+
	lda #$31
	bne print_digit3
:	lda #$20
print_digit3:
	sta (ptr2),y
	iny
	txa
digit2:
	tax
	lda digits_ten,X
	sta (ptr2),y
	iny
	lda digits_one,x
	sta (ptr2),y
	rts
