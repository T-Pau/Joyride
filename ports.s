.autoimport +

.export handle_port1_user, handle_port2

.include "joytest.inc"

.bss
port_digital:
	.res 1
port_potx:
	.res 1
port_poty:
	.res 1

tmp:
	.res 2

.rodata

joy_positions:
	.word screen + 4 * 40 + 2
	.word screen + 4 * 40 + 22
	.word screen + 15 * 40 + 8
	.word screen + 15 * 40 + 22

.code

handle_port1_user:
	jsr label_background
	; TODO: handle keyboard
	lda #$00
	sta CIA1_DDRB
	lda CIA1_PRB
	eor #$ff
	sta port_digital
	; TODO: read port 1 pots
	; TODO: set POTs to port 2
	ldx #1
	jsr display_port
	; TOOD: read user port 1
	lda #0
	sta port_digital
	ldx #3
	jsr display_port
	; TODO: read user port 2
	ldx #4
	jsr display_port
	rts

handle_port2:
	jsr content_background
	lda #$00
	sta CIA1_DDRA
	lda CIA1_PRA
	eor #$ff
	sta port_digital
	; TODO: read port 2 pots
	; TODO: set POTs to port 1
	ldx #2
	jsr display_port
	rts

display_port:
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
	tax
	jsr button
	rts
