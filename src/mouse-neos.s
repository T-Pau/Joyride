;  neos.s -- Support for NEOS Mouse
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

NEOS_L_OFFSET = 40 + 11
NEOS_R_OFFSET = 40 + 14
NEOS_X_OFFSET = 6 * 40 + 13
NEOS_Y_OFFSET = NEOS_X_OFFSET + 40

NEOS_SPRITE_X_OFFSET = 122
NEOS_SPRITE_Y_OFFSET = 88

.section code

read_neos {
    lda #$ff
    sta CIA1_PRB
    lda #0
    sta CIA1_DDRB
    jsr extra_read_pots
    and #$80
    sta neos_button_r
    lda CIA1_PRB
    eor #$ff
    and #$10
    sta neos_button_l
    bne end

    ldy #0
:   lda #$10
    sta CIA1_DDRB
    lda #$ef
    sta CIA1_PRB
    lda CIA1_PRB
    asl
    asl
    asl
    asl
    sta neos_diff,y
    lda #$ff
    sta CIA1_PRB
    lda CIA1_PRB
    and #$0f
    ora neos_diff,y
    sta neos_diff,y
    iny 
    cpy #2
    bne :-

    lda #0
    sta CIA1_DDRB

    ldy #1
:   sec
    lda neos_position,y
    sbc neos_diff,y
    sta neos_position,y
    dey
    bpl :-

end:
    rts
}

display_neos {
    store_word destination_ptr, EXTRA_VIEW_START + NEOS_L_OFFSET
    lda neos_button_l
    jsr small_button
    store_word destination_ptr, EXTRA_VIEW_START + NEOS_R_OFFSET
    lda neos_button_r
    jsr small_button

    store_word destination_ptr, EXTRA_VIEW_START + NEOS_X_OFFSET
    lda neos_position
    ldx #1
    ldy #0
    jsr pot_number
    store_word destination_ptr, EXTRA_VIEW_START + NEOS_Y_OFFSET
    lda neos_position + 1
    ldx #1
    ldy #0
    jsr pot_number

    lda neos_position
    lsr
    lsr
    clc
    adc #NEOS_SPRITE_X_OFFSET
    sta VIC_SPRITE_0_X
    lda neos_position + 1
    lsr
    lsr
    clc
    adc #NEOS_SPRITE_Y_OFFSET
    sta VIC_SPRITE_0_Y
    rts
}

.section reserved

neos_diff .reserve 2
neos_position .reserve 2
neos_button_l .reserve 1
neos_button_r .reserve 1
