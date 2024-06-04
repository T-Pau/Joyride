;  mouse-st.s -- Support for Atari ST mouse.
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

read_st {
    lda CIA1_PRB
    eor #$ff
    and #$10
    sta neos_button_l
    lda #0
    sta neos_button_r
    rts
}

sample_st {
    lda CIA1_PRB
    tax

    and #$03
    ora neos_diff
    tay
    lda st_diff,y
    clc
    adc neos_position
    sta neos_position

    txa
    lsr
    lsr
    and #$03
    ora neos_diff + 1
    tay
    lda st_diff,y
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

.section data

; 00 -> 01 -> 11 -> 10
st_diff {
    ;      %00, %01, %10, %11
    .data  $00, $ff, $01, $00 ; 00
    .data  $01, $00, $00, $ff ; 01
    .data  $ff, $00, $00, $01 ; 10
    .data  $00, $01, $ff, $00 ; 11
}