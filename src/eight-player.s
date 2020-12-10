;  eight_player.s -- Display and handle keyboard input for 8 player adapters.
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

.export eight_player_next_type, eight_player_previous_type, eight_player_next_page, eight_player_previous_page, eight_player_bottom, eight_player_top, eight_player_update_views, copy_eight_player_type_name, eight_player_set_all_views

.include "joyride.inc"
.macpack utility
.macpack cbm_ext

eight_player_screen_start = screen + 40 * 2 + 1

.bss

index:
	.res 2

.code

eight_player_next_type:
	ldx eight_player_type
	inx
	cpx #EIGHT_PLAYER_NUM_TYPES
	bne :+
	ldx #0
:	stx eight_player_type
	ldx #0
	stx eight_player_page
	jsr copy_eight_player_type_name
	rts

eight_player_previous_type:
	ldx eight_player_type
	dex
	bpl :+
	ldx #(EIGHT_PLAYER_NUM_TYPES - 1)
:	stx eight_player_type
	ldx #0
	stx eight_player_page
	jsr copy_eight_player_type_name
	rts

eight_player_next_page:
	ldx eight_player_type
	ldy eight_player_page
	iny
	tya
	cmp eight_player_num_pages,x
	bne :+
	ldy #0
:	sty eight_player_page
	jsr eight_player_update_views
	jsr copy_eight_player_page_title
	rts

eight_player_previous_page:
	ldy eight_player_page
	dey
	bpl :+
	ldx eight_player_type
	ldy eight_player_num_pages,x
	dey
:	sty eight_player_page
	jsr eight_player_update_views
	jsr copy_eight_player_page_title
	rts
	
eight_player_set_all_views:
.scope
	ldy #0
	ldx #7
loop:
	cmp eight_player_views,x
	beq :+
	iny
	sta eight_player_views,x
:	dex
	bpl loop
	cpy #0
	beq :+
	lda #COMMAND_EIGHT_PLAYER_UPDATE_VIEWS
	sta command
:	rts
.endscope

eight_player_update_views:
	lda eight_player_page
	asl
	asl
	tax
	stx index
	ldy #0
	sty index + 1
view_loop:
	lda eight_player_views,x
	cmp eight_player_current_views,y
	beq same_view
	sta eight_player_current_views,y
	tax
	lda view_sprite,x
	sta screen + $3f8,y
	txa
	asl
	tax
	lda eight_player_view,x
	sta ptr1
	lda eight_player_view + 1,x
	sta ptr1 + 1
	tya
	asl
	tay
	lda #0
	sta VIC_SPR0_X,y
	sta VIC_SPR0_Y,y
	lda view_start,y
	sta ptr2
	lda view_start + 1,y
	sta ptr2 + 1
	ldx #18
	ldy #9
	jsr copyrect
same_view:
	ldx index
	inx
	stx index
	ldy index + 1
	iny
	sty index + 1
	cpy #4
	bne view_loop
	rts

copy_eight_player_type_name:
	ldx eight_player_type
	lda eight_player_default_view,x
	ldx #7
:	sta eight_player_views,x
	dex
	bpl :-
	jsr eight_player_update_views
	store_word screen + 1, ptr2
	lda eight_player_type
	asl
	tax
	lda eight_player_type_name,x
	sta ptr1
	lda eight_player_type_name + 1,x
	sta ptr1 + 1
	ldy #19
:	lda (ptr1),y
	sta (ptr2),y
	dey
	bpl :-
	; fallthrough
copy_eight_player_page_title:
	store_word screen + 35, ptr2
	ldx eight_player_type
	lda eight_player_page_name_index,x
	clc
	adc eight_player_page
	asl
	tax
	lda eight_player_page_name,x
	sta ptr1
	lda eight_player_page_name + 1,x
	sta ptr1 + 1
	ldy #2
:	lda (ptr1),y
	sta (ptr2),y
	dey
	bpl :-
	rts

eight_player_top:
	jsr content_background

	lda eight_player_type
	asl
	tax
	lda top_handler,x
	sta top_jmp + 1
	lda top_handler + 1,x
	sta top_jmp + 2
top_jmp:
	jmp $0000

eight_player_bottom:
	jsr display_logo

	lda eight_player_type
	asl
	tax
	lda bottom_handler,x
	sta bottom_jmp + 1
	lda bottom_handler + 1,x
	sta bottom_jmp + 2
bottom_jmp:
	jsr $0000

	jsr get_f_key
	beq none
	lda last_command
	ora command
	bne end
	lda f_key_commands,x
	tax
	stx command
none:
	stx last_command
end:
	rts


.rodata

view_start:
	.word screen + EIGHT_PLAYER_OFFSET_FIRST
	.word screen + EIGHT_PLAYER_OFFSET_SECOND
	.word screen + EIGHT_PLAYER_OFFSET_THIRD
	.word screen + EIGHT_PLAYER_OFFSET_FOURTH

view_sprite:
	.byte sprite_none
	.byte sprite_none
	.byte sprite_none
	.byte sprite_cross
	
top_handler:
	.word superpad_top
	.word superpad_top
	.word spaceballs_top
	.word spaceballs_top
.ifdef ENABLE_INCEPTION
	.word inception_top
	.word inception_top
.endif

bottom_handler:
	.word superpad_bottom
	.word superpad_bottom
	.word spaceballs_bottom
	.word spaceballs_bottom
.ifdef ENABLE_INCEPTION
	.word inception_bottom
	.word inception_bottom
.endif

f_key_commands:
	.byte 0
	.byte COMMAND_EIGHT_PLAYER_NEXT_TYPE, COMMAND_EIGHT_PLAYER_PREVIOUS_TYPE
	.byte COMMAND_EIGHT_PLAYER_NEXT_PAGE, COMMAND_EIGHT_PLAYER_PREVIOUS_PAGE
	.byte 0, 0
	.byte COMMAND_MAIN, COMMAND_HELP

eight_player_num_pages:
	.byte 2, 2, 2, 2, 2, 2

eight_player_default_view:
	.byte EIGHT_PLAYER_VIEW_NONE
	.byte EIGHT_PLAYER_VIEW_NONE
	.byte EIGHT_PLAYER_VIEW_JOYSTICK
	.byte EIGHT_PLAYER_VIEW_JOYSTICK
	.byte EIGHT_PLAYER_VIEW_JOYSTICK
	.byte EIGHT_PLAYER_VIEW_JOYSTICK

eight_player_type_name:
	.repeat EIGHT_PLAYER_NUM_TYPES, i
	.word eight_player_type_name_data + i * 20
	.endrep

eight_player_type_name_data:
	;        12345678901234567890
	invcode "superpad 64         "
	invcode "ninja snes pad      "
	invcode "spaceballs port 1   "
	invcode "spaceballs port 2   "
.ifdef ENABLE_INCEPTION
	invcode "inception port 1    "
	invcode "inception port 2    "
.endif

; index into eight_player_page_name by type
eight_player_page_name_index:
	.byte 0, 0, 0, 0
.ifdef ENABLE_INCEPTION
	.byte 2, 2
.endif

eight_player_page_name:
	.repeat 4, i
	.word eight_player_page_name_data + i * 3
	.endrep

eight_player_page_name_data:
	invcode "1-4"
	invcode "5-8"
.ifdef ENABLE_INCEPTION
	invcode "a-d"
	invcode "e-h"
.endif

eight_player_view:
	.repeat EIGHT_PLYAER_NUM_VIEWS, i
	.word eight_player_view_data + i * 18 * 9
	.endrep

eight_player_view_data:
	.incbin "eight-player.bin"
