;  extra.s -- Display and handle keyboard input for extra screen.
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

EXTRA_NEOS = 0
EXTRA_CX21 = 1
EXTRA_CX85 = 2
EXTRA_CARDKEY = 3
EXTRA_RUSHWARE = 4
EXTRA_COPLIN = 5
EXTRA_NUM_TYPES = 6

EXTRA_VIEW_MOUSE = 0
EXTRA_VIEW_CARDKEY = 1
EXTRA_VIEW_CX85 = 2
EXTRA_VIEW_CX21 = 3
EXTRA_VIEW_RUSHWARE = 4
EXTRA_VIEW_COPLIN = 5
EXTRA_NUM_VIEWS = 6

EXTRA_COLOR_NEOS = 0
EXTRA_COLOR_KEYPAD = 1

EXTRA_COLOR_START = color_ram + 4 * 40 + 11
EXTRA_VIEW_START = screen + 4 * 40 + 11
EXTRA_TITLE_START = EXTRA_VIEW_START - 80

MAX_NUM_KEYS = 17

.section code

display_extra_screen {
    set_f_key_command_table extra_f_key_commands
    store_word source_ptr, extra_screen
    store_word destination_ptr, screen
    jsr rl_expand
    store_word source_ptr, extra_colors
    store_word destination_ptr, color_ram
    jsr rl_expand

    set_irq_table extra_irq_table

    lda #0
    sta extra_type
    lda #VIEW_DYNAMIC
    sta extra_view

    jmp setup_extra_type
}

extra_next_type {
    ldx extra_type
    inx
    cpx #EXTRA_NUM_TYPES
    bne :+
    ldx #0
:   stx extra_type
    jmp setup_extra_type
}

extra_previous_type {
    ldx extra_type
    dex
    bpl :+
    ldx #EXTRA_NUM_TYPES - 1
:   stx extra_type
    jmp setup_extra_type
}

; Display title and view of current type
setup_extra_type {
    lda extra_type
    asl
    tax
    lda extra_top_handler,x
    sta extra_top_jsr
    lda extra_top_handler + 1,x
    sta extra_top_jsr + 1
    lda extra_bottom_handler,x
    sta extra_bottom_jsr
    lda extra_bottom_handler + 1,x
    sta extra_bottom_jsr + 1
    lda extra_keys,x
    ldy extra_keys + 1,x
    sta temp
    ldx extra_type
    lda extra_num_keys,x
    ldx temp
    jsr set_keys_table
    lda #$ff
    sta key_index
    sta new_key_index
    ldx #MAX_NUM_KEYS - 1
    lda #0
:   sta new_key_state,x
    dex
    bpl :-
    ldx extra_type
    lda extra_default_color,x
    asl
    tax
    lda extra_color,x
    sta source_ptr
    lda extra_color + 1,x
    sta source_ptr + 1
    store_word destination_ptr, EXTRA_COLOR_START
    jsr rl_expand
    jsr copy_extra_type_name
    ldx extra_type
    lda extra_default_view,x
    jmp copy_extra_view
}

; Copy extra view to screen
; Arguments:
;   A: view to copy
.public copy_extra_view {
    cmp #VIEW_DYNAMIC
    beq end
    cmp extra_view
    beq end
    sta extra_view
    asl
    tax
    lda extra_screens,x
    sta source_ptr
    lda extra_screens + 1,x
    sta source_ptr + 1
    store_word destination_ptr, EXTRA_VIEW_START
    jsr rl_expand
    ; TODO: sprites
end:
    rts    
}

.public copy_extra_type_name {
    store_word destination_ptr, EXTRA_TITLE_START
    lda extra_type
    asl
    tax
    lda extra_type_name,x
    sta source_ptr
    lda extra_type_name + 1,x
    sta source_ptr + 1
    ldy #17
:   lda (source_ptr),y
    sta (destination_ptr),y
    dey
    bpl :-
    rts
}

extra_content {
    jsr content_background
    lda #VIC_VIDEO_ADDRESS(screen, charset_extra)
    ldy #top + 3 * 8
:   cpy VIC_RASTER
    bne :-
:   dey
    cpy #top + 3 * 8 - 5
    bne :-
    sta VIC_VIDEO_ADDRESS

    lda command
    bne end
extra_top_jsr_instruction:
.private extra_top_jsr = extra_top_jsr_instruction + 1
    jsr $0000
end:
    rts
}

extra_label {
    lda #VIC_VIDEO_ADDRESS(screen, charset)
    ldy #top + 15 * 8 + 1
:   cpy VIC_RASTER
    bne :-
    sta VIC_VIDEO_ADDRESS
    jmp label_background
}

handle_extra {
    jsr display_logo
    lda command
    bne end
extra_bottom_jsr_instruction:
.private extra_bottom_jsr = extra_bottom_jsr_instruction + 1
    jsr $0000
end:
    sec
    jmp handle_keyboard
}

display_single_key {
    ldx key_index
    bmi :+
    lda #0
    jsr display_key
:   ldx new_key_index
    stx key_index
    bmi :+
    lda #1
    jsr display_key
:   rts    
}

read_cx21 {
    ldx #11
    lda #0
:   sta new_key_state,x
    dex
    bpl :-
    rts
}

handler_dummy {
    rts
}

.section data

extra_colors {
    rl_encode 10 + 4*40, COLOR_FRAME
    rl_skip 20
    .repeat 9 {
        rl_encode 20, COLOR_FRAME
        rl_skip 20
    }
    rl_encode 10 + 10*40, COLOR_FRAME
    rl_end
}

extra_neos_color {
    rl_encode 18, COLOR_CONTENT
    .repeat 8 {
        rl_skip 22
        rl_encode 18, COLOR_CONTENT
    }
    rl_end
}

extra_keypad_color {
    rl_encode 18, COLOR_UNCHECKED
    .repeat 8 {
        rl_skip 22
        rl_encode 18, COLOR_UNCHECKED
    }
    rl_end
}


extra_type_name {
    .repeat i, EXTRA_NUM_TYPES {
        .data extra_type_name_data + i * 18
    }
}

extra_color {
    .data extra_neos_color
    .data extra_keypad_color
}

extra_type_name_data {
    ;      123456789012345678
    .data "neos mouse        ":screen_inverted
    .data "atari cx21/cx50   ":screen_inverted
    .data "atari cx85        ":screen_inverted
    .data "cardco cardkey 1  ":screen_inverted
    .data "rushware keypad   ":screen_inverted
    .data "coplin keypad     ":screen_inverted
}

extra_default_view {
    .data EXTRA_VIEW_MOUSE
    .data EXTRA_VIEW_CX21
    .data EXTRA_VIEW_CX85
    .data EXTRA_VIEW_CARDKEY
    .data EXTRA_VIEW_RUSHWARE
    .data EXTRA_VIEW_COPLIN
}

extra_default_color {
    .data EXTRA_COLOR_NEOS
    .data EXTRA_COLOR_KEYPAD
    .data EXTRA_COLOR_KEYPAD
    .data EXTRA_COLOR_KEYPAD
    .data EXTRA_COLOR_KEYPAD
    .data EXTRA_COLOR_KEYPAD
    .data EXTRA_COLOR_KEYPAD
}

extra_top_handler {
    .data handler_dummy
    .data read_cx21
    .data handler_dummy
    .data handler_dummy
    .data handler_dummy
    .data read_coplin
}

extra_bottom_handler {
    .data handler_dummy
    .data display_keyboard
    .data display_single_key
    .data display_single_key
    .data display_single_key
    .data display_single_key
}

extra_keys {
    .data 0:2
    .data keys_3x4_keys
    .data keys_cx85_keys
    .data keys_4x4_keys
    .data keys_4x4_keys
    .data keys_3x4_keys
}

extra_num_keys {
    .data 0
    .data 12
    .data 17
    .data 16
    .data 16
    .data 12
}

extra_f_key_commands {
    .data 0
    .data COMMAND_EXTRA_NEXT, COMMAND_EXTRA_PREVIOUS
    .data 0, 0
    .data 0, 0
    .data 0, 0
    .data COMMAND_MAIN
}

.section reserved

extra_type .reserve 1
extra_view .reserve 1

key_index .reserve 1
new_key_index .reserve 1
