;  display-trapthem.s -- Display Trap Them controller.
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

.section reserved

trapthem_pad .reserve 3

.section code

.public display_trapthem {
    stx port
    dex
    beq :+
    ldx #1
:
    lda #$18
    sta CIA1_DDRA,x
    lda #$10
    sta CIA1_PRA,x
    lda #$00
    sta CIA1_PRA,x

    lda #<trapthem_pad
    sta rotate + 1
    ldy #24
loop:
    lda CIA1_PRA,x
    ror
    ror
    ror
rotate:
    rol trapthem_pad

    lda #$08
    sta CIA1_PRA,x
    lda #$00
    sta CIA1_PRA,x

    dey
    beq end
    tya
    and #7
    bne loop
    inc rotate + 1
    bne loop

end:
    lda #$10
    sta CIA1_PRA,x
    lda #0
    sta CIA1_PRA,x

    ldy port
    lda trapthem_pad + 1
    and #$07
    beq found
    lda trapthem_pad + 2
    beq found
    lda #CONTROLLER_VIEW_NONE
    jmp change_port_view

found:
    lda #CONTROLLER_VIEW_SNES
    jsr change_port_view
    clc
    lda ptr2
    adc #41
    sta ptr2
    bcc :+
    inc ptr2 + 1
:
    lda trapthem_pad + 1
    eor #$ff
    tax
    lda trapthem_pad
    eor #$ff
    ldy #1
    jsr display_snes

    rts
}
