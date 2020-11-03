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
	memcpy screen + 40 * 22, eight_player_legend, 80
	; TODO: display current page
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

handle_eight_player:
	jsr display_logo
	
	lda #$00
	sta CIA1_DDRA
	sta CIA1_DDRB
	
	lda CIA1_PRA
	and CIA1_PRB
	cmp #$ff
	bne end
	
	lda #$ff
	sta CIA1_DDRA
	
	lda #$80 ^ $ff
	sta CIA1_PRA
	lda CIA1_PRB
	tax
	and #$02
	bne :+
	lda #COMMAND_HELP_EXIT
	bne got_key
:	txa
	and #$10
	bne :+
	lda #COMMAND_HELP_NEXT
	bne got_key
:	lda #$20 ^ $ff
	sta CIA1_PRA
	lda CIA1_PRB
	and #$01
	bne :+
	lda #COMMAND_HELP_NEXT
	bne got_key
:	lda CIA1_PRB
	and #$08
	beq :+
	lda #0
	sta last_command
	beq end	
:	lda #COMMAND_HELP_PREVIOUS	
got_key:
	cmp last_command
	beq end
	sta last_command
	sta command
end:
	lda #$ff
	sta CIA1_DDRB
	rts
