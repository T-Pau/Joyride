.autoimport +

.export handle_keyboard, main_loop, command, last_command

.include "joytest.inc"

.bss

shift:
	.res 1

.data

command:
	.byte 0

last_command:
	.byte 0

.rodata

function_handlers:
	.word 0
	.word port1_next
	.word port1_previous
	.word port2_next
	.word port2_previous
	.word userport_next
	.word userport_previous
	.word help
	.word none
	.word help_next
	.word help_previous
	.word display_main_screen

.code

handle_keyboard:
	lda #$ff
	sta CIA1_PRA
	sta CIA1_PRB
	
	lda CIA1_PRA
	and CIA1_PRB
	cmp #$ff
	bne f_end
	
	lda #$00
	sta CIA1_DDRB

	; get shift
	lda #$40 ^ $ff
	sta CIA1_PRA
	lda CIA1_PRB
	eor #$ff
	and #$10
	sta shift
	lda #$02 ^ $ff
	sta CIA1_PRA
	lda CIA1_PRB
	eor #$ff
	and #$80
	ora shift
	sta shift

	lda #$01 ^ $ff
	sta CIA1_PRA
	lda CIA1_PRB
	; down F5 F3 F1 F7 ...
	rol
	rol
	bcs not_f5
	ldx #5
	bne f_got
not_f5:
	rol
	bcs not_f3
	ldx #3
	bne f_got
not_f3:
	rol
	bcs not_f1
	ldx #1
	bne f_got
not_f1:
	bmi f_none
	ldx #7
f_got:
	lda shift
	beq :+
	inx
:	cpx last_command
	beq f_end
	stx last_command
	stx command
	bne f_end

f_none:
	ldx #0
	stx last_command
f_end:
	lda #$ff
	sta CIA1_DDRB
	rts

main_loop:
	lda command
	beq main_loop
	asl
	tax
	lda function_handlers,x
	sta jump + 1
	lda function_handlers + 1,x
	sta jump  +2
jump:
	jsr $0000
	lda #0
	sta command
	beq main_loop


port1_next:
	ldx port1_type
	inx
	cpx #port_types
	bne :+
	ldx #0
:	stx port1_type
	ldy #0
	jmp copy_port_screen

port1_previous:
	ldx port1_type
	dex
	bpl :+
	ldx #port_types - 1
:	stx port1_type
	ldy #0
	jmp copy_port_screen

port2_next:
	ldx port2_type
	inx
	cpx #port_types
	bne :+
	ldx #0
:	stx port2_type
	ldy #1
	jmp copy_port_screen

port2_previous:
	ldx port2_type
	dex
	bpl :+
	ldx #port_types - 1
:	stx port2_type
	ldy #1
	jmp copy_port_screen

userport_next:
	ldx userport_type
	inx
	cpx #userport_types
	bne :+
	ldx #0
:	stx userport_type
	jmp copy_userport

userport_previous:
	ldx userport_type
	dex
	bpl :+
	ldx #userport_types - 1
:	stx userport_type
	jmp copy_userport

none:
	rts
