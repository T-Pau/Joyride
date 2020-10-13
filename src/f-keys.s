.autoimport +

.export handle_keyboard, main_loop

.include "joytest.inc"

.bss

shift:
	.res 1

.data

fkey:
	.byte 0
	
last_fkey:
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

.code

handle_keyboard:
	lda #$ff
	sta CIA1_DDRA
	lda #$00
	sta CIA1_DDRB
	
	lda #$ff
	sta CIA1_PRA
	lda CIA1_PRB
	cmp #$ff
	bne f_end
	
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
:	cpx last_fkey
	beq f_end
	stx last_fkey
	stx fkey
	bne f_end

f_none:
	ldx #0
	stx last_fkey
f_end:
	rts
	
main_loop:
	lda fkey
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
	sta fkey
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
userport_previous:
help:
none:
	rts