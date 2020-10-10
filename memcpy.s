; copy ptr3 bytes from ptr1 to ptr2

.export memcpy

.include "joytest.inc"

.code

memcpy:
	ldy #0
	ldx ptr3 + 1
	beq partial
loop:
	lda (ptr1),y
	sta (ptr2),y
	iny
	bne loop
	inc ptr1 + 1
	inc ptr2 + 1
	dex
	bne loop

partial:
	ldx ptr3
partial_loop:
	lda (ptr1),y
	sta (ptr2),y
	iny
	dex
	bne partial_loop
	rts

