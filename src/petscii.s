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

PETSCII_OFFSET_L = 5
PETSCII_OFFSET_X = 15
PETSCII_OFFSET_R = 5
PETSCII_OFFSET_DPAD = 17 ; negative
PETSCII_OFFSET_Y = 40 * 3 - 7 ; negative
PETSCII_OFFSET_A = 4
PETSCII_OFFSET_B = 40 * 1 - 2
PETSCII_OFFSET_SELECT = 40 - 7
PETSCII_OFFSET_START = 3

PETSCII_MOUSE_L_OFFSET = 16
PETSCII_MOUSE_R_OFFSET = 3
PETSCII_MOUSE_X_OFFSET = 40 * 3 - 1
PETSCII_MOUSE_Y_OFFSET = 40

PETSCII_MOUSE_SPRITE_X_OFFSET = 138
PETSCII_MOUSE_SPRITE_Y_OFFSET = 172

.section reserved

petscii_data .reserve 4

.section code

.public handle_petscii {
    lda #$28
    sta CIA2_DDRB
    lda #$20
    sta CIA2_PRB
    lda #$00
    sta CIA2_PRB
    ldx #0
byte_loop:
    ldy #7
loop:
    clc
    lda CIA2_PRB
    and #$40
    bne :+
    sec
:   rol petscii_data,x
    lda #$08
    sta CIA2_PRB
    lda #0
    sta CIA2_PRB
    dey
    bpl loop
    inx
    cpx #4
    bne byte_loop

    lda petscii_data + 1
    and #$07
    bne detected
    lda petscii_data + 2
    bne detected
    lda #USER_VIEW_NONE
    jmp change_userport_view

detected:
    cmp #$01
    bne pad
    lda #USER_VIEW_SNES_MOUSE
    jsr change_userport_view
    jmp display_petscii_mouse

pad:
    lda #USER_VIEW_SNES
    jsr change_userport_view
    ; 0,  1,    2,    3,      4, 5, 6,   7
    ; 01  02    04    08      10 20 40   80
    ; right, left, down, up,  start, select, Y, B
    ;                         R, L, X, A

    ; L
    store_word ptr2, USERPORT_VIEW_START + PETSCII_OFFSET_L
    lda petscii_data + 1
    and #$20
    jsr tiny_button

    add_word ptr2, PETSCII_OFFSET_X
    lda petscii_data + 1
    and #$40
    jsr small_button

    add_word ptr2, PETSCII_OFFSET_R
    lda petscii_data + 1
    and #$10
    jsr tiny_button

    subtract_word ptr2, PETSCII_OFFSET_DPAD
    lda petscii_data
    and #$0f
    tax
    lda dpad_mirror,x
    jsr dpad

    subtract_word ptr2, PETSCII_OFFSET_Y
    lda petscii_data
    and #$40
    jsr small_button

    add_word ptr2, PETSCII_OFFSET_A
    lda petscii_data + 1
    and #$80
    jsr small_button

    add_word ptr2, PETSCII_OFFSET_B
    lda petscii_data
    and #$80
    jsr small_button

    ldx #0
    lda petscii_data + 1 ; X
    and #$40
    beq :+
    inx
:   lda petscii_data ; B
    and #$80
    beq :+
    inx
    inx
:   ldy #1
    lda    xb_overlap,x
    sta (ptr2),y

    add_word ptr2, PETSCII_OFFSET_SELECT
    lda petscii_data
    and #$20
    jsr tiny_button

    add_word ptr2, PETSCII_OFFSET_START
    lda petscii_data
    and #$10
    jsr tiny_button

    rts
}

display_petscii_mouse {
    lda petscii_data + 3
    bmi minus_x
    clc
    adc snes_x
    bcc:+
    lda #$ff
:   sta snes_x
    jmp compute_y
minus_x:
    and #$7f
    sta tmp
    lda snes_x
    sec
    sbc tmp
    bcs :+
    lda #$00
:   sta snes_x

compute_y:
    lda petscii_data + 2
    bmi minus_y
    clc
    adc snes_y
    bcc:+
    lda #$ff
:   sta snes_y
    jmp display
minus_y:
    and #$7f
    sta tmp
    lda snes_y
    sec
    sbc tmp
    bcs :+
    lda #$00
:   sta snes_y

display:
    lda #sprite_cross
    sta lower_sprite_ptr
    lda snes_x
    and #$1f
    clc
    adc #PETSCII_MOUSE_SPRITE_X_OFFSET
    sta lower_sprite_x
    lda snes_y
    and #$1f
    clc
    adc #PETSCII_MOUSE_SPRITE_Y_OFFSET
    sta lower_sprite_y

    store_word ptr2, USERPORT_VIEW_START + PETSCII_MOUSE_L_OFFSET
    lda petscii_data + 1
    and #$40
    jsr small_button
    add_word ptr2, PETSCII_MOUSE_R_OFFSET
    lda petscii_data + 1
    and #$80
    jsr small_button
    add_word ptr2, PETSCII_MOUSE_X_OFFSET
    lda snes_x
    and #$1f
    ldy #0
    ldx #0
    jsr pot_number
    add_word ptr2, PETSCII_MOUSE_Y_OFFSET
    lda snes_y
    and #$1f
    ldy #0
    ldx #0
    jmp pot_number
}

.section data
