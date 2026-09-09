# dwm - dynamic window manager

include config.mk

# Core dwm sources. Extra patch files are included from config.h/dwm.c as needed.
SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: options dwm

options:
	@echo dwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

# config.h is the active local config used by the compiler.
# Edit config.def.h first, then copy/regenerate config.h when you want them synced.
config.h:
	cp config.def.h $@

dwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz *.orig *.rej config.h

dist: clean
	mkdir -p dwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		dwm.1 drw.h util.h ${SRC} dwm.png transient.c dwm-${VERSION}
	tar -cf dwm-${VERSION}.tar dwm-${VERSION}
	gzip dwm-${VERSION}.tar
	rm -rf dwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	# Install an XSession entry for display managers.
	mkdir -p /usr/share/xsessions
	test -f /usr/share/xsessions/dwm.desktop || cp -n dwm.desktop /usr/share/xsessions/
	chmod 644 /usr/share/xsessions/dwm.desktop
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1
	rm config.h *.o

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwm \
		${DESTDIR}${MANPREFIX}/man1/dwm.1
	# Uncomment this if you also want uninstall to remove the display-manager entry.
	# rm -f /usr/share/xsessions/dwm.desktop

.PHONY: all options clean dist install uninstall
