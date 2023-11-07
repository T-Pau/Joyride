.autoimport +

.include "joyride.inc"

.macpack generic

.export multijoy_top
multijoy_top:
.scope
    lda #$0f
    sta CIA1_DDRB
    lda #$00
    sta CIA1_DDRA
    ldx #0
    lda eight_player_page
    asl
    asl
    tay
loop:
    sta CIA1_PRB
    lda CIA1_PRA
	and #$1f
	eor #$1f
	sta snes_buttons,y
    iny
    tya
    inx
    cpx #4
    blt loop
    rts
.endscope

; TODO: merge with multijoy_top
.export protovision_multijoy_top
protovision_multijoy_top:
.scope
    lda #$0f
    sta CIA1_DDRA
    lda #$00
    sta CIA1_DDRB
    ldx #0
    lda eight_player_page
    asl
    asl
    tay
loop:
    sta CIA1_PRA
    lda CIA1_PRB
	and #$1f
	eor #$1f
	sta snes_buttons,y
    iny
    tya
    inx
    cpx #4
    blt loop
    rts
.endscope
