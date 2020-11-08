;  snespad.s -- Support routines for Ninja SNES PAD
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

.export snespad_read

.include "c64.inc"

.autoimport +

.code

snespad_read:
	; port b 3 & 4 as output, rest as input
	lda #$00
	sta CIA1_DDRA
	lda #$18
	sta CIA1_DDRB

	; pulse latch
	lda #$f7
	sta CIA1_PRB
	lda #$e7
	sta CIA1_PRB

	ldy #12

bits:
	lda CIA1_PRB
	eor #$07
;	lda #$A5; DEBUG
	ldx #0
pad1:
	lsr
	ror snes_buttons,x
	ror snes_buttons + 1,x
	inx
	inx
	cpx #6
	bne pad1
	lda CIA1_PRA
	eor #$1f
pad2:
	lsr
	ror snes_buttons,x
	ror snes_buttons + 1,x
	inx
	inx
	cpx #16
	bne pad2
	; pulse clock
	lda #$ef
	sta CIA1_PRB
	lda #$e7
	sta CIA1_PRB
	dey
	bne bits

	; latch again to reset input lines
	lda #$f7
	sta CIA1_PRB
	lda #$e7
	sta CIA1_PRB
	rts
