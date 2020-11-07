;  snes.s -- Display SNES controller.
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

.export display_snes

.autoimport +

.include "joyride.inc"

.macpack utility

OFFSET_X = 10
OFFSET_R = 4
OFFSET_DPAD = 40 - 12
OFFSET_Y = 40 * 4- 6 ; negative
OFFSET_B = 4
OFFSET_A = 40 * 2- 2
OFFSET_SELECT = 40 * 2 - 5
OFFSET_START = 3

.bss

buttons:
	; 0,  1,    2,    3,      4, 5, 6,   7
	; 01  02    04    08      10 20 40   80
	; up, down, left, right,  A, X, L,   R
	;                         B, Y, sel, start
	.res 2

.code

display_snes:
	sta buttons
	stx buttons + 1

	; L
	and #$40
	jsr tiny_button

	add_word ptr2, OFFSET_X
	lda buttons
	and #$20
	jsr small_button

	add_word ptr2, OFFSET_R
	lda buttons
	and #$80
	jsr tiny_button

	add_word ptr2, OFFSET_DPAD
	lda buttons
	and #$0f
	jsr dpad

	subtract_word ptr2, OFFSET_Y
	lda buttons + 1
	and #$20
	jsr small_button

	add_word ptr2, OFFSET_B
	lda buttons + 1
	and #$10
	jsr small_button

	add_word ptr2, OFFSET_A
	lda buttons
	and #$10
	jsr small_button

	add_word ptr2, OFFSET_SELECT
	lda buttons + 1
	and #$40
	jsr tiny_button

	add_word ptr2, OFFSET_START
	lda buttons + 1
	and #$80
	jmp tiny_button
