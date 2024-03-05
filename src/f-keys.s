;  f-keys.s -- Handle keyboard input for main program.
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

.section reserved

shift .reserve 1

last_key .reserve 1

.section code

.public get_f_key {
    lda #$00
    sta CIA1_DDRA
    sta CIA1_DDRB
    lda #$ff
    sta CIA1_PRA
    sta CIA1_PRB

    lda CIA1_PRA
    and CIA1_PRB
    cmp #$ff
    bne f_none
    lda #$ff
    sta CIA1_DDRA

    ; get shift
    lda #$40 ^ $ff
    sta CIA1_PRA
    lda CIA1_PRB
    eor #$ff
    and #$10
    sta shift
    lda #$02 ^ $ff
    sta CIA1_PRA
    lda CIA1_PRB
    eor #$ff
    and #$80
    ora shift
    sta shift

    lda #$01 ^ $ff
    sta CIA1_PRA
    lda CIA1_PRB
    ; down F5 F3 F1 F7 ...
    rol
    rol
    bcs not_f5
    ldx #5
    bne f_got
not_f5:
    rol
    bcs not_f3
    ldx #3
    bne f_got
not_f3:
    rol
    bcs not_f1
    ldx #1
    bne f_got
not_f1:
    bmi f_none
    ldx #7
f_got:
    lda #$00
    sta CIA1_DDRA
    sta CIA1_DDRB
    lda #$ff
    sta CIA1_PRA
    sta CIA1_PRB

    lda CIA1_PRA
    and CIA1_PRB
    cmp #$ff
    bne f_none

    lda shift
    beq f_end
    inx
    bne f_end
f_none:
    ldx #0
f_end:
    lda #$ff
    sta CIA1_DDRA
    sta CIA1_DDRB
    cpx last_key
    stx last_key
    beq :+
    ldx #0
:    cpx #0
    rts
}

.public handle_keyboard {
    jsr get_f_key
    beq none
    lda last_command
    ora command
    bne end
    stx command
none:
    stx last_command
end:
    rts
}

.public port1_next {
    ldx port1_type
    inx
    cpx #CONTROLLER_NUM_TYPES
    bne :+
    ldx #0
:    stx port1_type
    ldy #0
    jmp copy_port_screen
}

.public port1_previous {
    ldx port1_type
    dex
    bpl :+
    ldx #CONTROLLER_NUM_TYPES - 1
:    stx port1_type
    ldy #0
    jmp copy_port_screen
}

.public port2_next {
    ldx port2_type
    inx
    cpx #CONTROLLER_TYPE_LIGHTPEN
    bne :+
    inx
:    cpx #CONTROLLER_NUM_TYPES
    bne :+
    ldx #0
:    stx port2_type
    ldy #1
    jmp copy_port_screen
}

.public port2_previous {
    ldx port2_type
    dex
    cpx #CONTROLLER_TYPE_LIGHTPEN
    bne :+
    dex
:    cpx #$FF
    bne :+
    ldx #CONTROLLER_NUM_TYPES - 1
:    stx port2_type
    ldy #1
    jmp copy_port_screen
}

.public userport_next {
    ldx userport_type
    inx
    cpx #USER_NUM_TYPES
    bne :+
    ldx #0
:    stx userport_type
    jmp copy_userport
}

.public userport_previous {
    ldx userport_type
    dex
    bpl :+
    ldx #USER_NUM_TYPES - 1
:    stx userport_type
    jmp copy_userport
}
