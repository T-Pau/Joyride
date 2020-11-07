;  snespad.s -- Support routines for SuperPad64
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

.export superpad_read, superpad_display, snes_buttons

.autoimport +

.include "joyride.inc"

OFFSET_FIRST = 40 * 3 + 2
OFFSET_DOWN = 40 * 3 - 27
OFFSET_RIGHT = 40 * 6 - 11 ; negative
OFFSET_FOURTH = OFFSET_FIRST + 40 * 9 + 19

.macpack utility

.bss

snes_buttons:
	.res 16

index:
	.res 1

.code

superpad_read:
	lda command
	beq :+
	rts
:

	; display 4th pad (not enough time in border)
	store_word screen + OFFSET_FOURTH, ptr2
	lda eight_player_page
	asl
	asl
	asl
	tay
	lda snes_buttons + 6,y
	ldx snes_buttons + 7,y
	jsr display_snes

	; read new values

	; port B as input, port a line 2 as output (latch)
	lda CIA2_DDRA
	ora #$04
	sta CIA2_DDRA
	lda #$00
	sta CIA2_DDRB

	; pulse latch
	lda CIA2_PRA
	ora #$04
	sta CIA2_PRA
	and #($04 ^ $ff)
	sta CIA2_PRA

	ldy #12

bits:
	lda CIA2_PRB
	eor #$ff
;	lda #$A5; DEBUG
	ldx #0
pad:
	lsr
	ror snes_buttons + 1,x
	ror snes_buttons,x
	inx
	inx
	cpx #16
	bne pad
	dey
	bne bits
	rts

superpad_display:
	lda command
	beq :+
	rts
:
	store_word screen + OFFSET_FIRST, ptr2
	lda eight_player_page
	asl
	asl
	asl
	sta index
	tay
	lda snes_buttons,y
	ldx snes_buttons + 1,y
	jsr display_snes

	subtract_word ptr2, OFFSET_RIGHT
	ldy index
	lda snes_buttons + 2,y
	ldx snes_buttons + 3,y
	jsr display_snes

	add_word ptr2, OFFSET_DOWN
	ldy index
	lda snes_buttons + 4,y
	ldx snes_buttons + 5,y
	jmp display_snes
