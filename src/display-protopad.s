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

.export display_protopad

.include "joyride.inc"
.macpack utility

.bss

pad:
	.res 2

.code

display_protopad:
	dex
	beq :+
	ldx #1
:
    lda #$00
    sta pad
    sta pad + 1

ldx #%00000000
ldy #%00001000

    lda #$00
    sta CIA1_PRA,x
    lda #$ff
    sta CIA1_DDRA,x

    lda #$f8
    sta CIA1_DDRA,x
    lda CIA1_PRA,x
    bne not_connected

    lda #$08
    sta CIA1_PRA,x
    lda CIA1_PRA,x
    eor #$07
    and #$07
    asl
    tay
    lda translate_1,y
    sta pad
    lda translate_1 + 1,y
    sta pad + 1

    lda #0
    sta CIA1_PRA,x
    lda CIA1_PRA,x
    eor #$07
    and #$07
    tay
    lda translate_2,y
    ora pad
    sta pad

    lda #$08
    sta CIA1_PRA,x
    lda CIA1_PRA,x
    eor #$07
    and #$07
    asl
    tay
    lda translate_3,y
    ora pad
    sta pad
    lda translate_3 + 1,y
    ora pad + 1
    sta pad + 1

    lda #$00
    sta CIA1_PRA,x
    lda CIA1_PRA,x
    eor #$07
    and #07
    asl
    tay
    lda translate_4,y
    ora pad
    sta pad
    lda translate_4 + 1,y
    ora pad + 1
    sta pad + 1

    lda #0
    sta CIA1_DDRA,x

not_connected:
	clc
	lda ptr2
	adc #41
	sta ptr2
	bcc :+
	inc ptr2 + 1
:
	lda pad
    ldx pad + 1
	ldy #1
	jmp display_snes

.rodata

    ; Protopad
    ; BA→ ←↓↑
    ; TER LYX

    ; SNES
    ; BYET↑↓←→
    ; AXLR....

translate_1:
    .byte $00, $00  ; ...
    .byte $01, $00  ; ..→
    .byte $00, $80  ; .A.
    .byte $01, $80  ; .A→
    .byte $80, $00  ; B..
    .byte $81, $00  ; B.→
    .byte $80, $80  ; BA.
    .byte $81, $80  ; BA→

translate_2:
    .byte $00  ; ...
    .byte $08  ; ..↑
    .byte $04  ; .↓.
    .byte $0C  ; .↓↑
    .byte $02  ; ←..
    .byte $0a  ; ←.↑
    .byte $06  ; ←↓.
    .byte $0e  ; ←↓↑

translate_3:
    .byte $00, $00  ; ...
    .byte $00, $10  ; ..R
    .byte $20, $00  ; .E.
    .byte $20, $10  ; .ER
    .byte $10, $00  ; T..
    .byte $10, $10  ; T.R
    .byte $30, $00  ; TE.
    .byte $30, $10  ; TER

translate_4:
    .byte $00, $00  ; ...
    .byte $00, $40  ; ..X
    .byte $40, $00  ; .Y.
    .byte $40, $40  ; .YX
    .byte $00, $20  ; L..
    .byte $00, $60  ; L.X
    .byte $40, $20  ; LY.
    .byte $40, $60  ; LYX
