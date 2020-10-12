; display joystick number X
.autoimport +

.export display_joystick

.include "joytest.inc"

.bss

tmp:
	.res 2

.rodata

joy_positions:
	.word screen + 4 * 40 + 2
	.word screen + 4 * 40 + 22
	.word screen + 15 * 40 + 8
	.word screen + 15 * 40 + 22

display_joystick:
	dex
	txa
	asl
	sta tmp
	tax
	lda joy_positions,x
	sta ptr2
	lda joy_positions + 1,x
	sta ptr2 + 1
	lda port_digital
	and #$f
	jsr dpad

	; button 1
	clc
	ldx tmp
	lda joy_positions,x
	adc #46
	sta ptr2
	lda joy_positions + 1,x
	adc #0
	sta ptr2 + 1
	lda port_digital
	and #$10
	jsr button

	ldx tmp
	cpx #4
	bcs end

	; button 2
	lda port_potx
	eor #$ff
	and #80
	jsr button

	; button 3
	lda port_poty
	eor #$ff
	and #80
	jsr button

end:
	rts
