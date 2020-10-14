.autoimport +

.export copy_userport, read_userport1, read_userport2

.include "joytest.inc"
.macpack cbm_ext

name_address = screen + 13 * 40 + 15

.rodata

userport_names:
	.repeat 2, i
	.word userport_name_strings + 20 * i
	.endrep

userport_name_strings:
	invcode "protovision / cga   "
	invcode "hitmen              "

.code

; display name for userport type A

copy_userport:
	lda userport_type
	asl
	tax
	
	lda #<name_address
	sta ptr2
	lda #>name_address
	sta ptr2 + 1

	lda userport_names,x
	sta ptr1
	lda userport_names + 1,x
	sta ptr1 + 1

	ldy #19
loop:
	lda (ptr1),y
	sta (ptr2),y
	dey
	bpl loop
	
	rts

read_userport1:
	lda userport_type
	bne hitmen1
	
	; select joystick 3
	lda #$80
    sta CIA2_DDRB
    lda CIA2_PRB
    ora #$80
    sta CIA2_PRB
    
    ; read joystick
    lda CIA2_PRB
    eor #$ff
    and #$1f
	sta port_digital
	rts
	
hitmen1:
	; TOOD
	lda #0
	sta port_digital
	rts

read_userport2:
	lda userport_type
	bne hitmen2
	
	; select joystick 4
	lda #$80
    sta CIA2_DDRB
    lda CIA2_PRB
    and #$7f
    sta CIA2_PRB
    
    ; read joystick (moving bit 5 to bit 4)
    lda CIA2_PRB
    eor #$ff
    and #$2f
    cmp #$20
    bcc :+
    ora #$10
:   and #$1f
	sta port_digital
	rts
	
hitmen2:
	; TOOD
	lda #0
	sta port_digital
	rts
