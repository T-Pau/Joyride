;  display-lightpen.s -- Display state of lightpen.
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

lightpen_buttons_offset = 12
lightpen_x_offset = 40 * 2 + 2
lightpen_y_offset = 40

lightpen_sprite_x_offset = 24 + 8
lightpen_sprite_y_offset = 50 + 14

.section code

.public lightpen_sprite_top {
    lda pen_y + 1
    beq top_sprite_on
    lda #sprite_none
    bne set_top_sprite
top_sprite_on:
    lda #sprite_lightpen
set_top_sprite:
    sta screen + $3f9
    rts
}

.public lightpen_sprite_bottom {
    lda pen_y + 1
    bne bottom_sprite_on
    lda pen_y
    bmi bottom_sprite_on
    lda #sprite_none
    bne set_bottom_sprite
bottom_sprite_on:
    lda #sprite_lightpen
set_bottom_sprite:
    sta screen + $3f9
    rts
}

.public display_lightpen {
    ldy #0
    lda port_digital
    and #$0f
    beq :+
    iny
    iny
:   lda port_digital
    and #$10
    beq :+
    iny
    iny
    iny
    iny
:   lda lightpen_button_rects,y
    sta ptr1
    lda lightpen_button_rects + 1,y
    sta ptr1 + 1
    add_word ptr2, lightpen_buttons_offset
    ldx #5
    ldy #3
    jsr copyrect

    add_word ptr2, lightpen_x_offset
    ldy #0
    lda pen_x
    asl
    bcc :+
    iny
:   ldx #1
    jsr pot_number

    add_word ptr2, lightpen_y_offset
    lda pen_y
    ldy pen_y + 1
    ldx #1
    jsr pot_number

    lda pen_x
    lsr
    cmp #91
    bcc :+
    lda #91
:   clc
    adc #lightpen_sprite_x_offset
    sta sprite_x
    lda #0
    sta sprite_x + 1
    lda pen_y + 1
    lsr
    lda pen_y
    ror
    lsr
    cmp #71
    bcc :+
    lda #71
:   clc
    adc #lightpen_sprite_y_offset
    sta sprite_y
    lda #0
    jsr set_sprite

    lda pen_y + 1
    beq position_cursor
    lda #0
    sta sprite_x
    sta sprite_x + 1
    sta sprite_y

position_cursor:
    ldy #0
    lda pen_x
    sec
    sbc #5
    asl
    sta sprite_x
    bcc :+
    iny
:   sty sprite_x + 1
    lda pen_y
    sec
    sbc #10
    sta sprite_y

show_cursor:
    lda #1
    jsr set_sprite

    rts
}


.section data

lightpen_button_rects {
    .repeat i, 8 {
        .data lightpen_buttons_data + i * 15
    }
}

lightpen_buttons_data {
    .binary_file "lightpen-buttons.bin"
}
