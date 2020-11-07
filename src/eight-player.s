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

.export eight_player_next_type, eight_player_previous_type, eight_player_next_page, eight_player_previous_page, handle_eight_player, eight_player_read, copy_eight_player_screen

.include "joyride.inc"
.macpack utility
.macpack cbm_ext

eight_player_screen_start = screen + 40 * 2 + 1

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
	jsr copy_eight_player_screen
	rts

eight_player_previous_type:
	ldx eight_player_type
	dex
	bpl :+
	ldx #(EIGHT_PLAYER_NUM_TYPES - 1)
:	stx eight_player_type
	ldx #0
	stx eight_player_page
	jsr copy_eight_player_screen
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
	; jsr copy_eight_player_screen ; currently not needed
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
	; jsr copy_eight_player_screen ; currently not needed
	jsr copy_eight_player_page_title
	rts

copy_eight_player_screen:
	lda eight_player_type
	asl
	tax
	lda eight_player_screen,x
	sta ptr1
	lda eight_player_screen + 1,x
	sta ptr1 + 1
	store_word eight_player_screen_start, ptr2
	ldx #37
	ldy #18
	jsr copyrect

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

	jsr copy_eight_player_page_title

	rts

copy_eight_player_page_title:
	store_word screen + 35, ptr2
	lda eight_player_page
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

eight_player_read:
	jsr content_background

	lda eight_player_type
	asl
	tax
	lda read_handler,x
	sta read_jmp + 1
	lda read_handler + 1,x
	sta read_jmp + 2
read_jmp:
	jmp $0000

handle_eight_player:
	jsr display_logo

	lda eight_player_type
	asl
	tax
	lda display_handler,x
	sta display_jmp + 1
	lda display_handler + 1,x
	sta display_jmp + 2
display_jmp:
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

read_handler:
	.word superpad_read
	;.word snespad_read

display_handler:
	.word superpad_display
	;.word snespad_display

f_key_commands:
	.byte 0
	.byte COMMAND_EIGHT_PLAYER_NEXT_TYPE, COMMAND_EIGHT_PLAYER_PREVIOUS_TYPE
	.byte COMMAND_EIGHT_PLAYER_NEXT_PAGE, COMMAND_EIGHT_PLAYER_PREVIOUS_PAGE
	.byte 0, 0
	.byte COMMAND_MAIN, COMMAND_HELP

eight_player_num_pages:
	.byte 2, 2

eight_player_type_name:
	.repeat EIGHT_PLAYER_NUM_TYPES, i
	.word eight_player_type_name_data + i * 20
	.endrep

eight_player_type_name_data:
	;        12345678901234567890
	invcode "superpad 64         "
	invcode "ninja snes pad      "

eight_player_page_name:
	.repeat 2, i
	.word eight_player_page_name_data + i * 3
	.endrep

eight_player_page_name_data:
	invcode "1-4"
	invcode "5-8"

eight_player_screen:
	.word eight_player_screen_data
	.word eight_player_screen_data

eight_player_screen_data:
	.incbin "superpad.bin"
