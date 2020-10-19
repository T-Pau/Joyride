.export label_background, content_background, logo_background

.include "joytest.inc"

.code

label_background:
	nop
	nop
	nop
	nop
	lda #COLOR_BLACK
	sta VIC_BG_COLOR0
	rts

content_background:
	lda #COLOR_GRAY3
	sta VIC_BG_COLOR0
	rts

logo_background:
	lda #COLOR_GRAY1
	sta VIC_BG_COLOR0
	rts

