.autoimport +

.export handle_port1_user, handle_port2
.export port1_type, port2_type, userport_type
.export port_number, port_digital, port_potx, port_poty

.include "joytest.inc"

.bss

port1_type:
	.res 1
port2_type:
	.res 1
userport_type:
	.res 1

port_number:
	.res 1
port_digital:
	.res 2
port_potx:
	.res 1
port_poty:
	.res 1

.code

handle_port1_user:
	jsr display_logo

	; read POTx/POTy
	lda SID_ADConv1
	sta port_potx
	lda SID_ADConv2
	sta port_poty

	; read digital input
	lda #$ff
	sta CIA1_PRA
	sta CIA1_PRB
	lda CIA1_PRB
	eor #$ff
	sta port_digital

	jsr handle_keyboard

	; select POTs from port 2
	lda #$80
	sta CIA1_PRA

	ldx #0
	jsr display_port

	jsr read_userport
	ldx #2
	jsr display_joystick
	lda port_digital + 1
	sta port_digital
	ldx #3
	jsr display_joystick
	rts

handle_port2:
	jsr content_background

	; read POTx/POTy
	lda SID_ADConv1
	sta port_potx
	lda SID_ADConv2
	sta port_poty

	; read control port 2
	lda #$ff
	sta CIA1_PRA
	sta CIA1_PRB
	lda CIA1_PRA
	eor #$ff
	sta port_digital

	; select POTs from port 1
    lda #$40
    sta CIA1_PRA

	ldx #1
	jsr display_port
	rts

