.section code

read_cx85 {
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
