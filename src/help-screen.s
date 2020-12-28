;  help-screen.s -- Text for help screens.
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
.export display_help_page, current_help_page

.include "joyride.inc"

help_screen_start = screen + 1

help_screen_size = 37 * 20
num_help_screens = 14

.macpack cbm
.macpack cbm_ext

.bss

current_help_page:
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
	scrcode "relevant information. you can use the" ;  3
	scrcode "function keys to select the correct  " ;  4
	scrcode "type or to display raw data.         " ;  5
	scrcode "                                     " ;  6
	scrcode "adapters that support more than two  " ;  7
	scrcode "controllers don't fit in the main    " ;  8
	scrcode "screen. f7 switches to a layout that " ;  9
	scrcode "supports four controllers per page.  " ; 10
	scrcode "                                     " ; 11
	scrcode "for digital inputs, the button or    " ; 12
	scrcode "direction is inverted when pressed.  " ; 13
	scrcode "analog inputs are displayed as       " ; 14
	scrcode "numbers and by positioning a cursor. " ; 15
	scrcode "                                     " ; 16
	scrcode "to test the keyboard, use anykey:    " ; 17
	scrcode "  https://github.com/t-pau/anykey    " ; 18

	invcode "supported devices                    "
	scrcode "                                     "
	scrcode "the following devices are supported: " ;  1
	scrcode "controller port:                     " ;  2
	scrcode "- joystick                           " ;  3
	scrcode "- mouse                              " ;  4
	scrcode "- paddle                             " ;  5
	scrcode "- koalapad                           " ;  6
	scrcode "- light pen (only in port 1)         " ;  7
	scrcode "- trap them controller               " ;  8
	scrcode "- ninja snes pad                     " ;  9
	scrcode "- inception                          " ; 10
	scrcode "                                     " ; 11
	scrcode "userport:                            " ; 12
	scrcode "- protovision / classic game adapter " ; 13
	scrcode "- digital excess / hitmen            " ; 14
	scrcode "- kingsoft                           " ; 15
	scrcode "- starbyte tie break adapter         " ; 16
	scrcode "- superpad 64                        "	; 17
	scrcode "- luigi pantarotto's spaceballs      " ; 18

	invcode "joystick                             "
	scrcode "                                     "
	scrcode "joysticks contain a stick or d-pad   " ;  1
	scrcode "with switches for the four cardinal  " ;  2
	scrcode "directions and up to three buttons.  " ;  3
	scrcode "                                     " ;  4
	scrcode "buttons 2 and 3 bring an analog      " ;  5
	scrcode "potentiometer to a low value by      " ;  6
	scrcode "connecting its pin to +5v.           " ;  7
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
	scrcode "they give the position in x and y    " ;  2
	scrcode "modulo 64 and support up to three    " ;  3
	scrcode "buttons and a scroll wheel.          " ;  4
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
	scrcode "0 to 255. it also contains a button. " ;  3
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

	invcode "light pen                            "
	scrcode "                                     "
	scrcode "light pens and light guns only work  " ;  1
	scrcode "in controller port 1.                " ;  2
	scrcode "                                     " ;  3
	scrcode "they point directly at a position on " ;  4
	scrcode "screen. this is indicated by a big   " ;  5
	scrcode "cross hair on screen, even if it's   " ;  6
	scrcode "outside the display area of the port." ;  7
	scrcode "it is also shown on a smaller        " ;  8
	scrcode "representation of the screen.        " ;  9
	scrcode "                                     " ; 10
	scrcode "they can have up to two buttons. some" ; 11
	scrcode "pens require a button to be pressed  " ; 12
	scrcode "for the position to register.        " ; 13
	scrcode "                                     " ; 14
	scrcode "                                     " ; 15
	scrcode "                                     " ; 16
	scrcode "                                     " ; 17
	scrcode "                                     " ; 18

	invcode "trap them controller                 "
	scrcode "                                     "
	scrcode "this supernes style controller       " ;  1
	scrcode "connects to either controller port.  " ;  2
	scrcode "                                     " ;  3
	scrcode "it has these inputs:                 " ;  4
	scrcode "- dpad                               " ;  5
	scrcode "- four face buttons (1, 2, 3, 4)     " ;  6
	scrcode "- two shoulder buttons (l, r)        " ;  7
	scrcode "- select, start                      " ;  8
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
	scrcode "lines, and the two analog            " ;  2
	scrcode "potentiometers as values from 0 to   " ;  3
	scrcode "255.                                 " ;  4
	scrcode "                                     " ;  5
	scrcode "for port 1, it also displays the     " ;  6
	scrcode "light pen coordinates.               " ;  7
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
	scrcode "these adapters support two additional" ;  1
	scrcode "joysticks with four directional      " ;  2
	scrcode "switches and one button each.        " ;  3
	scrcode "                                     " ;  4
	scrcode "supported are the following variants:" ;  5
	scrcode "- protovision / classic game adapter " ;  6
	scrcode "- digital excess / hitmen            " ;  7
	scrcode "- kingsoft                           " ;  8
	scrcode "- starbyte tie break adapter         " ;  9
	scrcode "                                     " ; 10
	scrcode "                                     " ; 11
	scrcode "                                     " ; 12
	scrcode "                                     " ; 13
	scrcode "                                     " ; 14
	scrcode "                                     " ; 15
	scrcode "                                     " ; 16
	scrcode "                                     " ; 17
	scrcode "                                     " ; 18

	invcode "eight player adapter                 "
	scrcode "                                     "
	scrcode "these adapters support eight input   " ;  1
	scrcode "devices. the type of devices depends " ;  2
	scrcode "on the adapter.                      " ;  3
	scrcode "                                     " ;  4
	scrcode "four controllers are displayed per   " ;  5
	scrcode "page. use f3/f4 to switch pages.     " ;  6
	scrcode "                                     " ;  7
	scrcode "supported are the following variants:" ;  8
	scrcode "- superpad 64 (eight supernes        " ;  9
	scrcode "  controllers, connects to user port)" ; 10
	scrcode "- ninja snes pad (eight supernes     " ; 11
	scrcode "  controllers, connects to both      " ; 12
	scrcode "  controller ports)                  " ; 13
	scrcode "- luigi pantarotto's spaceballs      " ; 14
	scrcode "  (eight joysticks, connects to user " ; 15
	scrcode "  port and one controller port)      " ; 16
	scrcode "- inception (eight joysticks,        " ; 17
	scrcode "  connects to controller port)       " ; 18

	invcode "superpad 64 / ninja snes pad         "
	scrcode "                                     "
	scrcode "these adapters support 8 nintendo    " ;  1
	scrcode "supernes controllers or mice.  the   " ;  2
	scrcode "types of connected devices are       " ;  3
	scrcode "detected automatically.              " ;  4
	scrcode "                                     " ;  5
	scrcode "controllers have these inputs:       " ;  6
	scrcode "- dpad                               " ;  7
	scrcode "- four face buttons (a, b, x, y)     " ;  8
	scrcode "- two shoulder buttons (l, r)        " ;  9
	scrcode "- select, start                      " ; 10
	scrcode "                                     " ; 11
	scrcode "mice display x/y coordinates and two " ; 12
	scrcode "buttons.                             " ; 13
	scrcode "                                     " ; 14
	scrcode "the third page shows the raw data    " ; 15
	scrcode "read from each controller.           " ; 16
	scrcode "                                     " ; 17
	scrcode "                                     " ; 18

	invcode "luigi pantarotto's spaceballs        "
	scrcode "                                     "
	scrcode "this adapter supports eight joysticks" ;  1
	scrcode "with one button each.                " ;  2
	scrcode "                                     " ;  3
	scrcode "it connects to the user port and one " ;  4
	scrcode "controller port.                     " ;  5
	scrcode "                                     " ;  6
	scrcode "note: support for this adapter has   " ;  7
	scrcode "not been tested with real hardware.  " ;  8
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

	invcode "inception                            "
	scrcode "                                     "
	scrcode "this adapter supports eight joysticks" ;  1
	scrcode "with one button each.                " ;  2
	scrcode "                                     " ;  3
	scrcode "it connects to either controller     " ;  4
	scrcode "port.                                " ;  5
	scrcode "                                     " ;  6
	scrcode "ps/2 mice and auto-detection are not " ;  7
	scrcode "supported yet.                       " ;  8
	scrcode "                                     " ;  9
	scrcode "the third page shows the raw data    " ; 10
	scrcode "read from the adapter.               " ; 11
	scrcode "                                     " ; 12
	scrcode "                                     " ; 13
	scrcode "                                     " ; 14
	scrcode "                                     " ; 15
	scrcode "                                     " ; 16
	scrcode "                                     " ; 17
	scrcode "                                     " ; 18

.code

display_help_page:
	lda current_help_page
	bmi negative
	cmp #<num_help_screens
	bne ok
	lda #0
	beq ok
negative:
	lda #<(num_help_screens - 1)
ok:
	sta current_help_page
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
