; set sprite X coordinates
.export sprite_x, sprite_y, set_sprite

.include "c64.inc"

.rodata

highbit:
	.byte $01, $fe,  $02, $fd,  $04, $fb,  $08, $f7
	.byte $10, $ef,  $20, $df,  $40, $bf,  $80, $7f

.bss

sprite_x:
	.res 2
sprite_y:
	.res 1

.code

set_sprite:
	txa
	lsr
	tax

	lda VIC_SPR_HI_X
	and highbit + 1,x
	ldy sprite_x + 1
	beq set_high	
	ora highbit,x
set_high:
	sta VIC_SPR_HI_X

	lda sprite_x
	sta VIC_SPR0_X,x
	lda sprite_y
	sta VIC_SPR0_Y,x

	rts
