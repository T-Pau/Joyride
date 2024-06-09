;  exit.s -- Exit program
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

.pin kernal_irq $02a7 ; Otherwise it would be below BASIC ROM.

.section code

exit {
    ;rts ; TODO: currently not working
    sei
    ; restore timer configuration
    lda timer_1a
    sta CIA1_TIMER_A
    lda timer_1a + 1
    sta CIA1_TIMER_A + 1
    lda timer_1a_control
    sta CIA1_TIMER_A_CONTROL
    lda timer_2a
    sta CIA2_TIMER_A
    lda timer_2a + 1
    sta CIA2_TIMER_A + 1
    lda timer_2a_control
    sta CIA2_TIMER_A_CONTROL

    lda #$37
    sta $01
    jsr restore_irq
    set_vic_bank $0000
    set_vic_text $0400, $1000

    brk
    rts
}
