;  port-screen.s -- Display basic layout of various controller screens.
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


; copy screen for port Y

name_address = screen + 9
view_address = screen + 81

.section reserved

view_times_2 .reserve 1

port .reserve 1

.section data

.public port_x_offset {
    .data 32, 32 + 20 * 8
}


.section code

; A: view
; Y: port (0, 1)
change_port_view {
    cmp port1_current_view,y
    beq end
    sta port1_current_view,y
    lda #COMMAND_PORT1_UPDATE_VIEW
    cpy #0
    beq :+
    lda #COMMAND_PORT2_UPDATE_VIEW
:   sta command
end:
    rts
}

port1_update_view {
    ldy #0
    jmp copy_port_view
}

port2_update_view {
    ldy #1
    jmp copy_port_view
}

; Y: port (0, 1)
.public copy_port_screen {
    ldx port1_type,y
    lda port_default_screens,x
    sta port1_current_view,y
    jsr copy_port_view
    jmp copy_port_name
}

; Y: port (0, 1)
.public copy_port_name {
    ldx port1_type,y

    lda #<name_address
    cpy #1
    bne :+
    clc
    adc #20
:   sta ptr2
    lda #>name_address
    sta ptr2 + 1

    txa
    asl
    asl
    asl
    asl
    clc
    adc #<port_names
    sta ptr1
    lda #0
    adc #>port_names
    sta ptr1 + 1

    ldy #8
loop:
    lda (ptr1),y
    sta (ptr2),y
    dey
    bpl loop
    rts
}

; Y: port (0, 1)
.public copy_port_view {
    sty port
    lda #<view_address
    cpy #1
    bne :+
    clc
    adc #20
:   sta ptr2
    lda #>view_address
    sta ptr2 + 1

    lda port1_current_view,y
    asl
    tax
    stx view_times_2
    lda port_screens,x
    sta ptr1
    lda port_screens + 1,x
    sta ptr1 + 1
    ldx #17
    ldy #9
    jsr copyrect

    ldy port
    beq next
    lda port1_current_view,y
    cmp #CONTROLLER_VIEW_RAW
    bne next

    subtract_word ptr2, 40
    ldy #16
    lda #$20
:   sta (ptr2),y
    dey
    bpl :-

next:
    ; set correct sprite pointers
    lda port
    asl
    tay
    ldx view_times_2
    lda port_sprite,x
    sta screen + $3f8,y
    lda port_sprite + 1,x
    sta screen + $3f9,y

    ldy port
    rts
}

.section data

; indexed by port view
port_sprite {
    .data sprite_none, sprite_none
    .data sprite_cross, sprite_none
    .data sprite_bar, sprite_none
    .data sprite_cross, sprite_none
    .data sprite_cross, sprite_lightpen
    .data sprite_none, sprite_none
    .data sprite_none, sprite_none
    .data sprite_bar, sprite_bar
    .data sprite_none, sprite_none
}

port_names {
    .data "joystick        ":screen_inverted
    .data "mouse           ":screen_inverted
    .data "paddle 1        ":screen_inverted
    .data "paddle 2        ":screen_inverted
    .data "koalapad        ":screen_inverted
    .data "light pen       ":screen_inverted
    .data "protopad        ":screen_inverted
    .data "trap them       ":screen_inverted
    .data "raw             ":screen_inverted
}

port_default_screens {
    .data CONTROLLER_VIEW_JOYSTICK
    .data CONTROLLER_VIEW_MOUSE
    .data CONTROLLER_VIEW_PADDLE
    .data CONTROLLER_VIEW_PADDLE
    .data CONTROLLER_VIEW_KOALAPAD
    .data CONTROLLER_VIEW_LIGHTPEN
    .data CONTROLLER_VIEW_SNES
    .data CONTROLLER_VIEW_TRAPTHEM
    .data CONTROLLER_VIEW_RAW
}

port_screens {
    .repeat i, CONTROLLER_NUM_VIEWS {
        .data port_screen_data + 17 * 9 * i
    }
}

port_screen_data {
    .binary_file "port-screens.bin"
}