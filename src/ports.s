;  ports.s -- Display state of ports.
;  Copyright (C) 2020 Dieter Baron
;
;  This file is part of Joyride, a controller test program for C64.
;  The authors can be contacted at <joyride@tpau.group>.
;
;  Redistribution and use in source and binary forms, with or without
;  modification, are permitted provided that the following conditions
;  are met:
;  1. Redistributions of source code must retain the above copyright
;     notice, this list of conditions and the following disclaimer.
;  2. The names of the authors may not be used to endorse or promote
;     products derived from this software without specific prior
;     written permission.
;
;  THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS
;  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;  ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
;  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
;  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
;  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
;  IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

.autoimport +

.export handle_port1_user, handle_port2
.export port1_type, port2_type, userport_type
.export port_number, port_digital, port_potx, port_poty

.include "joyride.inc"

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
	lda #$00
	sta CIA1_DDRA
	sta CIA1_DDRB
	lda #$ff
	sta CIA1_PRA
	eor CIA1_PRB
	sta port_digital

	jsr handle_keyboard

	; select POTs from port 2
	lda #$c0
	sta CIA1_DDRA
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
	lda #$00
	sta CIA1_DDRA
	sta CIA1_DDRB
	lda #$ff
	sta CIA1_PRB
	eor CIA1_PRA
	sta port_digital

	; select POTs from port 1
	lda #$c0
	sta CIA1_DDRA
    lda #$40
    sta CIA1_PRA

	ldx #1
	jsr display_port
	rts

