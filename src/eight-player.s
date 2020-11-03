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

.export eight_player, eight_player_next_type, eight_player_previous_type, eight_player_next_page, eight_player_previous_page, handle_eight_player

.include "joyride.inc"
.macpack utility

eight_player_screen_start = screen + 40 * 2 + 1

.bss

eight_player_type:
	.res 1

eight_player_page:
	.res 1

.code

eight_player:
	ldx #<eight_player_irq_table
	ldy #>eight_player_irq_table
	lda eight_player_irq_table_length
	jsr set_irq_table

	lda #0
	ldy #7
:	sta VIC_SPR0_X,y
	dey
	bpl :-
	lda VIC_SPR_HI_X
	and #$f0
	sta VIC_SPR_HI_X

	memcpy screen, help_screen, 1000
	memcpy color_ram, help_color, 1000
	memcpy screen + 40 * 22, eight_player_legend, 120
	jsr copy_eight_player_screen
	rts

eight_player_next_type:
	; TODO
	rts

eight_player_previous_type:
	; TODO
	rts

eight_player_next_page:
	; TODO
	rts

eight_player_previous_page:
	; TODO
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
	; TODO: copy title
	rts

handle_eight_player:
	jsr display_logo
	
	jsr get_f_key
	beq none
	lda last_command
	bne end
	lda f_key_commands,x
	tax
	stx command
none:
	stx last_command
end:
	rts

	
.rodata

f_key_commands:
	.byte 0
	.byte COMMAND_EIGHT_PLAYER_NEXT_TYPE, COMMAND_EIGHT_PLAYER_PREVIOUS_TYPE
	.byte COMMAND_EIGHT_PLAYER_NEXT_PAGE, COMMAND_EIGHT_PLAYER_PREVIOUS_PAGE
	.byte 0, 0
	.byte COMMAND_HELP_EXIT, COMMAND_HELP

eight_player_screen:
	.word eight_player_screen_data
	.word eight_player_screen_data

eight_player_screen_data:
	.incbin "superpad.bin"
