.autoimport +

.export display_paddle1, display_paddle2

.include "joytest.inc"

button_position = screen + 3 * 40 + 8
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
	clc
	lda #<button_position
	cpx #2
	bne :+
	adc #19
:	sta ptr2
	lda #>button_position
	adc #0
	sta ptr2 + 1
	
	lda port_digital
	lsr
	lsr
	and #$03
	ldx paddle
	beq :+
	lsr
:	and #1
	jsr button
	
	clc
	lda ptr2
	adc #<value_offset
	sta ptr2
	lda ptr2 + 1
	adc #>value_offset
	sta ptr2 + 1
	
	lda port_potx
	ldx paddle
	beq :+
	lda port_poty
:	ldx #1
	jsr pot_number 
	
	rts
