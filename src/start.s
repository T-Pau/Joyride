;  start.s -- Entry point of program.
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
.export start

.include "joyride.inc"

.macpack cbm_ext
.macpack utility

.code

start:
	lda #12; COLOR_GREY2
	sta VIC_BORDERCOLOR

	memcpy charset, charset_data, $800
	memcpy sprites, sprite_data, (64 * 8)

	jsr init_state
	jsr display_main_screen

	set_vic_bank $4000
	set_vic_text screen, charset

	lda #$0f
	sta VIC_SPR_ENA
	lda #0
	sta VIC_SPR_BG_PRIO
	sta VIC_SPR_EXP_X
	sta VIC_SPR_EXP_Y
	sta VIC_SPR_MCOLOR

	lda #COLOR_WHITE
	sta VIC_SPR0_COLOR
	sta VIC_SPR1_COLOR
	sta VIC_SPR2_COLOR
	sta VIC_SPR3_COLOR

	jsr setup_logo

	lda #$ff
	sta CIA1_DDRA
	sta CIA1_DDRB

	jsr init_irq

	; set up serial loopback for userport adapters
	lda #0
	sta CIA2_DDRB
	lda #1
	sta CIA1_TA
	sta CIA2_TA
	lda #0
	sta CIA1_TA + 1
	sta CIA2_TA + 1
	lda #%00010001
	sta CIA2_CRA
	lda #%01010001
	sta CIA1_CRA

	jmp main_loop
