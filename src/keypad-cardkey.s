;  keypad-cardkey.s -- Read Cardco Cardkey 1 keypad.
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

read_cardkey {
:   lda #$ff
    sta CIA1_DDRA
    sta CIA1_PRA
    lda #$c0
    sta CIA1_DDRB
:   lda CIA1_PRB
    cmp CIA1_PRB
    bne :-
    cmp CIA1_PRB
    bne :-
    eor #$ff
    tay
    and #$10
    bne :+
    lda #$ff
    bne end
:   tya
    and #$0f
    tax
    lda cardkey_keycodes,x
end:    
    sta new_key_index
    rts
}

.section data

; 0 13  0
; 1  8  1
; 2  9  2
; 3 10  3
; 4  4  4
; 5  5  5
; 6  6  6
; 7  0  7
; 8  1  8
; 9  2  9
; a 15  +
; b 11  -
; c  7  /
; d  3  *
; e 12  .
; f 14  Enter

cardkey_keycodes {
    .data 13,  8,  9, 10,  4,  5,  6,  0
    .data  1,  2, 15, 11,  7,  3, 12, 14
}
