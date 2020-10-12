.autoimport +

.export display_raw

.include "joytest.inc"

bit0_position = screen + 40 * 2 + 2
potx_offset = 40 * 4 - 12
poty_offset = 8
.code

display_raw:
	clc
	lda #<bit0_position
	cpx #2
	bne :+
	adc #20
:	sta ptr2
	lda #>bit0_position
	sta ptr2 + 1
	
	lda port_digital
	and #$01
	jsr button
	
	lda port_digital
	and #$02
	jsr button

	lda port_digital
	and #$04
	jsr button

	lda port_digital
	and #$08
	jsr button

	lda port_digital
	and #$10
	jsr button

	clc
	lda ptr2
	adc #<potx_offset
	sta ptr2
	lda ptr2 + 1
	adc #>potx_offset
	sta ptr2 + 1
	lda port_potx
	ldx #1
	jsr pot_number
	
	clc
	lda ptr2
	adc #<poty_offset
	sta ptr2
	lda ptr2 + 1
	adc #>poty_offset
	sta ptr2 + 1
	lda port_poty
	ldx #1
	jsr pot_number

	; TODO: pot sprites
	
	rts
