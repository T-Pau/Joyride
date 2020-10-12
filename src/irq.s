.import irq_table, irq_table_length
.export init_irq

.include "c64.inc"

.bss

index:
	.res 1

.code

.proc init_irq
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
	lda #0
	sta index
	jsr setup_next_irq
	cli
	rts

irq_main:
	jsr $0000
	jsr setup_next_irq
	; acknowledge irq
	lda #1
    sta VIC_IRR
    jmp $ea81


setup_next_irq:
	ldx index

	; activate next entry
	lda irq_table,x
	sta VIC_HLINE
	lda VIC_CTRL1
	and #$7f
	ldy irq_table + 1,x
	beq high0
	ora #$80
high0:
	sta VIC_CTRL1
	lda irq_table + 2,x
	sta irq_main + 1
	lda irq_table + 3,x
	sta irq_main + 2

	; increase index
	txa
	clc
	adc #4
	cmp irq_table_length
	bne next
	lda #0
next:
	sta index
	rts

.endproc

