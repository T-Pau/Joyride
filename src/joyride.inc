;  joyride.inc -- Global definitions for Joyride.
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


.include "c64.inc"

COLOR_BLACK = 0
COLOR_WHITE = 1
COLOR_RED = 2
COLOR_CYAN = 3
COLOR_VIOLET = 4
COLOR_PURPLE = COLOR_VIOLET
COLOR_GREEN = 5
COLOR_BLUE = 6
COLOR_YELLOW = 7
COLOR_ORANGE = 8
COLOR_BROWN = 9
COLOR_LIGHTRED = 10
COLOR_GRAY1 = 11
COLOR_GRAY2 = 12
COLOR_LIGHTGREEN = 13
COLOR_LIGHTBLUE = 14
COLOR_GRAY3 = 15

charset = $6000
screen = charset + $800
sprites = screen + $400
color_ram = $d800

sprite_none = (sprites & $3fff) / 64
sprite_lightpen = sprite_none + 1
sprite_bar = sprite_none + 2
sprite_cross = sprite_none + 3
sprite_logo = sprite_none + 4

tmp1 = $02
ptr1 = $fb
ptr2 = $fd
ptr3 = $c1

TYPE_LIGHTPEN = 5
port_types = 7
userport_types = 4

COMMAND_HELP = 8
COMMAND_HELP_NEXT = 9
COMMAND_HELP_PREVIOUS = 10
COMMAND_HELP_EXIT = 11
COMMAND_EIGHT_PLAYER_NEXT_TYPE = 12
COMMAND_EIGHT_PLAYER_PREVIOUS_TYPE = 13
COMMAND_EIGHT_PLAYER_NEXT_PAGE = 14
COMMAND_EIGHT_PLAYER_PREVIOUS_PAGE = 15
