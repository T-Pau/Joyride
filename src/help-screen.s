;  help-screen.s -- Text for help screens.
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

help_screen_title = screen + 1
help_screen_text = screen + 40 * 2 + 1

.section reserved

.public current_help_page .reserve 1


.section code

.public display_help_page {
    lda current_help_page
    bmi negative
    cmp help_screens_count
    bne ok
    lda #0
    beq ok
negative:
    ldx help_screens_count
    dex
    txa
ok:
    sta current_help_page
    asl
    tax

    lda help_screens,x
    sta ptr1
    lda help_screens + 1,x
    sta ptr1 + 1
    lda #<help_screen_title
    sta ptr2
    lda #>help_screen_title
    sta ptr2 + 1
    jsr rl_expand
    lda #<help_screen_text
    sta ptr2
    lda #>help_screen_text
    sta ptr2 + 1
    jmp rl_expand
}

.section data

help_f_key_commands {
    .data 0
    .data COMMAND_HELP_PREVIOUS, 0 ; F1 / F2
    .data COMMAND_HELP_NEXT, COMMAND_HELP_PREVIOUS ; F3 / F4
    .data 0, 0 ; F5 / F6
    .data 0, 0 ; F7 / F8
    .data COMMAND_HELP_EXIT, COMMAND_EXIT ; C=-F1 / RunStop
    .data COMMAND_HELP_EXIT, COMMAND_HELP_NEXT ; ← / Space
    .data COMMAND_HELP_NEXT, COMMAND_HELP_PREVIOUS ; + / -
}
