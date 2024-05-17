;  ports.s -- Display state of ports.
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

.section reserved



.public port_number .reserve 1
.public port_digital .reserve 2
.public port_pot1 .reserve 1
.public port_pot2 .reserve 1
.public pen_x .reserve 1
.public pen_y .reserve 2

pen_x_new .reserve 1

pen_y_new .reserve 1


.section code

.public handle_top {
    lda #0
    ldx VIC_LIGHT_PEN_X
    ldy VIC_LIGHT_PEN_Y
    bmi :+
    lda #1
:   cpx pen_x
    bne top_change
    cpy pen_y
    beq top_no_change
top_change:
    stx pen_x
    sty pen_y
    sta pen_y + 1
top_no_change:
    lda port1_type
    cmp #CONTROLLER_TYPE_LIGHTPEN
    bne :+
    jsr lightpen_sprite_top
:   rts
}

.public handle_port1 {
    lda VIC_LIGHT_PEN_X
    sta pen_x_new
    lda VIC_LIGHT_PEN_Y
    sta pen_y_new

    jsr display_logo

    ; read POT1/POT2
    lda machine_type
    bpl sid
    lda $d620
    sta port_pot1
    lda $d621
    sta port_pot2
    jmp end_pot
sid:
    lda SID_POT_X
    sta port_pot1
    lda SID_POT_Y
    sta port_pot2

end_pot:
    ; read digital input
    lda #$00
    sta CIA1_DDRA
    sta CIA1_DDRB
    lda #$ff
    sta CIA1_PRA
    eor CIA1_PRB
    sta port_digital

    ; handle lightpen
    ldx pen_x_new
    ldy pen_y_new
    cpx pen_x
    bne bottom_change
    cpy pen_y
    beq bottom_no_change
bottom_change:
    stx pen_x
    sty pen_y
    lda #0
    sta pen_y + 1
bottom_no_change:

    jsr handle_keyboard

    ; select POTs from port 2
    lda #$c0
    sta CIA1_DDRA
    lda #$80
    sta CIA1_PRA

    lda command
    bne end_port1
    ldx #0
    jsr display_port
end_port1:
    lda VIC_RASTER
    bmi end_port1
    jmp handle_top
}

.public handle_port2 {
    jsr content_background

    ; read POT1/POT2
    lda machine_type
    bpl sid
    lda $d622
    sta port_pot1
    lda $d623
    sta port_pot2
    jmp end_pot
sid:
    lda SID_POT_X
    sta port_pot1
    lda SID_POT_Y
    sta port_pot2

end_pot:
    ; read control port 2
    lda #$00
    sta CIA1_DDRA
    sta CIA1_DDRB
    lda #$ff
    sta CIA1_PRB
    eor CIA1_PRA
    sta port_digital

    ; select POTs from port 1
    lda #$c0
    sta CIA1_DDRA
    lda #$40
    sta CIA1_PRA

    lda port1_type
    cmp #CONTROLLER_TYPE_LIGHTPEN
    bne :+
    jsr lightpen_sprite_bottom
:

    lda command
    bne end_port2
    ldx #1
    jsr display_port
end_port2:
    rts
}
