;  mouse-cx22.s -- Support for Atari CX-22 trackball.
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

CX22_F_OFFSET = 40 + 12

.section code

sample_cx22 {
    lda CIA1_PRB
    tax

    and #$03
    ora neos_diff
    tay
    lda cx22_diff,y
    clc
    adc neos_position
    sta neos_position

    txa
    lsr
    lsr
    and #$03
    ora neos_diff + 1
    tay
    lda cx22_diff,y
    clc
    adc neos_position + 1
    sta neos_position + 1

    txa
    and #$03
    asl
    asl
    sta neos_diff
    txa 
    and #$0c
    sta neos_diff + 1
    
    rts
}

sample_cx22_joystick {
    lda CIA1_PRB
    tax
    eor cx22_joystick_last
    stx cx22_joystick_last
    tax

    and #$01
    beq :+
    inc neos_position + 1
:   txa
    and #$02
    beq :+
    dec neos_position + 1
:   txa
    and #$04
    beq :+
    dec neos_position
:   txa
    and #$08
    beq :+
    inc neos_position
:   rts    
}

display_cx22 {
    store_word destination_ptr, EXTRA_VIEW_START + CX22_F_OFFSET
    lda neos_button_l
    jsr small_button
    jmp display_extra_mouse
}


.section data

cx22_diff {
    ;      %00, %01, %10, %11
    .data  $00, $00, $ff, $00 ; 00
    .data  $00, $00, $00, $01 ; 01
    .data  $ff, $00, $00, $00 ; 10
    .data  $00, $01, $00, $00 ; 11
}

.section reserved

cx22_joystick_last .reserve 1