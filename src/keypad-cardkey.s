.section code

read_cardkey {
    jsr extra_read_pots
    tya
    and #$80
    bne :+
    lda #$ff
    bne end
:   lda #$ff
    sta CIA1_DDRA
    sta CIA1_DDRB
    sta CIA1_PRA
    lda CIA1_PRB
    and #$0f
    tax
    lda cardkey_keycodes,x
end:    
    sta new_key_index
    rts
}

.section data

; 0  14  Enter
; 1  12  .
; 2   3  *
; 3   7  / 
; 4  11  -
; 5  15  +
; 6   2  9
; 7   1  8
; 8   0  7
; 9   6  6
; a   5  5
; b   4  4
; c  10  3
; d   9  2
; e   8  1
; f  13  0


cardkey_keycodes {
    .data 14, 12,  3,  7,  11, 15,  2,  1
    .data  0,  6,  5,  4,  10,  9,  8, 13
}
