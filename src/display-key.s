;  display_key.s -- Display current_key_state of key
;  Copyright (C) Dieter Baron
;
;  This file is part of Anykey, a keyboard test program for C64.
;  The authors can be contacted at <anykey@tpau.group>.
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

.include "features.inc"

.section reserved

.public num_keys .reserve 1
.public current_key_state .reserve 1
.public current_key_color .reserve 1

.public new_key_state .reserve MAX_NUM_KEYS
.public key_state .reserve MAX_NUM_KEYS

.section code

; Display keyboard
.public display_keyboard {
;    inc VIDEO_BORDER_COLOR
    ldx #0
loop:
    .if .defined(USE_SKIP) {
        lda skip_key,x
        bne next
    }
    lda new_key_state,x
    and #$06
    beq :+
    lda #$02
    sta new_key_state,x
:	cmp key_state,x
    beq next
    sta key_state,x
    jsr display_key
next:
    inx
    cpx num_keys
    bne loop
    ldx #0
;    dec VIDEO_BORDER_COLOR
    rts
}

; Set keys table and reset key state.
; Parameters:
;   X/Y: address of table
;   A: number of keys
.public set_keys_table {
    sta num_keys
    stx address_low
    sty address_low + 1
    
    clc
    txa
    adc num_keys
    sta address_high
    lda address_low + 1
    adc #0
    sta address_high + 1
    
    lda address_high
    adc num_keys
    sta display_low
    lda address_high + 1
    adc #0
    sta display_low + 1
    
    lda display_low
    adc num_keys
    sta display_high
    lda display_low + 1
    adc #0
    sta display_high + 1

    ldx num_keys
    beq end
    lda #0
:   dex
    sta key_state,x
    bne :-
end:
    rts
}


; Display key
; Parameters:
;   A: non-zero if pressed
;   X: key index
; Preserves: X
.public display_key {
    .private address_low = address_low_instruction + 1
    .private address_high = address_high_instruction + 1
    .private display_low = display_low_instruction + 1
    .private display_high = display_high_instruction + 1
    .private jump = jump_instruction + 1

    .if  !.defined(USE_PET) {
        ldy #COLOR_CHECKED
    }
    cmp #0
    beq :+
    .if  !.defined(USE_PET) {
        ldy #COLOR_PRESSED
    }
    lda #$80
:	sta current_key_state
    .if  !.defined(USE_PET) {
        sty current_key_color
    }

address_low_instruction:
    lda $1000,x
    sta ptr1
address_high_instruction:
    lda $1000,x
    sta ptr1 + 1
display_low_instruction:
    lda $1000,x
    sta jump
display_high_instruction:
    lda $1000,x
    sta jump + 1
    ldy #0
    .if .defined(USE_PET) {
        stx restore + 1
        ldx current_key_state
        beq jump
        ldx #1
    jump_instruction:
        jsr $1000
    restore:
        ldx #$00
        rts
    }
    .else {
    jump_instruction:
        jmp $1000
    }
}