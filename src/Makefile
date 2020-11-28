DEPDIR := .deps

CC = cl65
CFLAGS = -t c64

LD = cl65
LDFLAGS = -t c64 -u __EXEHDR__ -C c64-asm.cfg
# LDFLAGS += -Ln sym

PROGRAM = joyride.prg

SOURCES = \
	start.s \
	button.s \
	charset.s \
	color.s \
	colors.s \
	commands.s \
	copyrect.s \
	display-joystick.s \
	display-koalapad.s \
	display-lightpen.s \
	display-mouse.s \
	display-paddle.s \
	display-port.s \
	display-raw.s \
	dpad.s \
	eight-player.s \
	f-keys.s \
	help.s \
	help-screen.s \
	irq.s \
	irq-table.s \
	logo.s \
	main-loop.s \
	memcpy.s \
	port-screen.s \
	ports.s \
	pot.s \
	screen.s \
	snes.s \
	snespad.s \
	sprite.s \
	sprites.s \
	state.s \
	superpad.s \
	userport.s

OBJECTS = ${SOURCES:.s=.o}

all: ${PROGRAM}

clean:
	rm -f ${OBJECTS} ${PROGRAM}


%.o : %.s ${DEPDIR}/%.d | ${DEPDIR}
	${CC} ${CFLAGS} --create-dep ${DEPDIR}/$*.d -c $<

${DEPDIR}: ; @mkdir -p $@

DEPFILES := ${SOURCES:%.s=${DEPDIR}/%.d}
${DEPFILES}:

include $(wildcard ${DEPFILES})


charset.bin: charset.png
	gfx-convert -b 255 charset charset.png charset.bin

sprites.bin: sprites.png
	gfx-convert sprites sprites.png sprites.bin

dpad.bin: dpad.png charset.bin
	gfx-convert screen dpad.png charset.bin dpad.bin

lightpen-buttons.bin: lightpen-buttons.png charset.bin
	gfx-convert screen lightpen-buttons.png charset.bin lightpen-buttons.bin

mouse-buttons.bin: mouse-buttons.png charset.bin
	gfx-convert screen mouse-buttons.png charset.bin mouse-buttons.bin

port-screens.bin: port-screens.png charset.bin
	gfx-convert screen port-screens.png charset.bin port-screens.bin \
		&& ./fixup-buttons port-screens.bin

scroll-wheel.bin: scroll-wheel.png charset.bin
	gfx-convert screen scroll-wheel.png charset.bin scroll-wheel.bin

eight-player.bin: eight-player.png charset.bin
	gfx-convert screen eight-player.png charset.bin eight-player.bin


${PROGRAM}: ${OBJECTS}
	${LD} ${LDFLAGS} -o ${PROGRAM} ${OBJECTS}

charset.o: charset.bin
dpad.o: dpad.bin
display-lightpen.o: lightpen-buttons.bin
display-mouse.o: mouse-buttons.bin scroll-wheel.bin
eight-player.o: eight-player.bin
port-screen.o: port-screens.bin
sprites.o: sprites.bin
