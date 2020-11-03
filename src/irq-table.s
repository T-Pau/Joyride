;  irq-table.s -- Table of raster IRQ handlers.
;  Copyright (C) 2020 Dieter Baron
;
;  This file is part of Joyride, a controller test program for C64.
;  The authors can be contacted at <joyride@tpau.group>.
;
;  Redistribution and use in source and binary forms, with or without
;  modification, are permitted provided that the following conditions
;  are met:
;  1. Redistributions of source code must retain the above copyright
;     notice, this list of conditions and the following disclaimer.
;  2. The names of the authors may not be used to endorse or promote
;     products derived from this software without specific prior
;     written permission.
;
;  THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS
;  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;  ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
;  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
;  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
;  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
;  IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


.autoimport +
.export main_irq_table, main_irq_table_length, help_irq_table, help_irq_table_length, eight_player_irq_table, eight_player_irq_table_length

top = 50 ; first raster line of screen

.data

main_irq_table:
	.word 0, handle_top
	.word top, label_background
	.word top + 8 - 1, handle_user
	.word top + 13 * 8, label_background
	.word top + 14 * 8 - 1, handle_port2
	.word top + 21 * 8, label_background
	.word top + 24 * 8 + 6, handle_port1
main_irq_table_length:
	.byte * - main_irq_table


help_irq_table:
	.word top, label_background
	.word top + 8 - 1, content_background
	.word top + 21 * 8, label_background
	.word top + 24 * 8 + 6, handle_help
help_irq_table_length:
	.byte * - help_irq_table

eight_player_irq_table:
	.word top, label_background
	.word top + 8 - 1, content_background
	.word top + 21 * 8, label_background
	.word top + 24 * 8 + 6, handle_eight_player
eight_player_irq_table_length:
	.byte * - eight_player_irq_table
