;  petscii.s -- Support for PETSCII Robots adapter.
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

PETSCII_OFFSET_X = 15
PETSCII_OFFSET_R = 5
PETSCII_OFFSET_DPAD = 18 ; negative
PETSCII_OFFSET_Y = 40 * 4 - 11 ; negative
PETSCII_OFFSET_A = 4
PETSCII_OFFSET_B = 40 * 1 - 2
PETSCII_OFFSET_SELECT = 40 - 7
PETSCII_OFFSET_START = 3

.section code

.public handle_petscii {
    lda #$28
    sta CIA2_DDRB
    lda #$20
    sta CIA2_PRB
    lda #$00
    sta CIA2_PRB
    ldx #0
    ldy #7
loop:
    clc
    lda CIA2_PRB
    and #$40
    bne :+
    sec
:    rol port_digital,x
    lda #$08
    sta CIA2_PRB
    lda #0
    sta CIA2_PRB
    dey
    bpl loop
    ldy #3
    inx
    cpx #2
    bne loop

    ; 0,  1,    2,    3,      4, 5, 6,   7
    ; 01  02    04    08      10 20 40   80
    ; right, left, down, up,  start, select, Y, B
    ;                         R, L, X, A

    ; L
    store_word USERPORT_VIEW_START + 5, ptr2
    lda port_digital + 1
    and #$20
    jsr tiny_button

    add_word ptr2, PETSCII_OFFSET_X
    lda port_digital + 1
    and #$40
    jsr small_button

    add_word ptr2, PETSCII_OFFSET_R
    lda port_digital + 1
    and #$10
    jsr tiny_button

    subtract_word ptr2, PETSCII_OFFSET_DPAD
    lda port_digital
    and #$0f
    tax
    lda dpad_mirror,x
    jsr dpad

    subtract_word ptr2, PETSCII_OFFSET_Y
    lda port_digital
    and #$40
    jsr small_button

    add_word ptr2, PETSCII_OFFSET_A
    lda port_digital + 1
    and #$80
    jsr small_button

    add_word ptr2, PETSCII_OFFSET_B
    lda port_digital
    and #$80
    jsr small_button

    ldx #0
    lda port_digital + 1 ; X
    and #$40
    beq :+
    inx
:    lda port_digital ; B
    and #$80
    beq :+
    inx
    inx
:    ldy #1
    lda    xb_overlap,x
    sta (ptr2),y

    add_word ptr2, PETSCII_OFFSET_SELECT
    lda port_digital
    and #$20
    jsr tiny_button

    add_word ptr2, PETSCII_OFFSET_START
    lda port_digital
    and #$10
    jsr tiny_button

    rts
}

.section data

xb_overlap {
    .data $fd, $fe, $ff, $f5
}