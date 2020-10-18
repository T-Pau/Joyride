.autoimport +
.export start, display_main_screen

.include "joytest.inc"

.macpack cbm_ext
.macpack utility

.code

start:
	lda #12; COLOR_GREY2
	sta VIC_BORDERCOLOR

	memcpy charset, charset_data, $800
	memcpy sprites, cursor, 64 * 3

	ldx #0
	stx port1_type
	stx port2_type
	stx userport_type
	jsr display_main_screen

	set_vic_bank $4000
	set_vic_text screen, charset
		
	lda #$0f
	sta VIC_SPR_ENA
	lda #0
	sta VIC_SPR_BG_PRIO
	sta VIC_SPR_EXP_X
	sta VIC_SPR_EXP_Y
	sta VIC_SPR_MCOLOR
	
	lda #COLOR_WHITE
	sta VIC_SPR0_COLOR
	sta VIC_SPR1_COLOR
	sta VIC_SPR2_COLOR
	sta VIC_SPR3_COLOR

	jsr init_irq

	; set up serial loopback for userport adapters
	lda #0
	sta CIA2_DDRB
	lda #1
	sta CIA1_TA
	sta CIA2_TA
	lda #0
	sta CIA1_TA + 1
	sta CIA2_TA + 1
	lda #%00010001
	sta CIA2_CRA
	lda #%01010001
	sta CIA1_CRA

	jmp main_loop

display_main_screen:
	ldx #<main_irq_table
	ldy #>main_irq_table
	lda main_irq_table_length
	jsr set_irq_table
	memcpy screen, main_screen, 1000
	memcpy color_ram, main_color, 1000
	ldy #1
	jsr copy_port_screen
	ldy #2
	jsr copy_port_screen
	jsr copy_userport
	rts