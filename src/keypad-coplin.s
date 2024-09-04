;  keypad-coplin.s -- Read Coplin keypad.
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

read_coplin {
    lda CIA1_PRB
    tay
    and #$f
    tax
    lda coplin_keycodes,x
    sta new_key_index
    tya 
    and #$10
    eor #$10
    sta new_key_state
    rts
}

display_coplin {
    lda new_key_state
    cmp key_state
    beq :+
    sta key_state
    ldx #11
    jsr display_key
:   jmp display_single_key
}

.section data

; 0f 11  Enter

; 1  9  0
; 2 10  .
; 3  4  5
; 5  8  3
; 6  2  9
; 7  5  6
; 9  6  1
; a  0  7
; b  3  4
; d  7  2
; e  1  8

coplin_keycodes {
    .data $ff, 9,   10,  4,   $ff, 8,   2,   5
    .data $ff, 6,   0,   3,   $ff, 7,   1,   $ff
}
