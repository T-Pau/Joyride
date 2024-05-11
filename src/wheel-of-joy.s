;  wheel-of-joy.s -- Support for SukkoPera's Wheel of Joy Addapters
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

WHEEL_OF_JOY_MINI_DPAD_OFFSET = 40 * 2 + 3

.section code

.public wheel_of_joy_top {
    lda #$e0
    sta CIA2_DDRB
    ldy #7
loop:
    lda wheel_of_joy_select,y
    sta CIA2_PRB
    lda CIA2_PRB
    and #$1f
    eor #$1f
    sta snes_buttons,y
    dey
    bpl loop
    rts
}

.public wheel_of_joy_mini_top {
    lda #$c0
    sta CIA2_DDRB
    ldy #3
loop:
    lda wheel_of_joy_mini_select,y
    sta CIA2_PRB
    lda CIA2_PRB
    and #$3f
    eor #$3f
    sta snes_buttons,y
    dey
    bpl loop
    rts
}

.public wheel_of_joy_mini_bottom {
    lda command
    beq :+
    rts
:
    ldx #0

loop:
    stx index
    cpx #4
    beq end
    txa

    asl
    tay
    lda wheel_of_joy_mini_display_start,y
    sta ptr2
    lda wheel_of_joy_mini_display_start + 1,y
    sta ptr2 + 1

    lda snes_buttons,x
    and #$f
    jsr dpad

    subtract_word ptr2, BUTTON_OFFSET
    ldx index
    lda snes_buttons,x
    and #$10
    jsr button
    lda snes_buttons,x
    and #$20
    jsr button
    inx
    jmp loop

end:
    rts
}

.section data

wheel_of_joy_select {
    .repeat i, 8 {
        .data (i << 5) | $1f
    }
}

wheel_of_joy_mini_select {
    .repeat i, 4 {
        .data (i << 6) | $3f
    }
}

wheel_of_joy_mini_display_start {
    .data screen + EIGHT_PLAYER_OFFSET_FIRST + WHEEL_OF_JOY_MINI_DPAD_OFFSET
    .data screen + EIGHT_PLAYER_OFFSET_SECOND + WHEEL_OF_JOY_MINI_DPAD_OFFSET
    .data screen + EIGHT_PLAYER_OFFSET_THIRD + WHEEL_OF_JOY_MINI_DPAD_OFFSET
    .data screen + EIGHT_PLAYER_OFFSET_FOURTH + WHEEL_OF_JOY_MINI_DPAD_OFFSET
}
