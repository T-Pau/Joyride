.section code

read_rushware {
    lda #$ff
    sta CIA1_DDRA
    sta CIA1_DDRB
    sta CIA1_PRA
    lda CIA1_PRB
    tax
    and #$10
    beq :+
    lda #$ff
    bne end
:   txa
    and #$0f
    tax
    lda cardkey_keycodes,x
end:    
    sta new_key_index
    rts
}
