.autoimport +

.export display_raw

.include "joytest.inc"
.macpack utility

bit0_position = 1
potx_offset = 40 * 4 - 12
poty_offset = 8

sprite_x_offset = 4
sprite0_y_offset = 50 + 20 + 5 * 8
sprite1_y_offset = sprite0_y_offset + 16
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

	ldx port_number
	lda port_potx
	lsr
	clc
	adc #sprite_x_offset
	adc port_x_offset,x
	sta sprite_x
	lda #0
	adc #0
	sta sprite_x + 1
	lda #sprite0_y_offset
	sta sprite_y
	txa
	asl
	jsr set_sprite
	
	ldx port_number
	lda port_poty
	lsr
	clc
	adc #sprite_x_offset
	adc port_x_offset,x
	sta sprite_x
	lda #0
	adc #0
	sta sprite_x + 1
	lda #sprite1_y_offset
	sta sprite_y
	txa
	asl
	clc
	adc #1
	jsr set_sprite
	
	rts
