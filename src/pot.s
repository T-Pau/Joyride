;  pot.s -- Display number for analog potentiometer.
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


; display number Y/A at ptr2, only two digits if X is 0

.autoimport +

.export pot_number

.include "joyride.inc"

.bss

bit0:
	.res 1

bit9:
	.res 1

halfed:
	.res 1

hundred:
	.res 1

.rodata

digits_ten:
	.repeat 50, i
	.byte (i / 5) .MOD 10 + $30
	.endrep

digits_one:
	.repeat 50, i
	.byte (i * 2) .MOD 10 + $30
	.endrep

.code

pot_number:
	sty bit9
	ldy #0
	sty bit0
	sty hundred
	lsr
	rol bit0
	ldy bit9
	beq :+
	ora #$80
:

	ldy #0
	cpx #0
	beq digit2
	ldx #0
:	cmp #50
	bcc found
	sec
	sbc #50
	inx
	bne :-
found:
	stx hundred
	sta halfed
	txa
	bne digit3
	lda #$20
	bne display_digit3
digit3:
	ora #$30
display_digit3:
	sta (ptr2),y
	iny
	lda halfed
digit2:
	tax
	lda digits_ten,x
	cmp #$30
	bne :+
	dec hundred
	bpl :+
	lda #$20
:	sta (ptr2),y
	iny
	lda digits_one,x
	clc
	adc bit0
	sta (ptr2),y
	rts
