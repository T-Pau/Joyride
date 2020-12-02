;  display-trapthem.s -- Display Trap Them controller.
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

.export display_trapthem

.include "joyride.inc"
.macpack utility

.bss

pad:
	.res 2

.code

display_trapthem:
	dex
	beq :+
	ldx #1
:
    lda #$18
    sta CIA1_DDRA,x
    lda #$10
    sta CIA1_PRA,x
    lda #$00
    sta CIA1_PRA,x

	lda #<pad
	sta rotate + 1
	ldy #12
loop:
    lda CIA1_PRA,x
    ror
    ror
    ror
rotate:
    rol pad

    lda #$08
    sta CIA1_PRA,x
    lda #$00
    sta CIA1_PRA,x

	dey
	cpy #4
	bne :+
	inc rotate + 1
:	cpy #0
	bne loop

	lda #$10
	sta CIA1_PRA,x
	lda #0
	sta CIA1_PRA,x

	lda pad + 1
	asl
	asl
	asl
	asl
	sta pad + 1

	clc
	lda ptr2
	adc #41
	sta ptr2
	bcc :+
	inc ptr2 + 1
:
	lda pad + 1
	eor #$ff
	tax
	lda pad
	eor #$ff
	ldy #1
	jsr display_snes

	rts
