;  display-mouse.s -- Display state of mouse.
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

buttons_offset = 10
wheel_offset = 2
position_offset = 40 + 6 ; negative

sprite_x_offset = 2
sprite_y_offset = 50 + 18

.section reserved

tmp .reserve 1

.section code

.public display_mouse {
    lda port_digital
    and #$03
    asl
    sta tmp
    lda port_digital
    and #$10
    lsr
    ora tmp
    tay
    lda button_rects,y
    sta ptr1
    lda button_rects + 1,y
    sta ptr1 + 1
    add_word ptr2, buttons_offset
    ldx #7
    ldy #3
    jsr copyrect

    add_word ptr2, wheel_offset
    lda port_digital
    and #$0c
    lsr
    tay
    lda wheel_rects,y
    sta ptr1
    lda wheel_rects + 1,y
    sta ptr1 + 1
    ldx #3
    ldy #4
    jsr copyrect

    subtract_word ptr2, position_offset
    lda port_pot1
    cmp #$7f
    bne :+
    lda #$80
:    lsr
    and #$3f
    sta sprite_x
    ldx #0
    ldy #0
    jsr pot_number

    add_word ptr2, 40
    lda port_pot2
    cmp #$7f
    bne :+
    lda #$80
:    lsr
    and #$3f
    eor #$3f
    sta sprite_y
    ldy #0
    ldx #0
    jsr pot_number

    ldx port_number
    clc
    lda sprite_x
    adc #sprite_x_offset
    adc port_x_offset,x
    sta sprite_x
    lda #0
    adc #0
    sta sprite_x + 1

    lda sprite_y
    adc #sprite_y_offset
    sta sprite_y

    txa
    asl
    jsr set_sprite

    rts
}

.section data

button_rects {
    .repeat 8, i {
        .data buttons_data + i * 21
    }
}

wheel_rects {
    .repeat 8, i {
        .data wheel_data + i * 12
    }
}

buttons_data {
    .binary_file "mouse-buttons.bin"
}

wheel_data {
    .binary_file "scroll-wheel.bin"
}
