;  display-mouse.s -- Display state of mouse.
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


.autoimport +

.export display_mouse

.include "joyride.inc"
.macpack utility

buttons_offset = 10
wheel_offset = 2
position_offset = 40 * 2 + 6 ; negative

sprite_x_offset = 2
sprite_y_offset = 50 + 18

.bss

tmp:
	.res 1
	
.code

display_mouse:
	lda port_digital
	and #$03
	asl
	sta tmp
	lda port_digital
	and #$10
	lsr
	ora tmp
	tay
	lda button_rects,y
	sta ptr1
	lda button_rects + 1,y
	sta ptr1 + 1
	add_word ptr2, buttons_offset
	ldx #7
	ldy #3
	jsr copyrect
	
	add_word ptr2, wheel_offset
	lda port_digital
	and #$0c
	lsr
	tay
	lda wheel_rects,y
	sta ptr1
	lda wheel_rects + 1,y
	sta ptr1 + 1
	ldx #3
	ldy #5
	jsr copyrect
	
	subtract_word ptr2, position_offset
	lda port_potx
	cmp #$7f
	bne :+
	lda #$80
:	lsr
	and #$3f
	sta sprite_x
	ldx #0
	jsr pot_number
	
	add_word ptr2, 40
	lda port_poty
	cmp #$7f
	bne :+
	lda #$80
:	lsr
	and #$3f
	eor #$3f
	sta sprite_y
	ldx #0
	jsr pot_number
	
	ldx port_number
	clc
	lda sprite_x
	adc #sprite_x_offset
	adc port_x_offset,x
	sta sprite_x
	lda #0
	adc #0
	sta sprite_x + 1

	lda sprite_y
	adc #sprite_y_offset
	sta sprite_y

	txa
	asl
	jsr set_sprite
		
	rts

.rodata

button_rects:
	.repeat 8, i
	.word buttons_data + i * 21
	.endrep

wheel_rects:
	.repeat 8, i
	.word wheel_data + i * 15
	.endrep

buttons_data:
	; 0: none
	.byte $41, $48, $74, $48, $79, $48, $42
	.byte $45, $0c, $56, $0d, $57, $12, $46
 	.byte $43, $47, $75, $47, $7a, $47, $44

	; 1: right
	.byte $41, $48, $74, $48, $fb, $c8, $c2
	.byte $45, $0c, $56, $0d, $f4, $92, $c6
 	.byte $43, $47, $75, $47, $fa, $c7, $c4
	
	; 2: middle
	.byte $41, $48, $7c, $c8, $fd, $48, $42
	.byte $45, $0c, $c5, $8d, $c6, $12, $46
 	.byte $43, $47, $7e, $c7, $fc, $47, $44
	
	; 3: middle right
	.byte $41, $48, $7c, $c8, $c8, $c8, $c2
	.byte $45, $0c, $c5, $8d, $a0, $92, $c6
 	.byte $43, $47, $7e, $c7, $c7, $c7, $c4
	
	; 4: left
	.byte $c1, $c8, $7b, $48, $79, $48, $42
	.byte $c5, $8c, $f9, $0d, $57, $12, $46
 	.byte $c3, $c7, $7d, $47, $7a, $47, $44
	
	; 5: left right
	.byte $c1, $c8, $7b, $48, $fb, $c8, $c2
	.byte $c5, $8c, $f9, $0d, $f4, $92, $c6
 	.byte $c3, $c7, $7d, $47, $fa, $c7, $c4
	
	; 6: left middle
	.byte $c1, $c8, $c8, $c8, $fd, $48, $42
	.byte $c5, $8c, $a0, $8d, $c6, $12, $46
 	.byte $c3, $c7, $c7, $c7, $fc, $47, $44
 		
	; 7: left middle right
	.byte $c1, $c8, $c8, $c8, $c8, $c8, $c2
	.byte $c5, $8c, $a0, $8d, $a0, $92, $c6
 	.byte $c3, $c7, $c7, $c7, $c7, $c7, $c4

wheel_data:
	; 0: none
	.byte $41, $48, $42
	.byte $56, $ce, $57
	.byte $76, $47, $f6
	.byte $45, $d0, $46
	.byte $43, $47, $44
	
	; 1: up
	.byte $c1, $c8, $c2
	.byte $c5, $cf, $c6
	.byte $77, $c7, $78
	.byte $45, $d0, $46
	.byte $43, $47, $44
	
	; 2: down
	.byte $41, $48, $42
	.byte $56, $ce, $57
	.byte $f7, $c8, $f8
	.byte $c5, $d1, $c6
	.byte $c3, $c7, $c4
	
	; 3: up down
	.byte $c1, $c8, $c2
	.byte $c5, $cf, $c6
	.byte $c5, $a0, $c6
	.byte $c5, $d1, $c6
	.byte $c3, $c7, $c4
