;  mouse-joystick.s -- Support for Joystick Mouse.
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

MOUSE_JOYSTICK_STEP = $8

.macro mouse_joystick_step_up axis {
    clc
    lda mouse_joystick_fraction + axis
    adc #MOUSE_JOYSTICK_STEP
    sta mouse_joystick_fraction + axis
    bcc :+
    inc neos_position + axis
:
}

.macro mouse_joystick_step_down axis {
    sec
    lda mouse_joystick_fraction + axis
    sbc #MOUSE_JOYSTICK_STEP
    sta mouse_joystick_fraction + axis
    bcs :+
    dec neos_position + axis
:
}

.section code

read_mouse_joystick {
    jsr extra_read_pots
    and #$80
    eor #$80
    sta neos_button_r
    lda CIA1_PRB
    eor #$ff
    and #$10
    sta neos_button_l
    rts
}

sample_mouse_joystick {
    lda VIC_RASTER
:   cmp VIC_RASTER
    beq :-
    lda CIA1_PRB
    eor #$0f
    tax

    and #$01
    beq :+
    mouse_joystick_step_down 1
:   txa
    and #$02
    beq :+
    mouse_joystick_step_up 1
:   txa
    and #$04
    beq :+
    mouse_joystick_step_down 0
:   txa
    and #$08
    beq :+
    mouse_joystick_step_up 0
:   rts    
}


.section reserved

mouse_joystick_fraction .reserve 2
