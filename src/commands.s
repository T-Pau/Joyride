;  commands.s -- Command handler table
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

COMMAND_NONE = 0
COMMAND_PORT1_NEXT = 1
COMMAND_PORT1_PREVIOUS = 2
COMMAND_PORT2_NEXT = 3
COMMAND_PORT2_PREVIOUS = 4
COMMAND_USERPORT_NEXT = 5
COMMAND_USERPORT_PREVIOUS = 6
COMMAND_EIGHT_PLAYER = 7
COMMAND_HELP = 8
COMMAND_HELP_NEXT = 9
COMMAND_HELP_PREVIOUS = 10
COMMAND_HELP_EXIT = 11
COMMAND_EIGHT_PLAYER_NEXT_TYPE = 12
COMMAND_EIGHT_PLAYER_PREVIOUS_TYPE = 13
COMMAND_EIGHT_PLAYER_NEXT_PAGE = 14
COMMAND_EIGHT_PLAYER_PREVIOUS_PAGE = 15
COMMAND_MAIN = 16
COMMAND_EIGHT_PLAYER_UPDATE_VIEWS = 17
COMMAND_PORT1_UPDATE_VIEW = 18
COMMAND_PORT2_UPDATE_VIEW = 19
COMMAND_USERPORT_UPDATE_VIEW = 20
COMMAND_EXTRA = 21
COMMAND_EXTRA_NEXT = 22
COMMAND_EXTRA_PREVIOUS = 23
COMMAND_EXTRA_RESET_KEYPAD = 24
COMMAND_EXIT = 25

.section data

.public command_handlers {
    .data $0000
    .data port1_next
    .data port1_previous
    .data port2_next
    .data port2_previous
    .data userport_next
    .data userport_previous
    .data display_eight_player_screen
    .data display_help_screen
    .data help_next
    .data help_previous
    .data display_current_screen
    .data eight_player_next_type
    .data eight_player_previous_type
    .data eight_player_next_page
    .data eight_player_previous_page
    .data display_main_screen
    .data eight_player_update_views
    .data port1_update_view
    .data port2_update_view
    .data userport_update_view
    .data display_extra_screen
    .data extra_next_type
    .data extra_previous_type
    .data extra_reset_keypad
    .data exit
}
