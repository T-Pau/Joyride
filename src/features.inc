.pre_if .defined(C64) || .defined(C128) || .defined(MEGA65)
.define USE_VICII
.pre_else_if .defined(PLUS4)
.define USE_TED
.pre_else_if .defined(VIC20)
.define USE_VIC
.pre_else_if .defined(PET)
.define USE_PET
.pre_end