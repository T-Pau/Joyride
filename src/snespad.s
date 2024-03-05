;  snespad.s -- Support routines for Ninja SNES PAD
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

.section code

.public snespad_read {
    lda #<snes_buttons
    sta rot + 1
    lda #>snes_buttons
    sta rot + 2

    ; port b 3 & 4 as output, rest as input
    lda #$00
    sta CIA1_DDRA
    lda #$18
    sta CIA1_DDRB

    ; pulse latch
    lda #$f7
    sta CIA1_PRB
    lda #$e7
    sta CIA1_PRB

bytes:
    ldy #7

bits:
    lda CIA1_PRB
    eor #$07
    ldx #0
pad:
    lsr
rot:
    rol $1000,x
    inx
    cpx #8
    beq next_bit
    cpx #3
    bne pad
    lda CIA1_PRA
    eor #$1f
    jmp pad
next_bit:
    ; pulse clock
    lda #$ef
    sta CIA1_PRB
    lda #$e7
    sta CIA1_PRB
    dey
    bpl bits

    clc
    lda rot + 1
    adc #8
    sta rot + 1
    bcc :+
    inc rot + 2
:    cmp #<snes_buttons_end
    bne bytes

    ; latch again to reset input lines
    lda #$f7
    sta CIA1_PRB
    lda #$e7
    sta CIA1_PRB
    rts
}