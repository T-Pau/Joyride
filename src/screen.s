;  screen.s -- Screen contents.
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

.section code

.public display_main_screen {
    jsr reset_sampler
    set_f_key_command_table main_f_key_commands
    lda #MODE_MAIN
    sta mode

    rl_expand screen, main_screen
    rl_expand color_ram, main_color
    ldy #0
    jsr copy_port_screen
    ldy #1
    jsr copy_port_screen
    jsr copy_userport
    ldx #<main_irq_table
    ldy #>main_irq_table
    lda #.sizeof(main_irq_table)
    jsr set_irq_table
    rts
}

.public display_eight_player_screen {
    set_f_key_command_table eight_player_f_key_commands
    lda #MODE_EIGHT_PLAYER
    sta mode

    ldx #<eight_player_irq_table
    ldy #>eight_player_irq_table
    lda #.sizeof(eight_player_irq_table)
    jsr set_irq_table

    lda #0
    ldy #7
:   sta VIC_SPRITE_0_X,y
    dey
    bpl :-
    lda VIC_SPRITE_X_MSB
    and #$f0
    sta VIC_SPRITE_X_MSB

    ldx #7
    lda EIGHT_PLAYER_VIEW_NONE
:   sta eight_player_views,x
    dex
    bpl :-
    ldx #3
:   sta eight_player_current_views,x
    dex
    bpl :-

    rl_expand screen, big_window_screen
    store_word source_ptr, eight_player_legend
    jsr rl_expand
    rl_expand color_ram, help_color
    jsr copy_eight_player_type_name
    rts
}

.public display_help_screen {
    jsr reset_sampler
    ldx #<help_irq_table
    ldy #>help_irq_table
    lda #.sizeof(help_irq_table)
    jsr set_irq_table
    set_f_key_command_table help_f_key_commands

    lda #0
    ldy #7
:   sta VIC_SPRITE_0_X,y
    dey
    bpl :-
    lda VIC_SPRITE_X_MSB
    and #$f0
    sta VIC_SPRITE_X_MSB

    rl_expand screen, big_window_screen
    store_word source_ptr, help_legend
    jsr rl_expand
    rl_expand color_ram, help_color
    ldx #0
    stx current_help_page
    jsr display_help_page
    rts
}

.public display_current_screen {
    lda mode
    bne :+
    jmp display_main_screen
:   cmp #MODE_EIGHT_PLAYER
    bne :+
    jmp display_eight_player_screen
:   jmp display_extra_screen
}
