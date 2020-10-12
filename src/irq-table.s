.autoimport +
.export irq_table, irq_table_length

top = 50 ; first raster line of screen

.data

irq_table:
	.word top + 8 - 1, content_background
	.word top + 13 * 8, label_background
	.word top + 14 * 8 - 1, handle_port2
	.word top + 21 * 8, label_background
	.word top + 24 * 8 - 1, logo_background
	.word top + 25 * 8, handle_port1_user
irq_table_length:
	.byte * - irq_table
