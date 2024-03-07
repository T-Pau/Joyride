;  display-raw.s -- Display raw data for controller port.
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

raw_bit0_position = 1
raw_pot1_offset = 40 * 7 - 11
raw_pot2_offset = 9
raw_pen_x_offset = 40 - 9
raw_pen_y_offset = raw_pot2_offset

sprite_x_offset = 4
sprite0_y_offset = 50 + 20 + 3 * 8
sprite1_y_offset = sprite0_y_offset + 16

.section code

.public display_raw {
    add_word ptr2, raw_bit0_position

    lda port_digital
    and #$01
    jsr button

    lda port_digital
    and #$02
    jsr button

    lda port_digital
    and #$04
    jsr button

    lda port_digital
    and #$08
    jsr button

    lda port_digital
    and #$10
    jsr button

    add_word ptr2, raw_pot1_offset
    lda port_pot1
    ldy #0
    ldx #1
    jsr pot_number

    add_word ptr2, raw_pot2_offset
    lda port_pot2
    ldy #0
    ldx #1
    jsr pot_number

    lda port_number
    bne :+
    add_word ptr2, raw_pen_x_offset
    lda pen_x
    ldy #0
    ldx #1
    jsr pot_number
    add_word ptr2, raw_pen_y_offset
    lda pen_y
    ldy pen_y + 1
    ldx #1
    jsr pot_number

:    ldx port_number
    lda port_pot1
    lsr
    clc
    adc #sprite_x_offset
    adc port_x_offset,x
    sta sprite_x
    lda #0
    adc #0
    sta sprite_x + 1
    lda #sprite0_y_offset
    sta sprite_y
    txa
    asl
    jsr set_sprite

    ldx port_number
    lda port_pot2
    lsr
    clc
    adc #sprite_x_offset
    adc port_x_offset,x
    sta sprite_x
    lda #0
    adc #0
    sta sprite_x + 1
    lda #sprite1_y_offset
    sta sprite_y
    txa
    asl
    clc
    adc #1
    jsr set_sprite

    rts
}