;  display-paddle.s -- Display state of paddle.
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

paddle_button_offset = 40 + 7
paddle_value_offset = 5 * 40

paddle_sprite_x_offset = 4
paddle_sprite_y_offset = 50 + 20 + 4 * 8

.section reserved

paddle .reserve 1

.section code

.public display_paddle1 {
    lda #0
    sta paddle
    jmp display_paddle
}

.public display_paddle2 {
    lda #1
    sta paddle
    jmp display_paddle
}

display_paddle {
    add_word ptr2, paddle_button_offset
    lda port_digital
    lsr
    lsr
    and #$03
    ldx paddle
    beq :+
    lsr
:   and #1
    jsr button

    add_word ptr2, paddle_value_offset
    lda port_pot1
    ldx paddle
    beq :+
    lda port_pot2
:   sta sprite_x
    ldy #0
    ldx #1
    jsr pot_number

    ldx port_number
    lda #$ff
    sec
    sbc sprite_x
    lsr
    clc
    adc #paddle_sprite_x_offset
    adc port_x_offset,x
    sta sprite_x
    lda #0
    adc #0
    sta sprite_x + 1

    lda #paddle_sprite_y_offset
    sta sprite_y

    txa
    asl
    jsr set_sprite
    rts
}