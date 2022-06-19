VERSION = $(shell cat ../version.txt)

DEPDIR := .deps

CC = cl65
CFLAGS = -t c64

CONVERT_SCREENS = ../scripts/convert-screens

CONVERT_SCREENS_DEPENDENCIES = \
	../scripts/convert-screens \
	../scripts/AssemblerOutput.py \
	../scripts/RunlengthEncoder.py \
	../scripts/Screens.py


LD = cl65
LDFLAGS = -t c64 -u __EXEHDR__ -C c64-asm.cfg
# LDFLAGS += -Ln sym

DISK = joyride.d64
DISK_D81 = joyride.d81

DISKS = ${DISK} ${DISK_D81}

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
	display-protopad.s \
	display-raw.s \
	display-trapthem.s \
	dpad.s \
	eight-player.s \
	f-keys.s \
	help.s \
	help-screen.s \
	help-screens.s \
	hex.s \
	inception.s \
	irq.s \
	irq-table.s \
	logo.s \
	main-loop.s \
	memcpy.s \
	petscii.s \
	port-screen.s \
	ports.s \
	pot.s \
	rl-expand.s \
	screen.s \
	snes.s \
	snespad.s \
	spaceballs.s \
	sprite.s \
	sprites.s \
	state.s \
	superpad.s \
	userport.s

OBJECTS = ${SOURCES:.s=.o}

all: ${PROGRAM} ${DISKS}

clean:
	rm -f ${OBJECTS} ${PROGRAM} ${DISKS}


%.o : %.s ${DEPDIR}/%.d | ${DEPDIR}
	${CC} ${CFLAGS} --create-dep ${DEPDIR}/$*.d -c $<

${DEPDIR}: ; @mkdir -p $@

DEPFILES := ${SOURCES:%.s=${DEPDIR}/%.d}
${DEPFILES}:

include $(wildcard ${DEPFILES})

${DISK}: ${PROGRAM}
	disk=${DISK}.$$$$; \
	(set -e; \
	c1541 -silent -format "joyride,tp" d64 $$disk; \
	c1541 $$disk -silent -write "joyride.prg" "joyride"; \
	mv $$disk ${DISK})

${DISK_D81}: ${PROGRAM}
	disk=${DISK_D81}.$$$$; \
	(set -e; \
	c1541 -silent -format "joyride,tp" d81 $$disk; \
	c1541 $$disk -silent -write "joyride.prg" "joyride"; \
	mv $$disk ${DISK_D81})

charset.bin: charset.png
	gfx-convert -b 255 charset charset.png charset.bin

sprites.bin: sprites.png
	gfx-convert sprites sprites.png sprites.bin

dpad.bin: dpad.png charset.bin
	gfx-convert -b 255 screen dpad.png charset.bin dpad.bin

lightpen-buttons.bin: lightpen-buttons.png charset.bin
	gfx-convert  -b 255 screen lightpen-buttons.png charset.bin lightpen-buttons.bin

mouse-buttons.bin: mouse-buttons.png charset.bin
	gfx-convert  -b 255 screen charset.bin "" $<

port-screens.bin: port-screens.png charset.bin
	gfx-convert  -b 255 screen charset.bin "" $< \
		&& ./fixup-buttons $@

userport-screens.bin: userport-screens.png charset.bin
	gfx-convert  -b 255 screen charset.bin "" $< \
		&& ./fixup-buttons $@

scroll-wheel.bin: scroll-wheel.png charset.bin
	gfx-convert  -b 255 screen charset.bin "" $<

eight-player.bin: eight-player.png charset.bin
	gfx-convert  -b 255 screen charset.bin "" eight-player.png $< \
		&& ./fixup-buttons $@

help-screens.s: help-screens.txt ../version.txt ${CONVERT_SCREENS_DEPENDENCIES}
	${CONVERT_SCREENS} -DVERSION=${VERSION} -D__C64__ $< $@


${PROGRAM}: ${OBJECTS}
	${LD} ${LDFLAGS} -o ${PROGRAM} ${OBJECTS}

charset.o: charset.bin
dpad.o: dpad.bin
display-lightpen.o: lightpen-buttons.bin
display-mouse.o: mouse-buttons.bin scroll-wheel.bin
eight-player.o: eight-player.bin
port-screen.o: port-screens.bin
sprites.o: sprites.bin
