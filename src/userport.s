.autoimport +

.export copy_userport, read_userport

.include "joytest.inc"
.macpack cbm_ext

name_address = screen + 13 * 40 + 15

.bss

temp:
	.res 2

.rodata

read_routines:
	.word read_protovision
	.word read_hitmen
	.word read_kingsoft
	.word read_starbyte

userport_names:
	.repeat 4, i
	.word userport_name_strings + 20 * i
	.endrep

userport_name_strings:
	invcode "protovision / cga   "
	invcode "hitmen              "
	invcode "kingsoft            "
	invcode "starbyte            "

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

read_userport:
	lda userport_type
	asl
	tay
	lda read_routines,y
	sta jump + 1
	lda read_routines + 1,y
	sta jump + 2
jump:
	jmp $0000


read_protovision:	
	lda #$80
    sta CIA2_DDRB
    
    ; select joystick 3
    lda CIA2_PRB
    ora #$80
    sta CIA2_PRB
    
    lda CIA2_PRB
    eor #$ff
    and #$1f
	sta port_digital
	
	; select joystick 4
    lda CIA2_PRB
    and #$7f
    sta CIA2_PRB
    
    lda CIA2_PRB
    eor #$ff
    and #$2f
    cmp #$20
    bcc :+
    ora #$10
:   and #$1f
	sta port_digital + 1
	rts


read_hitmen:
	; read directions
	lda #$00
	sta CIA2_DDRB
	lda CIA2_PRB
	eor #$ff
	sta port_digital + 1
	and #$0f
	sta port_digital
	lda port_digital + 1
	lsr
	lsr
	lsr
	lsr
	sta port_digital + 1
	
	; read port 3 fire 
	lda CIA2_DDRA
	and #%11111011
	sta CIA2_DDRA
	lda CIA2_PRA
	and #%00000100
	bne :+
	lda port_digital
	ora #$10
	sta port_digital
:	
	; read port 4 fire
	lda #$ff
	sta CIA1_SDR
	lda CIA2_SDR
	cmp #$ff
	beq :+
	lda port_digital + 1
	ora #$10
	sta port_digital + 1
:
	rts

.rodata

kingsoft_low:
	;      00   01   02   03   04   05   06   07   08   09   0a   0b   0c   0d   0e   0f
	.byte $00, $08, $04, $0c, $02, $0a, $06, $0e, $01, $09, $05, $0d, $03, $0b, $07, $0f

kingsoft_high:
	; TODO
	;      00   01   02   03   04   05   06   07   08   09   0a   0b   0c   0d   0e   0f
	.byte $00, $10, $08, $18, $04, $14, $0c, $1c, $01, $19, $05, $1d, $03, $1b, $07, $1f

starbyte_low:
	;      00   01   02   03   04   05   06   07   08   09   0a   0b   0c   0d   0e   0f
	.byte $00, $02, $08, $0a, $04, $06, $0c, $0d, $01, $03, $09, $0b, $05, $07, $0e, $0f

starbyte_high:
	; TODO
	;      00   01   02   03   04   05   06   07   08   09   0a   0b   0c   0d   0e   0f
	.byte $00, $08, $04, $0c, $02, $0a, $06, $0e, $01, $09, $05, $0d, $03, $0b, $07, $0f

.code

read_kingsoft:
	jsr read_hitmen
	
	lda port_digital
	and #$0f
	tax
	lda kingsoft_low,x
	sta temp + 1

	lda port_digital + 1
	and #$0f
	tax
	lda kingsoft_high,x
	sta temp
	
	lda port_digital
	and #$10
	beq :+
	lda temp
	ora #$01
	sta temp
:
	lda port_digital + 1
	and #$01
	beq :+
	lda temp + 1
	ora #$10
	sta port_digital +1
:
	lda temp
	sta port_digital
	rts

read_starbyte:
	jsr read_hitmen
	
	lda port_digital
	and #$0f
	tax
	lda starbyte_low,x
	sta temp

	lda port_digital + 1
	and #$0f
	tax
	lda starbyte_high,x
	sta temp + 1
	
	lda port_digital
	and #$10
	beq :+
	lda temp + 1
	ora #$01
	sta temp + 1
:
	lda port_digital + 1
	and #$01
	beq :+
	lda temp
	ora #$10
	sta port_digital
:
	lda temp + 1
	sta port_digital + 1
	rts