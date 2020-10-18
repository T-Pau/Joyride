.autoimport +

.export help, help_next, help_previous, help_exit, handle_help

.include "joytest.inc"
.macpack utility

.code

help:
	ldx #<help_irq_table
	ldy #>help_irq_table
	lda help_irq_table_length
	jsr set_irq_table

	lda #0
	ldy #7
:	sta VIC_SPR0_X,y
	dey
	bpl :-

	memcpy screen, help_screen, 1000
	memcpy color_ram, help_color, 1000
	ldx #0
	stx current_help_screen
	jsr display_help_screen
	rts

help_next:
	inc current_help_screen
	jmp display_help_screen

help_previous:
	dec current_help_screen
	jmp display_help_screen

help_exit:
	; TODO
	rts

handle_help:
	jsr label_background
	; TODO: read keyboard, give commands
	rts
