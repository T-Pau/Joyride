;  spaceballs.s -- Support for Luigi Pantarotto's Spaceballs Addapter
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

.export spaceballs_top, spaceballs_bottom

.include "joyride.inc"

.macpack utility

DPAD_OFFSET = 40 * 2 + 5
BUTTON_OFFSET = 40 * 4 - 6 ; negative

.autoimport +

.bss

index:
	.res 1

end_index:
	.res 1

.code

spaceballs_top:
	lda command
	beq :+
	rts
:
	lda #EIGHT_PLAYER_VIEW_JOYSTICK
	jsr eight_player_set_all_views

	ldx #1
	lda eight_player_type
	cmp #EIGHT_PLAYER_TYPE_SPACEBALLS_1
	beq :+
	dex
:
	lda #$ff
	sta CIA2_DDRB
	sta CIA1_PRA,x
	lda #$00
	sta CIA1_DDRA,x

	ldy #7
read_loop:
	lda bits,y
	sta CIA2_PRB
	lda CIA1_PRA,x
	and #$1f
	eor #$1f
	sta snes_buttons,y
	dey
	bpl read_loop

	rts

spaceballs_bottom:
	lda command
	beq :+
	rts
:
	lda eight_player_page
	asl
	asl
	sta index
	clc
	adc #4
	sta end_index

loop:
	ldx index
	cpx end_index
	beq end
	txa

	and #3
	asl
	tay
	lda display_start,y
	sta ptr2
	lda display_start + 1,y
	sta ptr2 + 1

	lda snes_buttons,x
	inx
	stx index
	and #$f
	jsr dpad

	subtract_word ptr2, BUTTON_OFFSET
	ldx index
	lda snes_buttons,x
	and #$10
	jsr button
	jmp loop

end:
	rts

.rodata

display_start:
	.word screen + EIGHT_PLAYER_OFFSET_FIRST + DPAD_OFFSET
	.word screen + EIGHT_PLAYER_OFFSET_SECOND + DPAD_OFFSET
	.word screen + EIGHT_PLAYER_OFFSET_THIRD + DPAD_OFFSET
	.word screen + EIGHT_PLAYER_OFFSET_FOURTH + DPAD_OFFSET

bits:
	.byte $01 ^ $ff, $02 ^ $ff, $04 ^ $ff, $08 ^ $ff, $10 ^ $ff, $20 ^ $ff, $40 ^ $ff, $80 ^ $ff
