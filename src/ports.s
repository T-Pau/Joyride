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

.export handle_port1, handle_port2, handle_top, handle_user
.export port1_type, port2_type, userport_type
.export port_number, port_digital, port_pot1, port_pot2, pen_x, pen_y

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
port_pot1:
	.res 1
port_pot2:
	.res 1
pen_x:
	.res 1
pen_y:
	.res 2

pen_x_new:
	.res 1

pen_y_new:
	.res 1

.code

handle_top:
	lda #0
	ldx VIC_LPEN_X
	ldy VIC_LPEN_Y
	bmi :+
	lda #1
:	cpx pen_x
	bne top_change
	cpy pen_y
	beq top_no_change
top_change:
	stx pen_x
	sty pen_y
	sta pen_y + 1
top_no_change:
	lda port1_type
	cmp #TYPE_LIGHTPEN
	bne :+
	jsr lightpen_sprite_top
:	rts

handle_user:
	jsr content_background
	lda command
	bne user_end
	jsr read_userport
	ldx #2
	jsr display_joystick
	lda port_digital + 1
	sta port_digital
	ldx #3
	jsr display_joystick
user_end:
	rts

handle_port1:
	lda VIC_LPEN_X
	sta pen_x_new
	lda VIC_LPEN_Y
	sta pen_y_new

	jsr display_logo

	; read POT1/POT2
	lda SID_ADConv1
	sta port_pot1
	lda SID_ADConv2
	sta port_pot2

	; read digital input
	lda #$00
	sta CIA1_DDRA
	sta CIA1_DDRB
	lda #$ff
	sta CIA1_PRA
	eor CIA1_PRB
	sta port_digital

	; handle lightpen
	ldx pen_x_new
	ldy pen_y_new
	cpx pen_x
	bne bottom_change
	cpy pen_y
	beq bottom_no_change
bottom_change:
	stx pen_x
	sty pen_y
	lda #0
	sta pen_y + 1
bottom_no_change:

	jsr handle_keyboard

	; select POTs from port 2
	lda #$c0
	sta CIA1_DDRA
	lda #$80
	sta CIA1_PRA

	lda command
	bne end_port1
	ldx #0
	jsr display_port
end_port1:
	rts

handle_port2:
	jsr content_background

	; read POT1/POT2
	lda SID_ADConv1
	sta port_pot1
	lda SID_ADConv2
	sta port_pot2

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

	lda port1_type
	cmp #TYPE_LIGHTPEN
	bne :+
	jsr lightpen_sprite_bottom
:

	lda command
	bne end_port2
	ldx #1
	jsr display_port
end_port2:
	rts

