.autoimport +
.export start

.include "joytest.inc"

.macpack cbm_ext
.macpack utility

.code

start:
	lda #12 ; COLOR_GREY2
	sta VIC_BORDERCOLOR

	memcpy charset, charset_data, $2000
	memcpy screen, main_screen, 1000
	memcpy color_ram, main_color, 1000
	
	ldx #0
	stx port1_type
	stx port2_type
	stx userport_type
	
	ldx #0
	ldy #1
	jsr copy_port_screen
	ldx #0
	ldy #2
	jsr copy_port_screen
	set_vic_bank $4000
	set_vic_text screen, charset

	jsr init_irq

	jmp main_loop
