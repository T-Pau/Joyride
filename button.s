; set state of button at ptr2 to A

.export button

.autoimport +

.include "joytest.inc"

.code

button:
	tax
	ldy #0
loop:
	lda (ptr2),y
	and #$7f
	cpx #0
	beq clear
	ora #$80
clear:
	sta (ptr2),y
	iny
	cpy #3
	bne l2
	ldy #40
	bne loop
l2:
	cpy #43
	bne l3
	ldy #80
	bne loop
l3:
	cpy #83
	bne loop

	rts
