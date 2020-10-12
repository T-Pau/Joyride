.autoimport +

.export display_port

.rodata

display_routines:
	.word display_joystick
	.word display_mouse
	.word none ; paddle 1
	.word none ; paddle 2
	.word none ; koalapad
	.word display_raw

.code

display_port:
	lda port1_type - 1, x
	asl
	tay
	lda display_routines,y
	sta jump + 1
	lda display_routines + 1,y
	sta jump + 2
jump:
	jmp $0000

none:
	rts
