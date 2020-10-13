.autoimport +

.export display_port

.include "joytest.inc"

display_position = screen + 40 * 2 + 1

.rodata

display_routines:
	.word display_joystick
	.word display_mouse
	.word display_paddle1
	.word display_paddle2
	.word display_koalapad
	.word display_raw

.code

display_port:
	stx port_number
	clc
	lda #<display_position
	cpx #1
	bne :+
	adc #19
:	sta ptr2
	lda #>display_position
	sta ptr2 + 1
	
	lda port1_type, x
	asl
	tay
	lda display_routines,y
	sta jump + 1
	lda display_routines + 1,y
	sta jump + 2
jump:
	jmp $0000
