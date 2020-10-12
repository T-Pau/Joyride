; copy dpad for value in A to ptr2

.autoimport +

.export dpad

.include "joytest.inc"

.rodata

dpad_rects:
	.repeat 16, i
	.word dpad_rect_data + i * 25
	.endrep

dpad_rect_data:
	; 0: none
	.byte $20, $41, $48, $42, $20
	.byte $41, $64, $62, $66, $42
	.byte $45, $60, $6c, $61, $46
	.byte $43, $68, $63, $6a, $44
	.byte $20, $43, $47, $44, $20

	; 1: up
	.byte $20, $c1, $c8, $c2, $20
	.byte $41, $65, $e2, $67, $42
	.byte $45, $60, $6d, $61, $46
	.byte $43, $68, $63, $6a, $44
	.byte $20, $43, $47, $44, $20

	; 2: down
	.byte $20, $41, $48, $42, $20
	.byte $41, $64, $62, $66, $42
	.byte $45, $60, $6f, $61, $46
	.byte $43, $69, $e3, $eb, $44
	.byte $20, $c3, $c7, $c4, $20

	; 3 up down
	.byte $20, $c1, $c8, $c2, $20
	.byte $41, $65, $e2, $67, $42
	.byte $45, $60, $71, $61, $46
	.byte $43, $69, $e3, $eb, $44
	.byte $20, $c3, $c7, $c4, $20

	; 4: left
	.byte $20, $41, $48, $42, $20
	.byte $c1, $e5, $62, $66, $42
	.byte $c5, $e0, $70, $61, $46
	.byte $c3, $e9, $63, $6a, $44
	.byte $20, $43, $47, $44, $20

	; 5: up left
	.byte $20, $c1, $c8, $c2, $20
	.byte $c1, $e4, $e2, $67, $42
	.byte $c5, $e0, $73, $61, $46
	.byte $c3, $e9, $63, $6a, $44
	.byte $20, $43, $47, $44, $20

	; 6: down left
	.byte $20, $41, $48, $42, $20
	.byte $c1, $e5, $62, $66, $42
	.byte $c5, $e0, $f2, $61, $46
	.byte $c3, $e8, $e3, $eb, $44
	.byte $20, $c3, $c7, $c4, $20

	; 7: up down left
	.byte $20, $c1, $c8, $c2, $20
	.byte $c1, $e4, $e2, $67, $42
	.byte $c5, $e0, $ee, $61, $46
	.byte $c3, $e8, $e3, $eb, $44
	.byte $20, $c3, $c7, $c4, $20

	; 8: right
	.byte $20, $41, $48, $42, $20
	.byte $41, $64, $62, $e7, $c2
	.byte $45, $60, $6e, $e1, $c6
	.byte $43, $68, $63, $6b, $c4
	.byte $20, $43, $47, $44, $20

	; 9: up right
	.byte $20, $c1, $c8, $c2, $20
	.byte $41, $65, $e2, $e6, $c2
	.byte $45, $60, $72, $e1, $c6
	.byte $43, $68, $63, $6b, $c4
	.byte $20, $43, $47, $44, $20

	; a: down right
	.byte $20, $41, $48, $42, $20
	.byte $41, $64, $62, $e7, $c2
	.byte $45, $60, $f3, $e1, $c6
	.byte $43, $69, $e3, $ea, $c4
	.byte $20, $c3, $c7, $c4, $20

	; b: up down right
	.byte $20, $c1, $c8, $c2, $20
	.byte $41, $65, $e2, $e6, $c2
	.byte $45, $60, $f0, $e1, $c6
	.byte $43, $69, $e3, $ea, $c4
	.byte $20, $c3, $c7, $c4, $20

	; c: left right
	.byte $20, $41, $48, $42, $20
	.byte $c1, $e5, $62, $e7, $c2
	.byte $c5, $e0, $f1, $e1, $c6
	.byte $c3, $e9, $63, $6b, $c4
	.byte $20, $43, $47, $44, $20

	; d: up left right
	.byte $20, $c1, $c8, $c2, $20
	.byte $c1, $e4, $e2, $e6, $c2
	.byte $c5, $e0, $ef, $e1, $c6
	.byte $c3, $e9, $63, $6b, $c4
	.byte $20, $43, $47, $44, $20

	; e: down left right
	.byte $20, $41, $48, $42, $20
	.byte $c1, $e5, $62, $e7, $c2
	.byte $c5, $e0, $ed, $e1, $c6
	.byte $c3, $e8, $e3, $ea, $c4
	.byte $20, $c3, $c7, $c4, $20

	; f: all
	.byte $20, $c1, $c8, $c2, $20
	.byte $c1, $e4, $e2, $e6, $c2
	.byte $c5, $e0, $a0, $e1, $c6
	.byte $c3, $e8, $e3, $ea, $c4
	.byte $20, $c3, $c7, $c4, $20

.code

dpad:
	asl
	tax
	lda dpad_rects,x
	sta ptr1
	lda dpad_rects + 1,x
	sta ptr1 + 1
	ldx #5
	ldy #5
	jmp copyrect
