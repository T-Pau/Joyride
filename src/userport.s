;  userport.s -- Display state of user port adapter.
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
    .data handle_stupid_pet_tricks
    .data handle_vic20_oem
    .data handle_c64dtv_hummer
    .data handle_petscii
}

userport_default_views {
    .data USER_VIEW_TWO_JOYSTICKS
    .data USER_VIEW_TWO_JOYSTICKS
    .data USER_VIEW_TWO_JOYSTICKS
    .data USER_VIEW_TWO_JOYSTICKS
    .data USER_VIEW_TWO_JOYSTICKS
    .data USER_VIEW_ONE_JOYSTICK
    .data USER_VIEW_ONE_JOYSTICK
    .data USER_VIEW_ONE_JOYSTICK
    .data VIEW_DYNAMIC
}

userport_names {
    .repeat i, USER_NUM_TYPES {
        .data userport_name_strings + 20 * i
    }
}

userport_name_strings {
    .data "Protovision / CGA   ":screen_inverted
    .data "Digital XS / Hitmen ":screen_inverted
    .data "Kingsoft            ":screen_inverted
    .data "Starbyte            ":screen_inverted
    .data "PET Dual Joystick   ":screen_inverted
    .data "PET Space Invaders+ ":screen_inverted
    .data "VIC-20 OEM          ":screen_inverted
    .data "C64DTV Hummer       ":screen_inverted
    .data "PETSCII Robots      ":screen_inverted
}

userport_view {
    .repeat i, USER_NUM_VIEWS {
        .data userport_view_data + i * 31 * 5
    }
}

userport_view_data {
    .binary_file "userport-screens.bin"
}

.section code

userport_update_view = copy_userport_view

change_userport_view {
    cmp userport_current_view
    beq end
    sta userport_current_view
    lda #COMMAND_USERPORT_UPDATE_VIEW
    sta command
end:
    rts
}


.public copy_userport {
    ldx userport_type
    lda userport_default_views,x
    sta userport_current_view
    cmp #VIEW_DYNAMIC
    beq :+
    jsr copy_userport_view
:   jmp copy_userport_name
}

.public copy_userport_name {
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
    rts
}

.public copy_userport_view {
    lda #0
    sta lower_sprite_x
    sta lower_sprite_y
    lda userport_current_view
    asl
    tax
    lda userport_view,x
    sta ptr1
    lda userport_view + 1,x
    sta ptr1 + 1
    store_word ptr2, USERPORT_VIEW_START
    ldx #31
    ldy #5
    jmp copyrect
}

.public handle_userport {
    jsr content_background
    lda command
    beq :+
    rts
:   lda userport_type
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
    jmp display_joystick
}

display_userport_joystick {
    ldx #4
    jmp display_joystick
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

handle_stupid_pet_tricks {
    lda #$00
    sta CIA2_DDRB
    lda CIA2_PRB
    eor #$2f
    tax
    and #$20
    lsr
    sta port_digital
    txa
    and #$0f
    tax
    lda stupid_pet_tricks_dpad,x
    ora port_digital
    sta port_digital
    jmp display_userport_joystick
}

handle_vic20_oem {
    lda #$00
    sta CIA2_DDRB
    lda CIA2_PRB
    lsr
    lsr
    lsr
    eor #$1f
    tax
    lda vic20_oem,x
    sta port_digital
    jmp display_userport_joystick
}

handle_c64dtv_hummer {
    lda #$00
    sta CIA2_DDRB
    lda CIA2_PRB
    eor #$1f
    sta port_digital
    jmp display_userport_joystick
}

.section data

; PET Space Invaders+ : F-↓↑→←

stupid_pet_tricks_dpad {
    ;      →←↓↑ ; ↓↑→←
    .data %0000 ; ----
    .data %0100 ; ---←
    .data %1000 ; --→-
    .data %1100 ; --→←
    .data %0001 ; -↑--
    .data %0101 ; -↑-←
    .data %1001 ; -↑→-
    .data %1101 ; -↑→←
    .data %0010 ; ↓---
    .data %0110 ; ↓--←
    .data %1010 ; ↓-→-
    .data %1110 ; ↓-→←
    .data %0011 ; ↓↑--
    .data %0111 ; ↓↑-←
    .data %1011 ; ↓↑→-
    .data %1111 ; ↓↑→←
}

vic20_oem {
    ;      F→←↓↑ ; ↑↓←→F
    .data %00000 ; -----
    .data %10000 ; ----F
    .data %01000 ; ---→-
    .data %11000 ; ---→F
    .data %00100 ; --←--
    .data %10100 ; --←-F
    .data %01100 ; --←→-
    .data %11100 ; --←→F
    .data %00010 ; -↓---
    .data %10010 ; -↓--F
    .data %01010 ; -↓-→-
    .data %11010 ; -↓-→F
    .data %00110 ; -↓←--
    .data %10110 ; -↓←-F
    .data %01110 ; -↓←→-
    .data %11110 ; -↓←→F
    .data %00001 ; ↑----
    .data %10001 ; ↑---F
    .data %01001 ; ↑--→-
    .data %11001 ; ↑--→F
    .data %00101 ; ↑-←--
    .data %10101 ; ↑-←-F
    .data %01101 ; ↑-←→-
    .data %11101 ; ↑-←→F
    .data %00011 ; ↑↓---
    .data %10011 ; ↑↓--F
    .data %01011 ; ↑↓-→-
    .data %11011 ; ↑↓-→F
    .data %00111 ; ↑↓←--
    .data %10111 ; ↑↓←-F
    .data %01111 ; ↑↓←→-
    .data %11111 ; ↑↓←→F
}
