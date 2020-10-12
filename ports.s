.autoimport +

.export handle_port1_user, handle_port2
.export port1_type, port2_type, userport_type

.include "joytest.inc"

.bss
port1_type:
	.res 1
port2_type:
	.res 1
userport_type:
	.res 1

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

	; read POTx/POTy
	lda SID_ADConv1
	sta port_potx
	lda SID_ADConv2
	sta port_poty

	; read digital input
	lda #$00
	sta CIA1_DDRB
	lda CIA1_PRB
	eor #$ff
	sta port_digital

	; TODO: handle keyboard

	; select POTs from port 2
	ldx #$bf
	sta CIA1_PRA

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

	; read POTx/POTy
	lda SID_ADConv1
	sta port_potx
	lda SID_ADConv2
	sta port_poty

	; read control port 2
	lda #$00
	sta CIA1_DDRA
	lda CIA1_PRA
	eor #$ff
	sta port_digital

	; select POTs from port 1
    ldx #$7f
    stx CIA1_PRB

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
	clc
	lda ptr2
	adc #3
	sta ptr2
	lda ptr2 + 1
	adc #0
	sta ptr2 + 1
	lda port_potx
	eor #$ff
	and #80
	jsr button

	; button 3
	clc
	lda ptr2
	adc #3
	sta ptr2
	lda ptr2 + 1
	adc #0
	sta ptr2 + 1
	lda port_poty
	eor #$ff
	and #80
	jsr button

end:
	rts
