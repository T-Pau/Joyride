.export main_color, help_color

.rodata

main_color:
	.res 80, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.res 160, $c
	.byte $c, $c, $c, $c, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c, $c, $c, $c, $c, $c
	.byte $c, $c, $c, $c, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c, $c, $c, $c, $c, $c
	.byte $c, $c, $c, $c, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c, $c, $c, $c, $c, $c
	.byte $c, $c, $c, $c, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c, $c, $c, $c, $c, $c
	.byte $c, $c, $c, $c, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c, $c, $c, $c, $c, $c
	.res 5*40, $c

help_color:
	.res 2 * 40, $c
	.repeat 18, i
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b
	.byte $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $b, $c
	.endrep
	.res 5*40, $c
