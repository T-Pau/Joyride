.section code

read_coplin {
    lda #$ff
    sta CIA1_DDRA
    sta CIA1_DDRB
    sta CIA1_PRA
    lda CIA1_PRB
    and #$1f
    tax
    lda coplin_keycodes,x
    sta new_key_index
    rts
}

.section data


coplin_keycodes {
    .data $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .data $ff, $ff, $ff, $ff, $ff, $ff, $ff, 11
    .data $ff, 9,   10,  4,   $ff, 8,   2,   5
    .data $ff, 6,   0,   3,   $ff, 7,   1,   $ff
}
