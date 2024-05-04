.section code

.public wheel_of_joy_top {
    lda #$e0
    sta CIA2_DDRB
    ldy #7
loop:
    lda wheel_of_joy_select,y
    sta CIA2_PRB
    lda CIA2_PRB
    and #$1f
    sta snes_buttons,y
    dey
    bpl loop
    rts
}

.section data

wheel_of_joy_select {
    .repeat i, 8 {
        .data (i << 5) | $1f
    }
}
