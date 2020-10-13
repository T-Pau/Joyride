.autoimport +

.export display_raw

.include "joytest.inc"
.macpack utility

bit0_position = 1
potx_offset = 40 * 4 - 12
poty_offset = 8
.code

display_raw:
	add_word ptr2, bit0_position
	
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

	add_word ptr2, potx_offset
	lda port_potx
	ldx #1
	jsr pot_number
	
	add_word ptr2, poty_offset
	lda port_poty
	ldx #1
	jsr pot_number

	; TODO: pot sprites
	
	rts
