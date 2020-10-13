.autoimport +

.export display_mouse

.include "joytest.inc"

buttons_position = screen + 40 * 2 + 11

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
	clc
	lda #<buttons_position
	cpx #2
	bne :+
	adc #20
:	sta ptr2
	lda #>buttons_position
	adc #0
	sta ptr2 + 1
	ldx #7
	ldy #3
	jsr copyrect

.rodata

button_rects:
	.repeat 8, i
	.word buttons_data + i * 21
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
	