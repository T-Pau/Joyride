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
	jsr display_logo
	
	lda #$ff
	sta CIA1_PRA
	sta CIA1_PRB
	
	lda CIA1_PRA
	and CIA1_PRB
	cmp #$ff
	bne end
	
	lda #$00
	sta CIA1_DDRB
	
	lda #$80 ^ $ff
	sta CIA1_PRA
	lda CIA1_PRB
	tax
	and #$02
	bne :+
	lda #COMMAND_HELP_EXIT
	bne got_key
:	txa
	and #$10
	bne :+
	lda #COMMAND_HELP_NEXT
	bne got_key
:	lda #$20 ^ $ff
	sta CIA1_PRA
	lda CIA1_PRB
	and #$01
	bne :+
	lda #COMMAND_HELP_NEXT
	bne got_key
:	lda CIA1_PRB
	and #$08
	beq :+
	lda #0
	sta last_command
	beq end	
:	lda #COMMAND_HELP_PREVIOUS	
got_key:
	cmp last_command
	beq end
	sta last_command
	sta command
end:
	lda #$ff
	sta CIA1_DDRB
	rts
