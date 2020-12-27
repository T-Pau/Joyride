;  inception.s -- Support for Inception
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

.export inception_top, inception_bottom

.autoimport +

.include "joyride.inc"

.macpack utility

RAW_OFFSET_1 = 40 * 2 + 6
RAW_OFFSET_NEXT = 40 * 4
RAW_OFFSET_5 = 40 * 11 + 23 ; negative

OPCODE_JOYSTICKS = $00
OPCODE_IDENTIFY = $02

.bss

tmp:
	.res 1

length:
	.res 1

.code

inception_top:
.scope
	lda command
	beq :+
	rts
:
	ldx #1
	lda eight_player_type
	cmp #EIGHT_PLAYER_TYPE_INCEPTION_1
	beq :+
	dex
:
	store_word snes_buttons, ptr1
	lda #OPCODE_JOYSTICKS
;	lda #OPCODE_IDENTIFY
	ldy #16
	jsr inception_read
	rts
.endscope

inception_bottom:
	lda command
	beq :+
	rts
:

	lda eight_player_page
	cmp #2
	bne :+
	jmp display_raw
:	lda eight_player_views
	cmp #EIGHT_PLAYER_VIEW_JOYSTICK
	bne :+
	jmp spaceballs_bottom
:	rts


inception_read:
.scope
	sty length
    sta CIA1_PRA,x
	lda #$1f
	sta CIA1_DDRA,x
	lda #$10
	sta CIA1_PRA,x
	sta CIA1_DDRA,x

	ldy #0
loop:
	sta CIA1_PRA,x
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	lda CIA1_PRA,x
	asl
	asl
	asl
	asl
	sta tmp
	lda #0
	sta CIA1_PRA,x
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	lda CIA1_PRA,x
	and #$0f
	ora tmp
	sta (ptr1),y
	lda #$10
	iny
	cpy length
	bne loop
	rts
.endscope

display_raw:
	store_word screen + EIGHT_PLAYER_OFFSET_FIRST + RAW_OFFSET_1, ptr2
	ldx #0
	jsr display_raw_one
	add_word ptr2, RAW_OFFSET_NEXT
	ldx #1
	jsr display_raw_one
	add_word ptr2, RAW_OFFSET_NEXT
	ldx #2
	jsr display_raw_one
	add_word ptr2, RAW_OFFSET_NEXT
	ldx #3
	jsr display_raw_one

	subtract_word ptr2, RAW_OFFSET_5
	ldx #4
	jsr display_raw_one
	add_word ptr2, RAW_OFFSET_NEXT
	ldx #5
	jsr display_raw_one
	add_word ptr2, RAW_OFFSET_NEXT
	ldx #6
	jsr display_raw_one
	add_word ptr2, RAW_OFFSET_NEXT
	ldx #7
	jmp display_raw_one

display_raw_one:
	ldy #0
	txa
	clc
	adc #$01
	sta (ptr2),y
	iny
	lda #$3a
	sta (ptr2),y
	iny
	iny
	lda snes_buttons,x
	stx tmp
	jsr hex
	iny
	ldx tmp
	lda snes_buttons1,x
	jmp hex
