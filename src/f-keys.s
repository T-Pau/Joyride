;  f-keys.s -- Handle keyboard input.
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

KEY_NONE = 0
KEY_F1 = 1
KEY_F2 = 2
KEY_F3 = 3
KEY_F4 = 4
KEY_F5 = 5
KEY_F6 = 6
KEY_F7 = 7
KEY_F8 = 8
KEY_C_F1 = 9
KEY_STOP = 10
KEY_LEFT_ARROW = 11
KEY_SPACE = 12
KEY_PLUS = 13
KEY_MINUS = 14

CLEAR_BIT(bitt, value = $ff) = value & ($ff - (1 << bitt))
SET_BIT(bitt, value = $00) = value | (1 << bitt)


.section reserved

shift .reserve 1

last_key .reserve 1

f_key_num_commands .reserve 1

.section code

.macro set_f_key_command_table table {
    ldx #<table
    ldy #>table
    lda #.sizeof(table)
    jsr set_f_key_command_table
}

; Set command table
; Arguments:
;   A: number of commands in table
;   X/Y: address
.public set_f_key_command_table .used { ; XLR8: used shouldn't be neccessary
    sta f_key_num_commands
    stx f_key_commands
    sty f_key_commands + 1
    rts
}


; Get pressed key.
; Returns:
;   Y: number of key pressed, 0 for none pressed
.public read_keys {
    ; check for joystick interference
    lda #$00
    sta CIA1_DDRA
    sta CIA1_DDRB
    lda #$ff
    sta CIA1_PRA
    sta CIA1_PRB
    lda CIA1_PRB
    eor #$ff
    sta f_key_mask
    lda CIA1_PRA
    cmp #$ff
    beq :+
    jmp no_key
:   lda #$ff
    sta CIA1_DDRA

    ; get shift
    ldx #0
    lda #CLEAR_BIT(6)
    sta CIA1_PRA
    lda CIA1_PRB
    ora f_key_mask
    eor #$ff
    and #SET_BIT(4)
    bne shift_pressed
    lda #CLEAR_BIT(1)
    sta CIA1_PRA
    lda CIA1_PRB
    ora f_key_mask
    eor #$ff
    and #SET_BIT(7)
    beq no_shift
shift_pressed:    
    inx
no_shift:
    lda #CLEAR_BIT(7)
    sta CIA1_PRA
    lda CIA1_PRB
    ora f_key_mask
    eor #$ff
    tay
    and #SET_BIT(5)
    beq not_commodore
    ldx #$80
not_commodore:
    stx shift

    ; get other keys
    tya
    bpl not_runstop
    ldy #KEY_STOP
    bne got_key 
not_runstop:
    ldx f_key_num_commands
    cpx #KEY_LEFT_ARROW
    bcc read_function
    tya
    and #SET_BIT(4)
    beq :+
    ldy #KEY_SPACE
    bne got_key
:   tya
    and #SET_BIT(1)
    beq :+
    ldy #KEY_LEFT_ARROW
    bne got_key

:   lda #CLEAR_BIT(5)
    sta CIA1_PRA
    lda CIA1_PRB
    ora f_key_mask
    eor #$ff
    tay
    and #SET_BIT(3)
    beq :+
    ldy #KEY_MINUS
    bne got_key
:   tya
    and #SET_BIT(0)    
    beq read_function
    ldy #KEY_PLUS
    bne got_key

read_function:
    lda #CLEAR_BIT(0)
    sta CIA1_PRA
    lda CIA1_PRB
    ora f_key_mask
    ; down F5 F3 F1 F7 ...
    rol
    rol
    bcs :+
    ldy #5
    bne got_function_key
:   rol
    bcs :+
    ldy #3
    bne got_function_key
:   rol
    bcs :+
    ldy #1
    bne got_function_key
:   bmi no_key
    ldy #7
got_function_key:
    lda shift
    bpl :+
    cpy #1
    bne :+
    ldy #KEY_C_F1
    bne end
:   tax
    beq got_key
    iny

got_key:
    lda #$00
    sta CIA1_DDRA
    sta CIA1_DDRB
    lda #$ff
    sta CIA1_PRA
    sta CIA1_PRB

    lda CIA1_PRB
    ora f_key_mask
    and CIA1_PRA
    cmp #$ff
    beq end

no_key:
    ldy #0
end:
    lda #$ff
    sta CIA1_DDRA
    sta CIA1_DDRB
    cpy last_key
    sty last_key
    beq :+
    ldy #0
:   rts
}

.public handle_keyboard {
    jsr read_keys
    tya
    beq none
    cmp f_key_num_commands
    bcs none
    lda last_command
    ora command
    bne end
    lda (f_key_commands),y
    sta command
none:
    sta last_command
end:
    rts
}

.public port1_next {
    ldx port1_type
    inx
    cpx #CONTROLLER_NUM_TYPES
    bne :+
    ldx #0
:   stx port1_type
    ldy #0
    jmp copy_port_screen
}

.public port1_previous {
    ldx port1_type
    dex
    bpl :+
    ldx #CONTROLLER_NUM_TYPES - 1
:   stx port1_type
    ldy #0
    jmp copy_port_screen
}

.public port2_next {
    ldx port2_type
    inx
    cpx #CONTROLLER_TYPE_LIGHTPEN
    bne :+
    inx
:   cpx #CONTROLLER_NUM_TYPES
    bne :+
    ldx #0
:   stx port2_type
    ldy #1
    jmp copy_port_screen
}

.public port2_previous {
    ldx port2_type
    dex
    cpx #CONTROLLER_TYPE_LIGHTPEN
    bne :+
    dex
:   cpx #$FF
    bne :+
    ldx #CONTROLLER_NUM_TYPES - 1
:   stx port2_type
    ldy #1
    jmp copy_port_screen
}

.public userport_next {
    ldx userport_type
    inx
    cpx #USER_NUM_TYPES
    bne :+
    ldx #0
:   stx userport_type
    jmp copy_userport
}

.public userport_previous {
    ldx userport_type
    dex
    bpl :+
    ldx #USER_NUM_TYPES - 1
:   stx userport_type
    jmp copy_userport
}

.section data

main_f_key_commands {
    .data 0
    .data COMMAND_EIGHT_PLAYER, COMMAND_EXTRA ; F1 / F2
    .data COMMAND_PORT1_NEXT, COMMAND_PORT1_PREVIOUS ; F3 / F4
    .data COMMAND_PORT2_NEXT, COMMAND_PORT2_PREVIOUS ; F5 / F6
    .data COMMAND_USERPORT_NEXT, COMMAND_USERPORT_PREVIOUS ; F7 / F8
    .data COMMAND_HELP, COMMAND_EXIT ; C=-F1 / RunStop
}

.section zero_page

f_key_commands .reserve 2
f_key_mask .reserve 1
