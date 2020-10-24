;  port-screen.s -- Display basic layout of various controller screens.
;  Copyright (C) 2020 Dieter Baron
;
;  This file is part of Joyride, a controller test program for C64.
;  The authors can be contacted at <joyride@tpau.group>.
;
;  Redistribution and use in source and binary forms, with or without
;  modification, are permitted provided that the following conditions
;  are met:
;  1. Redistributions of source code must retain the above copyright
;     notice, this list of conditions and the following disclaimer.
;  2. The names of the authors may not be used to endorse or promote
;     products derived from this software without specific prior
;     written permission.
;
;  THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS
;  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;  ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
;  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
;  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
;  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
;  IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


; copy screen for port Y

.autoimport +
.export copy_port_screen, port_x_offset

.include "joyride.inc"

.macpack cbm
.macpack cbm_ext

name_address = screen + 9

.bss

type_times_2:
	.res 1

port:
	.res 1
	
.rodata

port_x_offset:
	.byte 32, 32 + 20 * 8

.code

copy_port_screen:
	sty port
	ldx port1_type,y
	
	lda #<name_address
	cpy #1
	bne port0
	clc
	adc #20
port0:
	sta ptr2
	lda #>name_address
	sta ptr2 + 1

	txa
	asl
	sta type_times_2
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
	ldx type_times_2
	lda port_screens,x
	sta ptr1
	lda port_screens + 1,x
	sta ptr1 + 1
	ldx #17
	ldy #9
	jsr copyrect
	
	; set correct sprite pointers
	lda port
	asl
	tay
	ldx type_times_2
	lda port_sprite,x
	sta screen + $3f8,y
	lda port_sprite + 1,x
	sta screen + $3f9,y
	
	rts
	
.rodata

port_sprite:
	.byte sprite_none, sprite_none
	.byte sprite_cross, sprite_none
	.byte sprite_bar, sprite_none
	.byte sprite_bar, sprite_none
	.byte sprite_cross, sprite_none
	.byte sprite_bar, sprite_bar

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

	; 1: mouse
	scrcode "RHHHHHHHS        "
	scrcode "V       W        "
	scrcode "V       W        "
	scrcode "V       W        "
	scrcode "V       W        "
	scrcode "V       W        "
	scrcode "V   x:  W        "
	scrcode "V   y:  W        "
	scrcode "TXXXXXXXU        "

	; 2: paddle 1
	scrcode "                 "
	scrcode "       AHB       "
	scrcode "       EfF       "
	scrcode "       CGD       "
	scrcode "RNNNONNNONNNONNNS"
	scrcode "TPPPQPPPQPPPQPPPU"
	scrcode "   value:        "
	scrcode "                 "
	scrcode "                 "

	; 3: paddle 2
	scrcode "                 "
	scrcode "       AHB       "
	scrcode "       EfF       "
	scrcode "       CGD       "
	scrcode "RNNNONNNONNNONNNS"
	scrcode "TPPPQPPPQPPPQPPPU"
	scrcode "   value:        "
	scrcode "                 "
	scrcode "                 "

	; 4: koalapad
	scrcode "RHHHHHHHS        "
	scrcode "V       W  AHBAHB"
	scrcode "V       W  ElFErF"
	scrcode "V       W  CGDCGD"
	scrcode "V       W        "
	scrcode "V       W        "
	scrcode "V       W   x:   "
	scrcode "V       W   y:   "
	scrcode "TXXXXXXXU        "

	; 5: raw
	scrcode " AHBAHBAHBAHBAHB "
	scrcode " E0FE1FE2FE3FE4F "
	scrcode " CGDCGDCGDCGDCGD "
	scrcode "                 "
	scrcode "  x:      y:     "
	scrcode "RNNNONNNONNNONNNS"
	scrcode "TPPPQPPPQPPPQPPPU"
	scrcode "RNNNONNNONNNONNNS"
	scrcode "TPPPQPPPQPPPQPPPU"
