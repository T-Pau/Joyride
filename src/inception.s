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

.include "joyride.inc"

.macpack utility

.autoimport +

.bss

temp:
	.res 1

.code

inception_top:
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
    lda #$00
    sta CIA1_PRA,x
	sta CIA1_DDRA,x
	lda #$1f
	sta CIA1_DDRA,x
	lda #$10
	sta CIA1_PRA,x
	sta CIA1_DDRA,x
	
	ldy #0
loop:
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
	sta temp
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
	ora temp
	sta snes_buttons,y
	lda #$10
	sta CIA1_PRA,x
	iny
	cpy #8
	bne loop
	
	ldx #7
	lda #0
	ldy #EIGHT_PLAYER_VIEW_NONE
:	ora snes_buttons,x
	dex
	bpl :-
	and #$e0
	bne :+
	ldy #EIGHT_PLAYER_VIEW_JOYSTICK
:	tya
	jsr eight_player_set_all_views
	rts

inception_bottom:
	lda eight_player_views
	cmp #EIGHT_PLAYER_VIEW_JOYSTICK
	bne :+
	jmp spaceballs_bottom
:	rts
