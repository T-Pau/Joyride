;  screen.s -- Screen contents.
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

.export display_main_screen, display_help_screen, display_eight_player_screen, display_current_screen

.autoimport +

.include "joyride.inc"

.macpack cbm
.macpack cbm_ext
.macpack utility

.rodata

main_screen:
	invcode " port 1:             port 2:            "
	scrcode "I                 J"
	.byte $a0
	scrcode "I                 J"
	.byte $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	scrcode "KMMMMMMMMMMMMMMMMML"
	.byte $a0
	scrcode "KMMMMMMMMMMMMMMMMML"
	.byte $a0
	invcode "                                        "
	invcode "    user port:                          "
	.byte $a0, $a0, $a0
	scrcode "I                               J"
	.byte $a0, $a0, $a0, $a0
	.byte $a0, $a0, $a0, "                                 ", $a0, $a0, $a0, $a0
	.byte $a0, $a0, $a0
	scrcode "           AHB           AHB     "
	.byte $a0, $a0, $a0, $a0,  $a0, $a0, $a0
	scrcode "           EfF           EfF     "
	.byte $a0, $a0, $a0, $a0,  $a0, $a0, $a0
	scrcode "           CGD           CGD     "
	.byte $a0, $a0, $a0, $a0
	.byte $a0, $a0, $a0, "                                 ", $a0, $a0, $a0, $a0
	.byte $a0, $a0, $a0
	scrcode "KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMML"
	.byte $a0, $a0, $a0, $a0
	invcode "                                        "
	invcode "     f1/f2: port 1   f3/f4: port 2      "
	invcode "  f5/f6: user port   f7: multi adapter  "
	invcode "               f8: help                 "

help_screen:
	invcode "                                        "
	scrcode "I                                     J"
	.byte $a0
	.repeat 18, i
	scrcode "                                       "
	.byte $a0
	.endrep
	scrcode "KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMML"
	.byte $a0
	invcode "                                        "
	invcode "  space/+: next page  -: previous page  "
	invcode "         "
	.byte $9f
	invcode            ": return to program          "
	invcode "                                        "

eight_player_legend:
	invcode "   f1/f2: adapter type   f3/f4: page    "
	invcode "      f7: controller & user ports       "
	invcode "               f8: help                 "


.code

display_main_screen:
	lda #MODE_MAIN
	sta mode

	memcpy screen, main_screen, 1000
	memcpy color_ram, main_color, 1000
	ldy #0
	jsr copy_port_screen
	ldy #1
	jsr copy_port_screen
	jsr copy_userport
	ldx #<main_irq_table
	ldy #>main_irq_table
	lda main_irq_table_length
	jsr set_irq_table
	rts

display_eight_player_screen:
	lda #MODE_EIGHT_PLAYER
	sta mode

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

	ldx #7
	lda EIGHT_PLAYER_VIEW_NONE
:	sta eight_player_views,x
	dex
	bpl :-
	ldx #3
:	sta eight_player_current_views,x
	dex
	bpl :-

	memcpy screen, help_screen, 1000
	memcpy color_ram, help_color, 1000
	memcpy screen + 40 * 22, eight_player_legend, 120
	jsr copy_eight_player_type_name
	rts

display_help_screen:
	ldx #<help_irq_table
	ldy #>help_irq_table
	lda help_irq_table_length
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
	ldx #0
	stx current_help_page
	jsr display_help_page
	rts

display_current_screen:
	lda mode
	bne :+
	jmp display_main_screen
:	jmp display_eight_player_screen
