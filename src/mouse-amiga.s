;  mouse-amiga.s -- Support for Amiga mouse.
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

sample_amiga {
    lda CIA1_PRB
    tax

    lsr
    and #$05
    ora neos_diff
    tay
    lda amiga_diff,y
    clc
    adc neos_position
    sta neos_position

    txa
    and #$05
    ora neos_diff + 1
    tay
    lda amiga_diff,y
    clc
    adc neos_position + 1
    sta neos_position + 1

    txa
    and #$0a
    sta neos_diff
    txa 
    and #$05
    asl
    sta neos_diff + 1
    
    rts
}

.section data

; 00 -> 01 -> 11 -> 10

amiga_diff {
    ;      %00, %01, %10, %11
    .data  $00, $01, $ff, $00 ; 00
    .data  $ff, $00, $00, $01 ; 01
    .data  $01, $00, $00, $ff ; 10
    .data  $00, $ff, $01, $00 ; 11
}