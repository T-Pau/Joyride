CC = cl65
CFLAGS = -t c64

LD = cl65
LDFLAGS = -t c64 -u __EXEHDR__ -C c64-asm.cfg
# LDFLAGS += -Ln sym

all: joytest.prg

SOURCES = \
	start.s \
	button.s \
	charset.s \
	color.s \
	colors.s \
	cursor.s \
	copyrect.s \
	display-joystick.s \
	display-mouse.s \
	display-koalapad.s \
	display-paddle.s \
	display-port.s \
	display-raw.s \
	dpad.s \
	f-keys.s \
	irq.s \
	irq-table.s \
	memcpy.s \
	port-screen.s \
	ports.s \
	pot.s \
	screen.s \
	sprite.s

OBJECTS = ${SOURCES:.s=.o}

.SUFFIXES: .s .o

.s.o:
	${CC} ${CFLAGS} -c $<

charset.bin: charset.png
	gfx-convert charset charset.png charset.bin

cursor.bin: cursor.png
	gfx-convert sprites cursor.png cursor.bin

joytest.prg: ${OBJECTS}
	${LD} ${LDFLAGS} -o joytest.prg ${OBJECTS}

button.o: button.s joytest.inc
charset.o: charset.s charset.bin
cursor.o: cursor.s cursor.bin
colors.o: colors.s joytest.inc
copyrect.o: copyrect.s joytest.inc
display-joystick.o: display-joystick.s joytest.inc
display-koalapad.o: display-koalapad.s joytest.inc utility.mac
display-mouse.o: display-mouse.s joytest.inc utility.mac
display-paddle.o: display-paddle.s joytest.inc utility.mac
display-port.o: display-port.s joytest.inc
display-raw.o: display-raw.s joytest.inc utility.mac
dpad.o: dpad.s joytest.inc
f-keys.o: f-keys.s joytest.inc
memcpy.o: memcpy.s joytest.inc
port_screen.o: port_screen.s joytest.inc cbm_ext.mac
ports.o: ports.s joytest.inc
pot.o: pot.s joytest.inc
screen.o: screen.s cbm_ext.mac
start.o: start.s joytest.inc cbm_ext.mac utility.mac
