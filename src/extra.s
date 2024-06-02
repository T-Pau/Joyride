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

EXTRA_VIEW_START = screen + 4 * 40 + 11
EXTRA_TITLE_START = EXTRA_VIEW_START - 80

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

    jmp setup_extra_display
}

extra_next_type {
    ldx extra_type
    inx
    cpx #EXTRA_NUM_TYPES
    bne :+
    ldx #0
:   stx extra_type
    jmp setup_extra_display
}

extra_previous_type {
    ldx extra_type
    dex
    bpl :+
    ldx #EXTRA_NUM_TYPES - 1
:   stx extra_type
    jmp setup_extra_display
}

; Display title and view of current type
setup_extra_display {
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
    sec
    jmp handle_keyboard
}

.section data

extra_colors {
    rl_encode 10 + 4*40, COLOR_FRAME
    rl_encode 20, COLOR_CONTENT
    .repeat 9 {
        rl_encode 20, COLOR_FRAME
        rl_encode 20, COLOR_CONTENT
    }
    rl_encode 10 + 10*40, COLOR_FRAME
    rl_end
}

extra_type_name {
    .repeat i, EXTRA_NUM_TYPES {
        .data extra_type_name_data + i * 18
    }
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
