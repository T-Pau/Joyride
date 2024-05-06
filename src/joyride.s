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

charset = $e000
screen = $c000
sprites = $c400
color_ram = $d800

sprite_none = (sprites & $3fff) / 64
sprite_lightpen = sprite_none + 1
sprite_bar = sprite_none + 2
sprite_cross = sprite_none + 3
sprite_logo = sprite_none + 4


top = 50 ; first raster line of screen

USERPORT_VIEW_START = screen + 15 * 40 + 4


MODE_MAIN = 0
MODE_EIGHT_PLAYER = 1

CONTROLLER_TYPE_JOYSTICK = 0
CONTROLLER_TYPE_MOUSE = 1
CONTROLLER_TYPE_PADDLE_1 = 2
CONTROLLER_TYPE_PADDLE_2 = 3
CONTROLLER_TYPE_KOALAPAD = 4
CONTROLLER_TYPE_LIGHTPEN = 5
CONTROLLER_TYPE_TRAPTHEM = 6
CONTROLLER_TYPE_RAW = 7

CONTROLLER_NUM_TYPES = 9


USER_TYPE_PROTOVISION = 0
USER_TYPE_HITMEN = 1
USER_TYPE_KINGSOFT = 2
USER_TYPE_STARSOFT = 3
USER_TYPE_PET_DUAL = 4
USER_TYPE_STUPID_PET = 5
USER_TYPE_PETSCII = 6

USER_NUM_TYPES = 7


USER_VIEW_TWO_JOYSTICKS = 0
USER_VIEW_SNES = 1
USER_VIEW_ONE_JOYSTICK = 2

USER_NUM_VIEWS = 3


EIGHT_PLAYER_TYPE_SUPERPAD = 0
EIGHT_PLAYER_TYPE_SNESPAD = 1
EIGHT_PLAYER_TYPE_SPACEBALLS_1 = 2
EIGHT_PLAYER_TYPE_SPACEBALLS_2 = 3
EIGHT_PLAYER_TYPE_INCEPTION_1 = 4
EIGHT_PLAYER_TYPE_INCEPTION_2 = 5
EIGHT_PLAYER_TYPE_MULTIJOY = 6
EIGHT_PLAYER_TYPE_PROTOVISION_MULTIJOY = 7
EIGHT_PLAYER_TYPE_WHEEL_OF_JOY = 8

EIGHT_PLAYER_NUM_TYPES = 9


EIGHT_PLAYER_VIEW_EMPTY = 0
EIGHT_PLAYER_VIEW_NONE = 1
EIGHT_PLAYER_VIEW_SNES = 2
EIGHT_PLAYER_VIEW_MOUSE = 3
EIGHT_PLAYER_VIEW_JOYSTICK = 4

EIGHT_PLYAER_NUM_VIEWS = 5


EIGHT_PLAYER_OFFSET_FIRST = 40 * 2 + 1
EIGHT_PLAYER_OFFSET_SECOND = 40 * 2 + 20
EIGHT_PLAYER_OFFSET_THIRD = 40 * 11 + 1
EIGHT_PLAYER_OFFSET_FOURTH = 40 * 11 + 20


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

.section zero_page
.public tmp1 .reserve 1
.public ptr1 .reserve 2
.public ptr2 .reserve 2
.public ptr3 .reserve 2
