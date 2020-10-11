; copy rect from ptr1 to ptr2, x is width, y is height

.export copyrect

.include "joytest.inc"

.code

copyrect:
	stx ptr3
	tya
	tax

line_loop:
	ldy #0
char_loop:
	lda (ptr1),y
	sta (ptr2),y
	iny
	cpy ptr3
	bne char_loop

	; increment ptr1 by width, ptr2 by 40
	clc
	lda ptr1
	adc ptr3
	sta ptr1
	lda ptr1 + 1
	adc #0
	sta ptr1 + 1
	lda ptr2
	adc #40
	sta ptr2
	lda ptr2 + 1
	adc #0
	sta ptr2 + 1

	dex
	bne line_loop

	rts
