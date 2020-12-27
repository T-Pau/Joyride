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
MOUSE_OFFSET = 40 + 11

MOUSE_R_OFFSET = 3
MOUSE_X_OFFSET = 40 * 5 - 1
MOUSE_Y_OFFSET = 40

RAW_OFFSET_1 = 40 * 2 + 2
RAW_OFFSET_NEXT = 40 * 4
RAW_OFFSET_5 = 40 * 11 + 21 ; negative

.macpack utility

.bss

snes_buttons:
	.res 8 * 4

snes_buttons1 = snes_buttons + 8
snes_buttons2 = snes_buttons + 8 * 2
snes_buttons3 = snes_buttons + 8 * 3
snes_buttons_end = snes_buttons + 8 * 4

snes_x:
	.res 8
snes_y:
	.res 8

index:
	.res 1

tmp:
	.res 1

.code

superpad_top:
	lda command
	beq :+
	rts
:
	lda eight_player_page
	cmp #2
	beq read
	; display 4th pad (not enough time in border)
	asl
	asl
	tay
	iny
	iny
	iny
	sty index
	lda eight_player_views,y
	cmp #EIGHT_PLAYER_VIEW_SNES
	beq :+
	cmp #EIGHT_PLAYER_VIEW_MOUSE
	bne read
	store_word screen + EIGHT_PLAYER_OFFSET_FOURTH + MOUSE_OFFSET, ptr2
	jsr display_snes_mouse
	jmp read
:	store_word screen + EIGHT_PLAYER_OFFSET_FOURTH + CONTROLELR_OFFSET, ptr2
	lda snes_buttons,y
	ldx snes_buttons1,y
	ldy #0
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
	cmp #2
	bne :+
	jmp display_raw
:
	asl
	asl
	sta index
	tay
	lda eight_player_views,y
	cmp #EIGHT_PLAYER_VIEW_SNES
	beq :+
	cmp #EIGHT_PLAYER_VIEW_MOUSE
	bne second
	store_word screen + EIGHT_PLAYER_OFFSET_FIRST + MOUSE_OFFSET, ptr2
	jsr display_snes_mouse
	jmp second
:	store_word screen + EIGHT_PLAYER_OFFSET_FIRST + CONTROLELR_OFFSET, ptr2
	lda snes_buttons,y
	ldx snes_buttons1,y
	ldy #0
	jsr display_snes

second:
	ldy index
	iny
	sty index
	lda eight_player_views,y
	cmp #EIGHT_PLAYER_VIEW_SNES
	beq :+
	cmp #EIGHT_PLAYER_VIEW_MOUSE
	bne third
	store_word screen + EIGHT_PLAYER_OFFSET_SECOND + MOUSE_OFFSET, ptr2
	jsr display_snes_mouse
	jmp third
:	store_word screen + EIGHT_PLAYER_OFFSET_SECOND + CONTROLELR_OFFSET, ptr2
	lda snes_buttons,y
	ldx snes_buttons1,y
	ldy #0
	jsr display_snes

third:
	ldy index
	iny
	sty index
	lda eight_player_views,y
	cmp #EIGHT_PLAYER_VIEW_SNES
	beq :+
	cmp #EIGHT_PLAYER_VIEW_MOUSE
	bne fourth
	store_word screen + EIGHT_PLAYER_OFFSET_THIRD + MOUSE_OFFSET, ptr2
	jsr display_snes_mouse
	jmp fourth
:	store_word screen + EIGHT_PLAYER_OFFSET_THIRD + CONTROLELR_OFFSET, ptr2
	lda snes_buttons,y
	ldx snes_buttons1,y
	ldy #0
	jmp display_snes
fourth:
	rts

display_snes_mouse:
	lda snes_buttons3,y
	bmi minus_x
	clc
	adc snes_x,y
	bcc :+
	lda #$ff
:	sta snes_x,y
	jmp compute_y
minus_x:
	and #$7f
	sta tmp
	lda snes_x,y
	sec
	sbc tmp
	bcs :+
	lda #$00
:	sta snes_x,y
compute_y:
	lda snes_buttons2,y
	bmi minus_y
	clc
	adc snes_y,y
	bcc :+
	lda #$ff
:	sta snes_y,y
	jmp mouse_display
minus_y:
	and #$7f
	sta tmp
	lda snes_y,y
	sec
	sbc tmp
	bcs :+
	lda #$00
:	sta snes_y,y

mouse_display:
	lda snes_buttons1,y
	and #$40
	jsr small_button
	add_word ptr2, MOUSE_R_OFFSET
	ldy index
	lda snes_buttons1,y
	and #$80
	jsr small_button
	add_word ptr2, MOUSE_X_OFFSET
	ldy index
	lda snes_x,y
	ldy #0
	ldx #1
	jsr pot_number
	add_word ptr2, MOUSE_Y_OFFSET
	ldy index
	lda snes_y,y
	ldy #0
	ldx #1
	jsr pot_number

	ldy index
	tya
	and #$3
	asl
	tax
	lda sprite_x_offset + 1,x
	sta sprite_x + 1
	lda snes_x,y
	lsr
	lsr
	clc
	adc sprite_x_offset,x
	sta sprite_x
	bcc :+
	inc sprite_x + 1
:
	lda snes_y,y
	lsr
	lsr
	clc
	adc sprite_y_offset,x
	sta sprite_y
	txa
	lsr
	jsr set_sprite
	rts

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
	adc #$31
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
	jsr hex
	iny
	ldx tmp
	lda snes_buttons2,x
	jsr hex
	iny
	ldx tmp
	lda snes_buttons3,x
	jmp hex

.rodata

sprite_x_offset:
	.word 24 + 18
	.word 24 + 18 + 19 * 8
	.word 24 + 18
	.word 24 + 18 + 19 * 8

sprite_y_offset:
	.word top + 18
	.word top + 18
	.word top + 18 + 9 * 8
	.word top + 18 + 9 * 8
