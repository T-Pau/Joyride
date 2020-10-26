CC = cl65
CFLAGS = -t c64

LD = cl65
LDFLAGS = -t c64 -u __EXEHDR__ -C c64-asm.cfg
 LDFLAGS += -Ln sym

PROGRAM = joyride.prg

SOURCES = \
	start.s \
	button.s \
	charset.s \
	color.s \
	colors.s \
	copyrect.s \
	display-joystick.s \
	display-koalapad.s \
	display-lightpen.s \
	display-mouse.s \
	display-paddle.s \
	display-port.s \
	display-raw.s \
	dpad.s \
	f-keys.s \
	help.s \
	help-screen.s \
	irq.s \
	irq-table.s \
	logo.s \
	memcpy.s \
	port-screen.s \
	ports.s \
	pot.s \
	screen.s \
	sprite.s \
	sprites.s \
	userport.s

OBJECTS = ${SOURCES:.s=.o}

all: ${PROGRAM}

clean:
	rm -f ${OBJECTS} ${PROGRAM}


.SUFFIXES: .s .o

.s.o:
	${CC} ${CFLAGS} -c $<

charset.bin: charset.png
	gfx-convert charset charset.png charset.bin

sprites.bin: sprites.png
	gfx-convert sprites sprites.png sprites.bin

${PROGRAM}: ${OBJECTS}
	${LD} ${LDFLAGS} -o ${PROGRAM} ${OBJECTS}

button.o: button.s joyride.inc
charset.o: charset.s charset.bin
colors.o: colors.s joyride.inc
copyrect.o: copyrect.s joyride.inc
display-joystick.o: display-joystick.s joyride.inc
display-koalapad.o: display-koalapad.s joyride.inc utility.mac
display-lightpen.o: display-lightpen.s joyride.inc utility.mac
display-mouse.o: display-mouse.s joyride.inc utility.mac
display-paddle.o: display-paddle.s joyride.inc utility.mac
display-port.o: display-port.s joyride.inc
display-raw.o: display-raw.s joyride.inc utility.mac
dpad.o: dpad.s joyride.inc
f-keys.o: f-keys.s joyride.inc
help.o: help.s joyride.inc utility.mac
help-screen.o: help-screen.s joyride.inc cbm_ext.mac
logo.o: logo.s joyride.inc cbm_ext.mac
memcpy.o: memcpy.s joyride.inc
port-screen.o: port-screen.s joyride.inc cbm_ext.mac utility.mac
ports.o: ports.s joyride.inc
pot.o: pot.s joyride.inc
screen.o: screen.s cbm_ext.mac
sprites.o: sprites.s sprites.bin
start.o: start.s joyride.inc cbm_ext.mac utility.mac
userport.o: userport.s joyride.inc cbm_ext.mac
