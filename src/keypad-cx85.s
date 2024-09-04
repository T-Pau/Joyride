;  keypad-cx85.s -- Read Atari CX-85 keypad.
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

read_cx85 {
    jsr extra_read_pots
    tya
    and #$80
    bne :+
    lda #$ff
    bne end
:   lda CIA1_PRB
    and #$1f
    tax
    lda cx85_keycodes,x
end:    
    sta new_key_index
    rts
}

.section data


; 0c  0 Escape
; 10 10 Delete
; 11  6 4
; 12  7 5
; 13  8 6
; 14  5 No
; 15  1 7
; 16  2 8
; 17  3 9
; 18 14 Yes
; 19 11 1
; 1a 12 2 
; 1b 13 3
; 1c 15 0
; 1d 16 .
; 1e  9 Enter
; 1f  4 -

cx85_keycodes {
    .data $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .data $ff, $ff, $ff, $ff,  0,  $ff, $ff, $ff
    .data  10,   6,   7,   8,   5,   1,   2,   3
    .data  14,  11,  12,  13,  15,  16,   9,   4
}
