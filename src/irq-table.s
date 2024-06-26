;  irq-table.s -- Table of raster IRQ handlers.
;  Copyright (C) Dieter Baron
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
;  THIS SOFTWARE IS PROVIDED BY THE AUTHORS "AS IS" AND ANY EXPRESS
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

.section data

.public main_irq_table {
    .data top - 1:2, top_label
    .data top + 8 - 1:2, handle_userport
    .data top + 13 * 8:2, label_background
    .data top + 14 * 8 - 1:2, handle_port2
    .data top + 21 * 8:2, label_background
    .data top + 24 * 8 + 7:2, handle_port1

}

.public help_irq_table {
    .data top - 1:2, top_label
    .data top + 8 - 1:2, content_background
    .data top + 21 * 8:2, label_background
    .data top + 24 * 8 + 7:2, handle_help
}

.public eight_player_irq_table {
    .data top - 1:2, top_label
    .data top + 8 - 1:2, eight_player_top
    .data top + 21 * 8:2, label_background
    .data top + 24 * 8 + 7:2, eight_player_bottom
}

.public extra_irq_table {
    .data top + 8 * 2 - 1:2, label_background
    .data top + 8 * 3 - 1:2, extra_content
    .data top + 8 * 15 - 1:2, extra_label
    .data top + 24 * 8 + 7:2, handle_extra
}
