;  eight_player.s -- Display and handle keyboard input for 8 player adapters.
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

eight_player_screen_start = screen + 40 * 2 + 1

.section reserved

eight_player_index .reserve 2

.section code

.public eight_player_next_type {
    ldx eight_player_type
    inx
    cpx #EIGHT_PLAYER_NUM_TYPES
    bne :+
    ldx #0
:   stx eight_player_type
    ldx #0
    stx eight_player_page
    jsr copy_eight_player_type_name
    rts
}

.public eight_player_previous_type {
    ldx eight_player_type
    dex
    bpl :+
    ldx #EIGHT_PLAYER_NUM_TYPES - 1
:   stx eight_player_type
    ldx #0
    stx eight_player_page
    jsr copy_eight_player_type_name
    rts
}

.public eight_player_next_page {
    ldx eight_player_type
    ldy eight_player_page
    iny
    tya
    cmp eight_player_num_pages,x
    bne :+
    ldy #0
:   sty eight_player_page
    jsr eight_player_update_views
    jsr copy_eight_player_page_title
    rts
}

.public eight_player_previous_page {
    ldy eight_player_page
    dey
    bpl :+
    ldx eight_player_type
    ldy eight_player_num_pages,x
    dey
:   sty eight_player_page
    jsr eight_player_update_views
    jsr copy_eight_player_page_title
    rts
}

.public eight_player_set_all_views {
    ldy #0
    ldx #11
loop:
    cmp eight_player_views,x
    beq :+
    iny
    sta eight_player_views,x
:   dex
    bpl loop
    cpy #0
    beq :+
    lda #COMMAND_EIGHT_PLAYER_UPDATE_VIEWS
    sta command
:   rts
}

.public eight_player_update_views {
    lda eight_player_page
    asl
    asl
    tax
    stx eight_player_index
    ldy #0
    sty eight_player_index + 1
view_loop:
    lda eight_player_views,x
    cmp eight_player_current_views,y
    beq same_view
    sta eight_player_current_views,y
    tax
    lda view_sprite,x
    sta screen + $3f8,y
    txa
    asl
    tax
    lda eight_player_view,x
    sta ptr1
    lda eight_player_view + 1,x
    sta ptr1 + 1
    tya
    asl
    tay
    lda #0
    sta VIC_SPRITE_0_X,y
    sta VIC_SPRITE_0_Y,y
    lda view_start,y
    sta ptr2
    lda view_start + 1,y
    sta ptr2 + 1
    ldx #18
    ldy #9
    jsr copyrect
same_view:
    ldx eight_player_index
    inx
    stx eight_player_index
    ldy eight_player_index + 1
    iny
    sty eight_player_index + 1
    cpy #4
    bne view_loop
    rts
}

.public copy_eight_player_type_name {
    lda eight_player_type
    asl
    tax
    lda eight_player_default_view,x
    sta ptr1
    lda eight_player_default_view + 1,x
    sta ptr1 + 1
    ldy #15
:   lda (ptr1),y
    sta eight_player_views,y
    dey
    bpl :-
    jsr eight_player_update_views
    store_word screen + 1, ptr2
    lda eight_player_type
    asl
    tax
    lda eight_player_type_name,x
    sta ptr1
    lda eight_player_type_name + 1,x
    sta ptr1 + 1
    ldy #19
:   lda (ptr1),y
    sta (ptr2),y
    dey
    bpl :-
    ; fallthrough
.public copy_eight_player_page_title:
    store_word screen + 33, ptr2
    ldx eight_player_type
    lda eight_player_page_name_index,x
    clc
    adc eight_player_page
    asl
    tax
    lda eight_player_page_name,x
    sta ptr1
    lda eight_player_page_name + 1,x
    sta ptr1 + 1
    ldy #4
:   lda (ptr1),y
    sta (ptr2),y
    dey
    bpl :-
    rts
}

.public eight_player_top {
    jsr content_background

    lda eight_player_type
    asl
    tax
    lda top_handler,x
    sta top_jmp + 1
    lda top_handler + 1,x
    sta top_jmp + 2
top_jmp:
    jmp $0000
}

.public eight_player_bottom {
    jsr display_logo

    lda eight_player_type
    asl
    tax
    lda bottom_handler,x
    sta bottom_jmp + 1
    lda bottom_handler + 1,x
    sta bottom_jmp + 2
bottom_jmp:
    jsr $0000

    jsr get_f_key
    beq none
    lda last_command
    ora command
    bne end
    lda f_key_commands,x
    tax
    stx command
none:
    stx last_command
end:
    rts
}


.section data

view_start {
    .data screen + EIGHT_PLAYER_OFFSET_FIRST
    .data screen + EIGHT_PLAYER_OFFSET_SECOND
    .data screen + EIGHT_PLAYER_OFFSET_THIRD
    .data screen + EIGHT_PLAYER_OFFSET_FOURTH
}

view_sprite {
    .data sprite_none
    .data sprite_none
    .data sprite_none
    .data sprite_cross
}

top_handler {
    .data superpad_top
    .data superpad_top
    .data spaceballs_top
    .data spaceballs_top
    .data inception_top
    .data inception_top
    .data multijoy_top
    .data protovision_multijoy_top
    .data wheel_of_joy_top
    .data wheel_of_joy_mini_top
}

bottom_handler {
    .data superpad_bottom
    .data superpad_bottom
    .data spaceballs_bottom
    .data spaceballs_bottom
    .data inception_bottom
    .data inception_bottom
    .data spaceballs_bottom
    .data spaceballs_bottom
    .data spaceballs_bottom
    .data wheel_of_joy_mini_bottom
}

f_key_commands {
    .data 0
    .data COMMAND_EIGHT_PLAYER_NEXT_TYPE, COMMAND_EIGHT_PLAYER_PREVIOUS_TYPE
    .data COMMAND_EIGHT_PLAYER_NEXT_PAGE, COMMAND_EIGHT_PLAYER_PREVIOUS_PAGE
    .data 0, 0
    .data COMMAND_MAIN, COMMAND_HELP
}

eight_player_num_pages {
    .data 3, 3, 2, 2, 3, 3, 4, 2, 2, 1
}

eight_player_default_view {
    .data eight_player_default_view_superpad
    .data eight_player_default_view_superpad
    .data eight_player_default_view_joystick
    .data eight_player_default_view_joystick
    .data eight_player_default_view_joystick
    .data eight_player_default_view_joystick
    .data eight_player_default_view_joystick_4_pages
    .data eight_player_default_view_joystick
    .data eight_player_default_view_joystick
    .data eight_player_default_view_joystick_2_button
}

eight_player_default_view_superpad {
    .data .fill(8, EIGHT_PLAYER_VIEW_NONE)
    .data .fill(4, EIGHT_PLAYER_VIEW_EMPTY)
}

eight_player_default_view_joystick {
    .data .fill(8, EIGHT_PLAYER_VIEW_JOYSTICK)
    .data .fill(4, EIGHT_PLAYER_VIEW_EMPTY)
}

eight_player_default_view_joystick_4_pages {
    .data .fill(16, EIGHT_PLAYER_VIEW_JOYSTICK)
}

eight_player_default_view_joystick_2_button {
    .data .fill(8, EIGHT_PLAYER_VIEW_JOYSTICK_2_BUTTON)
    .data .fill(4, EIGHT_PLAYER_VIEW_EMPTY)
}


eight_player_type_name {
    .repeat i, EIGHT_PLAYER_NUM_TYPES {
        .data eight_player_type_name_data + i * 20
    }
}

eight_player_type_name_data {
    ;      12345678901234567890
    .data "superpad 64         ":screen_inverted
    .data "ninja snes pad      ":screen_inverted
    .data "spaceballs port 1   ":screen_inverted
    .data "spaceballs port 2   ":screen_inverted
    .data "inception port 1    ":screen_inverted
    .data "inception port 2    ":screen_inverted
    .data "multijoy            ":screen_inverted
    .data "protovision multijoy":screen_inverted
    .data "wheel of joy        ":screen_inverted
    .data "wheel of joy mini   ":screen_inverted
}

; index into eight_player_page_name by type
eight_player_page_name_index {
    .data 0, 0, 0, 0
    .data 3, 3
    .data 6, 6, 6, 0
}

eight_player_page_name(i) = eight_player_page_name_data + i * 5
eight_player_page_name {
    .data eight_player_page_name(0), eight_player_page_name(1), eight_player_page_name(6)
    .data eight_player_page_name(4), eight_player_page_name(5), eight_player_page_name(6)
    .data eight_player_page_name(0), eight_player_page_name(1), eight_player_page_name(2), eight_player_page_name(3)
}

eight_player_page_name_data {
    .data "  1-4":screen_inverted
    .data "  5-8":screen_inverted
    .data " 9-12":screen_inverted
    .data "13-16":screen_inverted
    .data "  a-d":screen_inverted
    .data "  e-h":screen_inverted
    .data "  raw":screen_inverted
}

eight_player_view {
    .repeat i, EIGHT_PLYAER_NUM_VIEWS {
        .data eight_player_view_data + i * 18 * 9
    }
}

eight_player_view_data {
    .binary_file "eight-player.bin"
}
