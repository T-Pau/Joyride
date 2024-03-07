;  userport.s -- Display state of user port adapter.
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

userport_name_address = screen + 13 * 40 + 15

.section reserved

temp .reserve 2

.section data

read_routines {
    .data handle_protovision
    .data handle_hitmen
    .data handle_kingsoft
    .data handle_starbyte
    .data handle_pet_dual
    .data handle_petscii
}

userport_views {
    .data USER_VIEW_JOYSTICK
    .data USER_VIEW_JOYSTICK
    .data USER_VIEW_JOYSTICK
    .data USER_VIEW_JOYSTICK
    .data USER_VIEW_JOYSTICK
    .data USER_VIEW_SNES
}

userport_names {
    .repeat USER_NUM_TYPES, i {
        .data userport_name_strings + 20 * i
    }
}

userport_name_strings {
    .data "protovision / cga   ":screen_inverted
    .data "digital xs / hitmen ":screen_inverted
    .data "kingsoft            ":screen_inverted
    .data "starbyte            ":screen_inverted
    .data "pet dual joystick   ":screen_inverted
    .data "petscii robots      ":screen_inverted
}

userport_view {
    .repeat USER_NUM_VIEWS, i {
        .data userport_view_data + i * 31 * 5
    }
}

userport_view_data {
    .binary_file "userport-screens.bin"
}

.section code

; display name for userport type A

.public copy_userport {
    lda userport_type
    asl
    tax

    lda #<userport_name_address
    sta ptr2
    lda #>userport_name_address
    sta ptr2 + 1

    lda userport_names,x
    sta ptr1
    lda userport_names + 1,x
    sta ptr1 + 1

    ldy #19
loop:
    lda (ptr1),y
    sta (ptr2),y
    dey
    bpl loop

    ldx userport_type
    lda userport_views,x
    asl
    tax
    lda userport_view,x
    sta ptr1
    lda userport_view + 1,x
    sta ptr1 + 1
    store_word USERPORT_VIEW_START, ptr2
    ldx #31
    ldy #5
    jsr copyrect
    rts
}

.public handle_userport {
    jsr content_background
    lda command
    beq :+
    rts
:    lda userport_type
    asl
    tay
    lda read_routines,y
    sta jump + 1
    lda read_routines + 1,y
    sta jump + 2
jump:
    jmp $0000
}

display_userport_joysticks {
    ldx #2
    jsr display_joystick
    lda port_digital + 1
    sta port_digital
    ldx #3
    jsr display_joystick
    rts
}

handle_protovision {
    lda #$80
    sta CIA2_DDRB

    ; select joystick 3
    lda CIA2_PRB
    ora #$80
    sta CIA2_PRB

    lda CIA2_PRB
    eor #$ff
    and #$1f
    sta port_digital

    ; select joystick 4
    lda CIA2_PRB
    and #$7f
    sta CIA2_PRB

    lda CIA2_PRB
    eor #$ff
    and #$2f
    cmp #$20
    bcc :+
    ora #$10
:   and #$1f
    sta port_digital + 1
    jmp display_userport_joysticks
}

read_hitmen {
    ; read directions
    lda #$00
    sta CIA2_DDRB
    lda CIA2_PRB
    eor #$ff
    sta port_digital + 1
    and #$0f
    sta port_digital
    lda port_digital + 1
    lsr
    lsr
    lsr
    lsr
    sta port_digital + 1

    ; read port 3 fire
    lda CIA2_DDRA
    and #%11111011
    sta CIA2_DDRA
    lda CIA2_PRA
    and #%00000100
    bne :+
    lda port_digital
    ora #$10
    sta port_digital
:
    ; read port 4 fire
    lda #$ff
    sta CIA1_SERIAL_DATA
    lda CIA2_SERIAL_DATA
    cmp #$ff
    beq :+
    lda port_digital + 1
    ora #$10
    sta port_digital + 1
:
    rts
}

handle_hitmen {
    jsr read_hitmen
    jmp display_userport_joysticks
}

.section data

kingsoft_low {
    ;      00   01   02   03   04   05   06   07   08   09   0a   0b   0c   0d   0e   0f
    .data $00, $08, $04, $0c, $02, $0a, $06, $0e, $01, $09, $05, $0d, $03, $0b, $07, $0f
}

kingsoft_high {
    ; TODO
    ;      00   01   02   03   04   05   06   07   08   09   0a   0b   0c   0d   0e   0f
    .data $00, $10, $08, $18, $04, $14, $0c, $1c, $02, $12, $0a, $1a, $06, $16, $0e, $1e
}

starbyte_low {
    ;      00   01   02   03   04   05   06   07   08   09   0a   0b   0c   0d   0e   0f
    .data $00, $02, $08, $0a, $04, $06, $0c, $0d, $01, $03, $09, $0b, $05, $07, $0e, $0f
}

starbyte_high {
    ; TODO
    ;      00   01   02   03   04   05   06   07   08   09   0a   0b   0c   0d   0e   0f
    .data $00, $10, $02, $12, $08, $18, $0a, $1a, $04, $14, $06, $16, $0c, $1c, $0e, $1e
}

.section code

handle_kingsoft {
    jsr read_hitmen

    lda port_digital
    and #$0f
    tax
    lda kingsoft_low,x
    sta temp + 1

    lda port_digital + 1
    and #$0f
    tax
    lda kingsoft_high,x
    sta temp

    lda port_digital
    and #$10
    beq :+
    lda temp
    ora #$01
    sta temp
:
    lda port_digital + 1
    and #$10
    beq :+
    lda temp + 1
    ora #$10
    sta temp + 1
:
    lda temp
    sta port_digital
    lda temp + 1
    sta port_digital + 1
    jmp display_userport_joysticks
}

handle_starbyte {
    jsr read_hitmen

    lda port_digital
    and #$0f
    tax
    lda starbyte_low,x
    sta temp

    lda port_digital + 1
    and #$0f
    tax
    lda starbyte_high,x
    sta temp + 1

    lda port_digital
    and #$10
    beq :+
    lda temp + 1
    ora #$01
    sta temp + 1
:
    lda port_digital + 1
    and #$10
    beq :+
    lda temp
    ora #$10
    sta temp
:
    lda temp
    sta port_digital
    lda temp + 1
    sta port_digital + 1
    jmp display_userport_joysticks
}

handle_pet_dual {
    lda #$00
    sta CIA2_DDRB
    lda CIA2_PRB
    eor #$ff
    tax
    ldy #0
    and #$0f
    jsr translate_pet_dual
    txa
    lsr
    lsr
    lsr
    lsr
    iny
    jsr translate_pet_dual
    jmp display_userport_joysticks
}

translate_pet_dual {
    sta port_digital,y
    and #$03
    cmp #$03
    bne :+
    lda #$13
    eor port_digital,y
    sta port_digital,y
:   rts
}