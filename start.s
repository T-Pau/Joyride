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
	; TODO: set up color ram
	set_vic_bank $4000
	set_vic_text screen, charset

	jsr init_irq
loop:
	jmp loop
