.autoimport +

.export display_paddle1, display_paddle2

.include "joytest.inc"
.macpack utility

button_offset = 40 + 7
value_offset = 5 * 40

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
:	ldx #1
	jsr pot_number 
	
	rts
