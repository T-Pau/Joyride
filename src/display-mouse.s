.autoimport +

.export display_mouse

.include "joytest.inc"

buttons_position = screen + 40 * 2 + 11

.code

display_mouse:
	lda port_digital
	lsr
	tay
	lda button_rects,y
	sta ptr1
	lda button_rects + 1,y
	sta ptr1 + 1
	clc
	lda #<buttons_position
	cpx #2
	bne :+
	adc #20
:	sta ptr2
	lda #>buttons_position
	adc #0
	sta ptr2 + 1
	ldx #7
	ldy #3
	jsr copyrect

.rodata

button_rects:
	.word buttons_none
	.word buttons_r
	.word buttons_m
	.word buttons_mr

	.word buttons_none
	.word buttons_r
	.word buttons_m
	.word buttons_mr

	.word buttons_none
	.word buttons_r
	.word buttons_m
	.word buttons_mr

	.word buttons_none
	.word buttons_r
	.word buttons_m
	.word buttons_mr

	.word buttons_l
	.word buttons_lr
	.word buttons_lm
	.word buttons_lmr

	.word buttons_l
	.word buttons_lr
	.word buttons_lm
	.word buttons_lmr

	.word buttons_l
	.word buttons_lr
	.word buttons_lm
	.word buttons_lmr

	.word buttons_l
	.word buttons_lr
	.word buttons_lm
	.word buttons_lmr

buttons_none:
	.byte $41, $48, $74, $48, $79, $48, $42
	.byte $45, $0c, $56, $0d, $57, $12, $46
 	.byte $43, $47, $75, $47, $7a, $47, $44

buttons_l:
buttons_m:
buttons_r:
buttons_lm:
buttons_lr:
buttons_mr:
buttons_lmr:
	.byte $41, $48, $74, $48, $79, $48, $42
	.byte $45, $0c, $56, $0d, $57, $12, $46
 	.byte $43, $47, $75, $47, $7a, $47, $44
