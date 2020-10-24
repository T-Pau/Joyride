.autoimport +
.export display_help_screen, current_help_screen

.include "joytest.inc"

help_screen_start = screen + 1

help_screen_size = 37 * 20
num_help_screens = 7

.macpack cbm
.macpack cbm_ext

.bss

current_help_screen:
	.res 1

.rodata

help_screens:
	.repeat num_help_screens, i
	.word help_screens_data + help_screen_size * i
	.endrep

help_screens_data:
	invcode "joyride                              "
	scrcode "                                     "
	scrcode "this program monitors the controllers" ;  1
	scrcode "connected to your c64 and displays   " ;  2
	scrcode "relevant information depending on    " ;  3
	scrcode "their types. you can use the function" ;  4
	scrcode "keys to select the correct type or to" ;  5
	scrcode "display raw data.                    " ;  6
	scrcode "                                     " ;  7
	scrcode "supported are:                       " ;  8
	scrcode "- joystick                           " ;  9
	scrcode "- mouse                              " ; 10
	scrcode "- paddle                             " ; 11
	scrcode "- koalapad                           " ; 12
	scrcode "- userport joystick adapter          " ; 13
	scrcode "                                     " ; 14
	scrcode "for digital inputs, the button or    " ; 15
	scrcode "direction is inverted when pressed.  " ; 16
	scrcode "analog inputs are displayed as       " ; 17
	scrcode "numbers and by positioning a pointer." ; 18

	invcode "joystick                             "
	scrcode "                                     "
	scrcode "joysticks contain a stick or d-pad   " ;  1
	scrcode "with switches for the four cardinal  " ;  2
	scrcode "directions and up to three buttons.  " ;  3
	scrcode "                                     " ;  4
	scrcode "                                     " ;  5
	scrcode "                                     " ;  6
	scrcode "                                     " ;  7
	scrcode "                                     " ;  8
	scrcode "                                     " ;  9
	scrcode "                                     " ; 10
	scrcode "                                     " ; 11
	scrcode "                                     " ; 12
	scrcode "                                     " ; 13
	scrcode "                                     " ; 14
	scrcode "                                     " ; 15
	scrcode "                                     " ; 16
	scrcode "                                     " ; 17
	scrcode "                                     " ; 18

	invcode "mouse                                "
	scrcode "                                     "
	scrcode "supported are 1351 compatible mice.  " ;  1
	scrcode "they give the position modulo 64 and " ;  2
	scrcode "support up to thre buttons and a     " ;  3
	scrcode "scroll wheel.                        " ;  4
	scrcode "                                     " ;  5
	scrcode "                                     " ;  6
	scrcode "                                     " ;  7
	scrcode "                                     " ;  8
	scrcode "                                     " ;  9
	scrcode "                                     " ; 10
	scrcode "                                     " ; 11
	scrcode "                                     " ; 12
	scrcode "                                     " ; 13
	scrcode "                                     " ; 14
	scrcode "                                     " ; 15
	scrcode "                                     " ; 16
	scrcode "                                     " ; 17
	scrcode "                                     " ; 18

	invcode "paddle                               "
	scrcode "                                     "
	scrcode "a paddle gives the rotational        " ;  1
	scrcode "position of its knob as a value from " ;  2
	scrcode " 0 to 255. it also contains a button." ;  3
	scrcode "                                     " ;  4
	scrcode "two paddles can be connected to one  " ;  5
	scrcode "port at the same time.               " ;  6
	scrcode "                                     " ;  7
	scrcode "                                     " ;  8
	scrcode "                                     " ;  9
	scrcode "                                     " ; 10
	scrcode "                                     " ; 11
	scrcode "                                     " ; 12
	scrcode "                                     " ; 13
	scrcode "                                     " ; 14
	scrcode "                                     " ; 15
	scrcode "                                     " ; 16
	scrcode "                                     " ; 17
	scrcode "                                     " ; 18
	
	invcode "koalapad                             "
	scrcode "                                     "
	scrcode "this is a touch tablet that gives the" ;  1
	scrcode "position in x and y as values from   " ;  2
	scrcode "ca. 6 to 251. it also contains two   " ;  3
	scrcode "buttons.                             " ;  4
	scrcode "                                     " ;  5
	scrcode "                                     " ;  6
	scrcode "                                     " ;  7
	scrcode "                                     " ;  8
	scrcode "                                     " ;  9
	scrcode "                                     " ; 10
	scrcode "                                     " ; 11
	scrcode "                                     " ; 12
	scrcode "                                     " ; 13
	scrcode "                                     " ; 14
	scrcode "                                     " ; 15
	scrcode "                                     " ; 16
	scrcode "                                     " ; 17
	scrcode "                                     " ; 18
	
	invcode "raw                                  "
	scrcode "                                     "
	scrcode "this displays the five digital input " ;  1
	scrcode "lines and the two analog             " ;  2
	scrcode "potentiometers as values from 0 to   " ;  3
	scrcode "255.                                 " ;  4
	scrcode "                                     " ;  5
	scrcode "                                     " ;  6
	scrcode "                                     " ;  7
	scrcode "                                     " ;  8
	scrcode "                                     " ;  9
	scrcode "                                     " ; 10
	scrcode "                                     " ; 11
	scrcode "                                     " ; 12
	scrcode "                                     " ; 13
	scrcode "                                     " ; 14
	scrcode "                                     " ; 15
	scrcode "                                     " ; 16
	scrcode "                                     " ; 17
	scrcode "                                     " ; 18

	invcode "userport joystick adapter            "
	scrcode "                                     "
	scrcode "these adapters support two aditional " ;  1
	scrcode "joysticks with four directional      " ;  2
	scrcode "switches one button each.            " ;  3
	scrcode "                                     " ;  4
	scrcode "supported are the following variants:" ;  5
	scrcode "- protovision / common game adapter  " ;  6
	scrcode "- digital excess / hitmen            " ;  7
	scrcode "- starbyte                           " ;  8
	scrcode "- kingsoft                           " ;  9
	scrcode "                                     " ; 10
	scrcode "                                     " ; 11
	scrcode "                                     " ; 12
	scrcode "                                     " ; 13
	scrcode "                                     " ; 14
	scrcode "                                     " ; 15
	scrcode "                                     " ; 16
	scrcode "                                     " ; 17
	scrcode "                                     " ; 18

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
	ldy #20
	jmp copyrect
