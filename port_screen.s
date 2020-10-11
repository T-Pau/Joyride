; copy screen for type X to port Y

.autoimport +
.export copy_port_screen

.include "joytest.inc"

.macpack cbm
.macpack cbm_ext

name_address = screen + 9

.bss

type:
	.res 1

.code

copy_port_screen:
	lda #<name_address
	cpy #2
	bne port1
	clc
	adc #20
port1:
	sta ptr2
	lda #>name_address
	sta ptr2 + 1

	txa
	asl
	sta type
	asl
	asl
	asl
	clc
	adc #<port_names
	sta ptr1
	lda #0
	adc #>port_names
	sta ptr1 + 1

	ldy #8
loop:
	lda (ptr1),y
	sta (ptr2),y
	dey
	bpl loop

	clc
	lda #72
	adc ptr2
	sta ptr2
	ldx type
	lda port_screens,x
	sta ptr1
	lda port_screens + 1,x
	sta ptr1 + 1
	ldx #17
	ldy #9
	jmp copyrect

.rodata

port_names:
	invcode "joystick        "
	invcode "mouse           "
	invcode "paddle 1        "
	invcode "paddle 2        "
	invcode "koalapad        "
	invcode "raw             "

port_screens:
	.repeat 6, i
	.word port_screen_data + i * 17 * 9
	.endrep

port_screen_data:
	; 0: joystick
	scrcode "                 "
	scrcode "                 "
	scrcode "                 "
	scrcode "       AHBAHBAHB "
	scrcode "       E1FE2FE3F "
	scrcode "       CGDCGDCGD "
	scrcode "                 "
	scrcode "                 "
	scrcode "                 "
