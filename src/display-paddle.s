.autoimport +

.export display_paddle1, display_paddle2

.include "joytest.inc"
.macpack utility

button_offset = 40 + 7
value_offset = 5 * 40

sprite_x_offset = 4
sprite_y_offset = 50 + 20 + 4 * 8

.bss

paddle:
	.res 1

.code

display_paddle1:
	lda #0
	sta paddle
	jmp display_paddle

display_paddle2:
	lda #1
	sta paddle
	jmp display_paddle

display_paddle:
	add_word ptr2, button_offset
	lda port_digital
	lsr
	lsr
	and #$03
	ldx paddle
	beq :+
	lsr
:	and #1
	jsr button
	
	add_word ptr2, value_offset
	lda port_potx
	ldx paddle
	beq :+
	lda port_poty
:	sta sprite_x
	ldx #1
	jsr pot_number 
	
	ldx port_number
	lda #$ff
	sec
	sbc sprite_x
	lsr
	clc
	adc #sprite_x_offset
	adc port_x_offset,x
	sta sprite_x
	lda #0
	adc #0
	sta sprite_x + 1

	lda #sprite_y_offset
	sta sprite_y

	txa
	asl
	jsr set_sprite	
	rts
