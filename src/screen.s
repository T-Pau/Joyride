;  screen.s -- Screen contents.
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


.export main_screen, help_screen

.macpack cbm
.macpack cbm_ext

.rodata

main_screen:
	invcode " port 1:             port 2:            "
	scrcode "I                 J"
	.byte $a0
	scrcode "I                 J"
	.byte $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	.byte "                   ", $a0, "                   ", $a0
	scrcode "KMMMMMMMMMMMMMMMMML"
	.byte $a0
	scrcode "KMMMMMMMMMMMMMMMMML"
	.byte $a0
	invcode "                                        "
	invcode "    user port:                          "
	.byte $a0, $a0, $a0
	scrcode "I                               J"
	.byte $a0, $a0, $a0, $a0
	.byte $a0, $a0, $a0, "                                 ", $a0, $a0, $a0, $a0
	.byte $a0, $a0, $a0
	scrcode "           AHB           AHB     "
	.byte $a0, $a0, $a0, $a0,  $a0, $a0, $a0
	scrcode "           EfF           EfF     "
	.byte $a0, $a0, $a0, $a0,  $a0, $a0, $a0
	scrcode "           CGD           CGD     "
	.byte $a0, $a0, $a0, $a0
	.byte $a0, $a0, $a0, "                                 ", $a0, $a0, $a0, $a0
	.byte $a0, $a0, $a0
	scrcode "KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMML"
	.byte $a0, $a0, $a0, $a0
	invcode "                                        "
	invcode "     f1/f2: port 1   f3/f4: port 2      "
	invcode "      f5/f6: user port   f7: help       "
	invcode "                                        "


help_screen:
	invcode "                                        "
	scrcode "I                                     J"
	.byte $a0
	.repeat 18, i
	scrcode "                                       "
	.byte $a0
	.endrep
	scrcode "KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMML"
	.byte $a0
	invcode "                                        "
	invcode "  space/+: next page  -: previous page  "
	invcode "         "
	.byte $9f
	invcode            ": return to program           "
	invcode "                                        "
