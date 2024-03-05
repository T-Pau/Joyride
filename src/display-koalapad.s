;  display-koalapad.s -- Display state of Koalapad.
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

buttons_offset = 40 + 11
position_offset = 5 * 40 - 3

sprite_x_offset = 2
sprite_y_offset = 50 + 18

.section code

.public display_koalapad {
    add_word ptr2, buttons_offset

    lda port_digital
    and #$04
    jsr button

    lda port_digital
    and #$08
    jsr button

    add_word ptr2, position_offset

    lda port_pot1
    ldy #0
    ldx #1
    jsr pot_number

    add_word ptr2, 40

    lda port_pot2
    ldy #0
    ldx #1
    jsr pot_number

    ldx port_number

    lda port_pot2
    lsr
    lsr
    clc
    adc #sprite_y_offset
    sta sprite_y

    lda port_pot1
    lsr
    lsr
    clc
    adc #sprite_x_offset
    adc port_x_offset,x
    sta sprite_x
    lda #0
    adc #0
    sta sprite_x + 1

    txa
    asl
    jsr set_sprite

    rts
}
