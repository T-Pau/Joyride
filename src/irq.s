.export init_irq, set_irq_table

.include "c64.inc"

; IRQ_DEBUG = 1

table = $c3

.bss

index:
	.res 1

table_length:
	.res 1

.code

init_irq:
	sei
	; disable cia 1 interrupts
	lda #$7f
    sta CIA1_ICR

	; enable rasterline irq
	ldx #1
    stx VIC_IMR

	lda #<irq_main
	sta $0314
	lda #>irq_main
	sta $0315
	cli
	rts

set_irq_table:
	stx table
	sty table + 1
	sta table_length
	lda #0
	sta index
	jmp setup_next_irq

irq_main:
.ifdef IRQ_DEBUG
	inc VIC_BORDERCOLOR
.endif
irq_jsr:
	jsr $0000
	jsr setup_next_irq
	; acknowledge irq
	lda #1
    sta VIC_IRR
.ifdef IRQ_DEBUG
	dec VIC_BORDERCOLOR
.endif
    jmp $ea81


setup_next_irq:
	ldy index

	; activate next entry
	lda (table),y
	sta VIC_HLINE
	iny
	lda (table),y
	beq high0
	lda VIC_CTRL1
	ora #$80
	sta VIC_CTRL1
	bne addr
high0:
	lda VIC_CTRL1
	and #$7f
	sta VIC_CTRL1
addr:
	iny
	lda (table),y
	sta irq_jsr + 1
	iny
	lda (table),y
	sta irq_jsr + 2

	iny
	cpy table_length
	bne :+
	ldy #0
:	sty index
	rts

