.autoimport +

.export display_koalapad

.include "joytest.inc"

buttons_position = screen + 3 * 40 + 12
position_offset = 5 * 40 - 3

.code

display_koalapad:
	clc
	lda #<buttons_position
	cpx #2
	bne :+
	adc #19
:	sta ptr2
	lda #>buttons_position
	adc #0
	sta ptr2 + 1

	lda port_digital
	and #$04
	jsr button
	
	lda port_digital
	and #$08	
	jsr button
	
	clc
	lda ptr2
	adc #<position_offset
	sta ptr2
	lda ptr2 + 1
	adc #>position_offset
	sta ptr2 + 1
	
	lda port_potx
	ldx #1
	jsr pot_number
	
	clc
	lda ptr2
	adc #40
	sta ptr2
	lda ptr2 + 1
	adc #0
	sta ptr2 + 1
	
	lda port_poty
	ldx #1
	jsr pot_number

	rts
