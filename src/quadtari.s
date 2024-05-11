screen = $400

.section code

.public start {
    sei
    ldx #0
    lda #$20
:   sta screen,x
    sta screen + $100,x
    sta screen + $200,x
    sta screen + $300,x
    dex
    bne :-

    lda #<screen
    sta ptr2
    lda #>screen
    sta ptr2 + 1

    lda #$c0
    sta CIA1_DDRA
    lda #$00
    sta CIA1_PRA
    sta CIA1_DDRB
loop:
    ldx #0
    jsr read
    jsr switch
    jsr read
    jsr display
    jmp loop
}

switch {
    lda #$c0
    sta CIA1_PRA
    ldy #0
:   dey
    nop
    nop
    nop
    bne :-
    ldy #200
:   dey
    bne :-
    lda #$00
    sta CIA1_PRA
    ldy VIC_RASTER
    iny
    iny
:   cpy VIC_RASTER
    bne :-
    rts
}

read {
    lda CIA1_PRB
    and #$1f
    eor #$1f
    sta joysticks,x
    lda CIA1_PRA
    and #$1f
    eor #$1f
    sta joysticks + 2,x
    inx
    rts
}

display {
    ldy #0
    ldx #0

:   lda joysticks,x
    stx index
    jsr hex
    iny
    ldx index
    inx
    cpx #4
    bcc :-
    rts
}

.section zero_page

ptr2 .reserve 2

.section reserved

joysticks .reserve 4
index .reserve 1