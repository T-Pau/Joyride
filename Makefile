CC = cl65
CFLAGS = -t c64

LD = cl65
LDFLAGS = -t c64 -u __EXEHDR__ -C c64-asm.cfg

all: joytest.prg

SOURCES = \
	start.s \
	charset.s \
	color.s \
	colors.s \
	irq.s \
	irq_table.s \
	memcpy.s \
	ports.s \
	screen.s

OBJECTS = ${SOURCES:.s=.o}

.SUFFIXES: .s .o

.s.o:
	${CC} ${CFLAGS} -c $<

joytest.prg: ${OBJECTS}
	${LD} ${LDFLAGS} -o joytest.prg ${OBJECTS}
