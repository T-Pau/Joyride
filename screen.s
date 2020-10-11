.export main_screen

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
	invcode "                                   t'pau"
