;  display-protopad.s -- Display Protopad controller.
;  Copyright (C) Dieter Baron
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
;  THIS SOFTWARE IS PROVIDED BY THE AUTHORS "AS IS" AND ANY EXPRESS
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

.section reserved

protopad_pad .reserve 2

.macro protopad_delay {
    nop
    nop
    nop
}

.section code

.public display_protopad {
    stx port
    dex
    beq :+
    ldx #1
:
    lda #$00
    sta protopad_pad
    sta protopad_pad + 1

    lda #$00
    sta CIA1_PRA,x
    lda #%00011111
    sta CIA1_DDRA,x
    protopad_delay

    lda #%00011000
    sta CIA1_DDRA,x
    protopad_delay
    lda CIA1_PRA,x
    and #$07
    beq :+
    jmp not_connected
:

    lda #%00001000
    sta CIA1_PRA,x
    protopad_delay
    lda CIA1_PRA,x
    and #$07
    eor #$07
    asl
    tay
    lda translate_1,y
    sta protopad_pad
    lda translate_1 + 1,y
    sta protopad_pad + 1

    lda #%0000000
    sta CIA1_PRA,x
    protopad_delay
    lda CIA1_PRA,x
    and #$07
    eor #$07
    tay
    lda translate_2,y
    ora protopad_pad
    sta protopad_pad

    lda #%00001000
    sta CIA1_PRA,x
    protopad_delay
    lda CIA1_PRA,x
    and #$07
    eor #$07
    asl
    tay
    lda translate_3,y
    ora protopad_pad
    sta protopad_pad
    lda translate_3 + 1,y
    ora protopad_pad + 1
    sta protopad_pad + 1

    lda #%00000000
    sta CIA1_PRA,x
    protopad_delay
    lda CIA1_PRA,x
    and #$07
    eor #$07
    asl
    tay
    lda translate_4,y
    ora protopad_pad
    sta protopad_pad
    lda translate_4 + 1,y
    ora protopad_pad + 1
    sta protopad_pad + 1

    lda #0
    sta CIA1_DDRA,x

    ldy port
    lda #CONTROLLER_VIEW_SNES
    jsr change_port_view

    clc
    lda ptr2
    adc #41
    sta ptr2
    bcc :+
    inc ptr2 + 1
:
    lda protopad_pad
    ldx protopad_pad + 1
    ldy #1
    jmp display_snes

not_connected:
    ldy port
    lda #CONTROLLER_VIEW_NONE
    jmp change_port_view
}

.section data

    ; Protopad
    ; BA→ ←↓↑
    ; TER LYX

    ; SNES
    ; BYET↑↓←→
    ; AXLR....

translate_1 {
    .data $00, $00  ; ...
    .data $01, $00  ; ..→
    .data $00, $80  ; .A.
    .data $01, $80  ; .A→
    .data $80, $00  ; B..
    .data $81, $00  ; B.→
    .data $80, $80  ; BA.
    .data $81, $80  ; BA→
}

translate_2 {
    .data $00  ; ...
    .data $08  ; ..↑
    .data $04  ; .↓.
    .data $0C  ; .↓↑
    .data $02  ; ←..
    .data $0a  ; ←.↑
    .data $06  ; ←↓.
    .data $0e  ; ←↓↑
}

translate_3 {
    .data $00, $00  ; ...
    .data $00, $10  ; ..R
    .data $20, $00  ; .E.
    .data $20, $10  ; .ER
    .data $10, $00  ; T..
    .data $10, $10  ; T.R
    .data $30, $00  ; TE.
    .data $30, $10  ; TER
}

translate_4 {
    .data $00, $00  ; ...
    .data $00, $40  ; ..X
    .data $40, $00  ; .Y.
    .data $40, $40  ; .YX
    .data $00, $20  ; L..
    .data $00, $60  ; L.X
    .data $40, $20  ; LY.
    .data $40, $60  ; LYX
}