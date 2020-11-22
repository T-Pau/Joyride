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

.export superpad_top, superpad_bottom, snes_buttons, snes_buttons1, snes_buttons2, snes_buttons3, snes_buttons_end

.export detect_connected ; DEBUG

.autoimport +

.include "joyride.inc"

CONTROLELR_OFFSET = 40 + 1

.macpack utility

.bss

snes_buttons:
	.res 8 * 4

snes_buttons1 = snes_buttons + 8
snes_buttons2 = snes_buttons + 8 * 2
snes_buttons3 = snes_buttons + 8 * 3
snes_buttons_end = snes_buttons + 8 * 4

index:
	.res 1

.code

superpad_top:
	lda command
	beq :+
	rts
:
	; display 4th pad (not enough time in border)
	store_word screen + EIGHT_PLAYER_OFFSET_FOURTH + CONTROLELR_OFFSET, ptr2
	lda eight_player_page
	asl
	asl
	tay
	lda eight_player_views + 3,y
	cmp #EIGHT_PLAYER_VIEW_SNES
	bne read
	lda snes_buttons + 3,y
	ldx snes_buttons1 + 3,y
	jsr display_snes

read:
	; read new values

	lda eight_player_type
	beq :+
	jsr snespad_read
	jmp detect_connected

:
	lda #<snes_buttons
	sta rot + 1
	lda #>snes_buttons
	sta rot + 2

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

bytes:
	ldy #7

bits:
	lda CIA2_PRB
	eor #$ff
	ldx #7
pad:
	asl
rot:
	rol $1000,x
	dex
	bpl pad
	dey
	bpl bits

	clc
	lda rot + 1
	adc #8
	sta rot + 1
	bcc :+
	inc rot + 2
:	cmp #<snes_buttons_end
	bne bytes

detect_connected:
	; nothing: 00 00 00 00
	; joypad:  xx x0 ff ff
	; mouse:   00 x1 xx xx

	ldy #0
	ldx #7
detect:
	lda snes_buttons1,x
	and #$0f
	cmp #$0f
	beq none
	cmp #$01
	bne :+
	lda #EIGHT_PLAYER_VIEW_MOUSE
	bne detected
:
	lda snes_buttons2,x
	beq none
	lda #EIGHT_PLAYER_VIEW_SNES
	bne detected
none:
	lda #EIGHT_PLAYER_VIEW_NONE
detected:
	cmp eight_player_views,x
	beq :+
	iny
:	sta eight_player_views,x
	dex
	bpl detect
	cpy #0
	beq :+
	lda #COMMAND_EIGHT_PLAYER_UPDATE_VIEWS
	sta command
:	rts

superpad_bottom:
	lda command
	beq :+
	rts
:

	lda eight_player_page
	asl
	asl
	sta index
	tay
	lda eight_player_views,y
	cmp #EIGHT_PLAYER_VIEW_SNES
	bne second
	store_word screen + EIGHT_PLAYER_OFFSET_FIRST + CONTROLELR_OFFSET, ptr2
	lda eight_player_page
	lda snes_buttons,y
	ldx snes_buttons1,y
	jsr display_snes

second:
	store_word screen + EIGHT_PLAYER_OFFSET_SECOND + CONTROLELR_OFFSET, ptr2
	ldy index
	lda eight_player_views + 1,y
	cmp #EIGHT_PLAYER_VIEW_SNES
	bne third
	lda snes_buttons + 1,y
	ldx snes_buttons1 + 1,y
	jsr display_snes

third:
	store_word screen + EIGHT_PLAYER_OFFSET_THIRD + CONTROLELR_OFFSET, ptr2
	ldy index
	lda eight_player_views + 2,y
	cmp #EIGHT_PLAYER_VIEW_SNES
	bne fourth
	lda snes_buttons + 2,y
	ldx snes_buttons1 + 2,y
	jmp display_snes
fourth:
	rts
