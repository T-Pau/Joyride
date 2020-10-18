.autoimport +
.export display_help_screen, current_help_screen

.include "joytest.inc"

help_screen_start = screen + 80 + 1

num_help_screens = (help_screens_end - help_screen) / 2

.macpack cbm
.macpack cbm_ext

.bss

current_help_screen:
	.res 1

.rodata

help_screens:
	.repeat 1, i
	.word help_screens_data + 37 * 18 * i
	.endrep

help_screens_end:

help_screens_data:
	scrcode "this program displays the current    " ;  1
	scrcode "state of input devices connected to  " ;  2
	scrcode "the control port or a user port      " ;  3
	scrcode "joystick adapter. each supported     " ;  4
	scrcode "device type has its own layout. you  " ;  5
	scrcode "can switch between them with the     " ;  6
	scrcode "function keys. you can also display  " ;  7
	scrcode "the raw data directly.               " ;  8
	scrcode "supported devices:                   " ;  9
	scrcode "- joystick with up to three buttons  " ; 10
	scrcode "- 1531 compatible mouse with up to   " ; 11
	scrcode "  three buttons and scroll wheel     " ; 12
	scrcode "- paddles                            " ; 13
	scrcode "- koalapad                           " ; 14
	scrcode "- protovision / cga 4 player adapter " ; 15
	scrcode "- digital excess / hitmen adapter    " ; 16
	scrcode "- kingsoft adapter                   " ; 17
	scrcode "- starbyte adapter                   " ; 18

.code

display_help_screen:
	lda current_help_screen
	bmi negative
	cmp #<num_help_screens
	bne ok
	lda #0
	beq ok
negative:
	lda #<(num_help_screens - 1)
ok:
	sta current_help_screen
	asl
	tax

	lda help_screens,x
	sta ptr1
	lda help_screens + 1,x
	sta ptr1 + 1
	lda #<help_screen_start
	sta ptr2
	lda #>help_screen_start
	sta ptr2 + 1
	ldx #37
	ldy #18
	jmp copyrect
