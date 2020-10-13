.autoimport +

.export display_mouse

.include "joytest.inc"

buttons_position = screen + 40 * 2 + 11
wheel_offset = 2
position_offset = 40 * 2 + 6 ; negative
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
	adc #19
:	sta ptr2
	lda #>buttons_position
	adc #0
	sta ptr2 + 1
	ldx #7
	ldy #3
	jsr copyrect
	
	clc
	lda ptr2
	adc #<wheel_offset
	sta ptr2
	lda ptr2 + 1
	adc #>wheel_offset
	sta ptr2 + 1
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
	
	sec
	lda ptr2
	sbc #<position_offset
	sta ptr2
	lda ptr2 + 1
	sbc #>position_offset
	sta ptr2 + 1
	lda port_potx
	cmp #$7f
	bne :+
	lda #$80
:	lsr
	and #$3f
	ldx #0
	jsr pot_number
	
	clc
	lda ptr2
	adc #40
	sta ptr2
	lda ptr2 + 1
	adc #0
	sta ptr2 + 1
	lda port_poty
	cmp #$7f
	bne :+
	lda #$80
:	lsr
	and #$3f
	ldx #0
	jsr pot_number
	
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
