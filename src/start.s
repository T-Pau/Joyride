;  start.s -- Entry point of program.
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

.public start {
    ; disable BASIC ROM
    lda #$36
    sta $01
    lda #1
    sta VIC_SPRITE_0_X
    lda #VIC_KNOCK_IV_1
    sta VIC_KEY
    lda #VIC_KNOCK_IV_2
    sta VIC_KEY
    lda #0
    sta VIC_PALETTE_RED
    lda VIC_SPRITE_0_X
    beq not_m65
    ;; Enable fast CPU for quick depack
    lda #65
    sta 0
    lda #$ff
    bne both
not_m65:
    lda #0
both:
    sta machine_type

    lda #COLOR_FRAME
    sta VIC_BORDER_COLOR

    memcpy charset, charset_data, $800
    memcpy sprites, sprite_data, (64 * 8)
    rl_expand charset_extra, charset_extra_data

    jsr init_state
    jsr display_main_screen

    set_vic_bank $c000
    set_vic_text screen, charset

    lda #$0f
    sta VIC_SPRITE_ENABLE
    lda #0
    sta VIC_SPRITE_PRIORITY
    sta VIC_SPRITE_EXPAND_X
    sta VIC_SPRITE_EXPAND_Y
    sta VIC_SPRITE_MULTICOLOR

    lda #COLOR_WHITE
    sta VIC_SPRITE_0_COLOR
    sta VIC_SPRITE_1_COLOR
    sta VIC_SPRITE_2_COLOR
    sta VIC_SPRITE_3_COLOR

    jsr setup_logo

    lda #$ff
    sta CIA1_DDRA
    sta CIA1_DDRB

    jsr init_irq

    ; save timer configuration
    lda CIA1_TIMER_A
    sta timer_1a
    lda CIA1_TIMER_A + 1
    sta timer_1a + 1
    lda CIA1_TIMER_A_CONTROL
    sta timer_1a_control
    lda CIA2_TIMER_A
    sta timer_2a
    lda CIA2_TIMER_A + 1
    sta timer_2a + 1
    lda CIA2_TIMER_A_CONTROL
    sta timer_2a_control

    ; set up serial loopback for userport adapters
    lda #0
    sta CIA2_DDRB
    lda #1
    sta CIA1_TIMER_A
    sta CIA2_TIMER_A
    lda #0
    sta CIA1_TIMER_A + 1
    sta CIA2_TIMER_A + 1
    lda #%00010001
    sta CIA2_TIMER_A_CONTROL
    lda #%01010001
    sta CIA1_TIMER_A_CONTROL

    jmp main_loop
}


.section reserved

.public machine_type .reserve 1

timer_1a .reserve 2
timer_1a_control .reserve 1
timer_2a .reserve 2
timer_2a_control .reserve 1