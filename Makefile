SUBDIRS = src

VERSION = 1.4

FILES = README.md NEWS.md Joyride\ User\ Manual.pdf screenshot.png src/joyride.prg

DISTFILE = Joyride-${VERSION}.zip

.PHONY: all clean dist

all:
	@for dir in ${SUBDIRS}; \
	do \
		(cd $$dir && make VERSION="${VERSION}" all) || exit 1; \
	done

dist: ${DISTFILE}

clean:
	@for dir in ${SUBDIRS}; \
	do \
		(cd $$dir && make clean) || exit 1; \
	done

${DISTFILE}: ${FILES}
	zip -9jq ${DISTFILE} ${FILES}
