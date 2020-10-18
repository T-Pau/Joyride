.autoimport +
.export main_irq_table, main_irq_table_length, help_irq_table, help_irq_table_length

top = 50 ; first raster line of screen

.data

main_irq_table:
	.word top + 8 - 1, content_background
	.word top + 13 * 8, label_background
	.word top + 14 * 8 - 1, handle_port2
	.word top + 21 * 8, label_background
	.word top + 24 * 8 - 1, logo_background
	.word top + 25 * 8, handle_port1_user
main_irq_table_length:
	.byte * - main_irq_table


help_irq_table:
	.word top + 8 - 1, content_background
	.word top + 21 * 8, label_background
	.word top + 24 * 8 - 1, logo_background
	.word top + 25 * 8, handle_help
help_irq_table_length:
	.byte * - help_irq_table
