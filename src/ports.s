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
	.res 1
port_potx:
	.res 1
port_poty:
	.res 1

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

	jsr handle_keyboard

	; select POTs from port 2
	lda #$c0
	sta CIA1_DDRA
	lda #$80
	sta CIA1_PRA

	ldx #0
	jsr display_port

	; TOOD: read user port 1
	lda #0
	sta port_digital
	ldx #2
	jsr display_joystick
	; TODO: read user port 2
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
	lda #$00
	sta CIA1_DDRA
	lda CIA1_PRA
	eor #$ff
	sta port_digital

	; select POTs from port 1
	lda #$c0
	sta CIA1_DDRA
    lda #$40
    sta CIA1_PRA

	ldx #1
	jsr display_port
	rts

