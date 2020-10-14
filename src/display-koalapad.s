.autoimport +

.export display_koalapad

.include "joytest.inc"
.macpack utility

buttons_offset = 40 + 11
position_offset = 5 * 40 - 3

sprite_x_offset = 4
sprite_y_offset = 50 + 18

.code

display_koalapad:
	add_word ptr2, buttons_offset

	lda port_digital
	and #$04
	jsr button
	
	lda port_digital
	and #$08	
	jsr button
	
	add_word ptr2, position_offset
	
	lda port_potx
	ldx #1
	jsr pot_number
	
	add_word ptr2, 40
	
	lda port_poty
	ldx #1
	jsr pot_number
	
	ldx port_number

	lda port_poty
	lsr
	lsr
	clc
	adc #sprite_y_offset
	sta sprite_y

	lda port_potx
	lsr
	lsr
	clc
	adc #sprite_x_offset
	adc port_x_offset,x
	sta sprite_x
	lda #0
	adc #0
	sta sprite_x + 1

	txa
	asl
	jsr set_sprite	
	
	rts
