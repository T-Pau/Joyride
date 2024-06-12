;  snes.s -- Display SNES controller.
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

SNES_OFFSET_X = 9
SNES_OFFSET_R = 4
SNES_OFFSET_DPAD = 40 - 13
SNES_OFFSET_Y = 40 * 4- 5 ; negative
SNES_OFFSET_A = 4
SNES_OFFSET_B = 40 * 2- 2
SNES_OFFSET_SELECT = 40 * 2 - 5
SNES_OFFSET_START = 3
SNES_OFFSET_L_FIX = 40 * 5 + 6 ; negative

.section reserved

buttons .reserve 2
    ; 0,  1,    2,    3,      4, 5, 6,   7
    ; 01  02    04    08      10 20 40   80
    ; right, left, down, up,  start, select, Y, B
    ;                         R, L, X, A

compact .reserve 1

.section data

.public dpad_mirror {
    ;      0   1   2   3   4   5   6   7   8   9   a   b   c   d   e   f
    .data $0, $8, $4, $c, $2, $a, $6, $e, $1, $9, $5, $d, $3, $b, $7, $f
}

.section code

.public display_snes {
    sty compact
    sta buttons
    stx buttons + 1

    ; L
    txa
    and #$20
    jsr tiny_button

    clc
    ldy compact
    bne :+
    sec
:   lda ptr2
    adc #SNES_OFFSET_X
    sta ptr2
    bcc :+
    inc ptr2 + 1
:   lda buttons + 1
    and #$40
    jsr small_button

    add_word ptr2, SNES_OFFSET_R
    lda buttons + 1
    and #$10
    jsr tiny_button

    add_word ptr2, SNES_OFFSET_DPAD
    lda buttons
    and #$0f
    tax
    lda dpad_mirror,x
    jsr dpad

    subtract_word ptr2, SNES_OFFSET_Y
    lda buttons
    and #$40
    jsr small_button

    add_word ptr2, SNES_OFFSET_A
    lda buttons + 1
    and #$80
    jsr small_button

    add_word ptr2, SNES_OFFSET_B
    lda buttons
    and #$80
    jsr small_button

    add_word ptr2, SNES_OFFSET_SELECT
    lda buttons
    and #$20
    jsr tiny_button

    add_word ptr2, SNES_OFFSET_START
    lda buttons
    and #$10
    jsr tiny_button

    lda compact
    beq end
    subtract_word ptr2, SNES_OFFSET_L_FIX
    ldy #0
    lda #$ec
    sta (ptr2),y

end:
    rts
}
