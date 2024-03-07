;  display-joystick.s -- Display state of joystick.
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

joystick_tmp .reserve 1

.section data

joy_positions {
    .data screen + 4 * 40 + 2
    .data screen + 4 * 40 + 22
    .data screen + 15 * 40 + 8
    .data screen + 15 * 40 + 22
}

.section code

; display joystick number X

.public display_joystick {
    txa
    asl
    sta joystick_tmp
    tax
    lda joy_positions,x
    sta ptr2
    lda joy_positions + 1,x
    sta ptr2 + 1
    lda port_digital
    and #$f
    jsr dpad

    ; button 1
    clc
    ldx joystick_tmp
    lda joy_positions,x
    adc #46
    sta ptr2
    lda joy_positions + 1,x
    adc #0
    sta ptr2 + 1
    lda port_digital
    and #$10
    jsr button

    ldx joystick_tmp
    cpx #4
    bcs end

    ; button 2
    lda port_pot1
    eor #$ff
    and #80
    jsr button

    ; button 3
    lda port_pot2
    eor #$ff
    and #80
    jsr button

end:
    rts
}