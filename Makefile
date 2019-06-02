Version = $(shell git describe --abbrev=0 --tags)

PREFIX = /usr
LIBDIR = /lib/manjaro-architect
DATADIR = /share/manjaro-architect

BIN = \
	bin/btrfs-subvol-functions \
	bin/check-translate.in \
	bin/ma-launcher \
	bin/manjaro-architect

LIBS = \
	lib/ini_val.sh \
	lib/util.sh \
	lib/util-advanced.sh \
	lib/util-base.sh \
	lib/util-config.sh \
	lib/util-desktop.sh \
	lib/util-disk.sh \
	lib/util-menu.sh

LISTS = \
	data/package-lists/base-openrc-manjaro \
	data/package-lists/base-systemd-manjaro \
	data/package-lists/input-drivers
	
LANG = \
	data/translations/danish.trans \
	data/translations/dutch.trans \
	data/translations/english.trans \
	data/translations/french.trans \
	data/translations/german.trans \
	data/translations/hungarian.trans \
	data/translations/italian.trans \
	data/translations/polish.trans \
	data/translations/portuguese.trans \
	data/translations/portuguese_brasil.trans \
	data/translations/russian.trans \
	data/translations/ukrainian.trans \
	data/translations/spanish.trans \
	data/translations/turkish.trans

ICONS = \
    data/manjaro-architect.png

LAUNCHER = \
	data/manjaro-architect.desktop

DIALOGRC = \
	data/dialogrc \
	data/dialogrc_gui

LIVE = \
	data/ma-launcher.desktop

all: $(BIN)

edit = \
    sed -e "s|@datadir[@]|$(DESTDIR)$(PREFIX)$(DATADIR)|g" \
	-e "s|@libdir[@]|$(DESTDIR)$(PREFIX)$(LIBDIR)|g" \
	-e "s|@version@|${Version}|"

%: %.in Makefile
	@echo "GEN $@"
	@$(RM) "$@"
	@m4 -P $@.in | $(edit) >$@
	@chmod a-w "$@"
	@chmod +x "$@"

clean:
	rm -f $(BIN)

install:
	install -dm0755 $(DESTDIR)$(PREFIX)/bin
	install -m0755 ${BIN} $(DESTDIR)$(PREFIX)/bin

	install -dm0755 $(DESTDIR)$(PREFIX)$(LIBDIR)
	install -m0644 ${LIBS} $(DESTDIR)$(PREFIX)$(LIBDIR)

	install -dm0755 $(DESTDIR)$(PREFIX)$(DATADIR)/package-lists
	install -m0644 ${LISTS} $(DESTDIR)$(PREFIX)$(DATADIR)/package-lists
	
	install -dm0755 $(DESTDIR)$(PREFIX)$(DATADIR)/translations
	install -m0644 ${LANG} $(DESTDIR)$(PREFIX)$(DATADIR)/translations

	install -dm0755 $(DESTDIR)$(PREFIX)/share/icons/hicolor/48x48/apps
	install -m0644 ${ICONS} $(DESTDIR)$(PREFIX)/share/icons/hicolor/48x48/apps
	
	install -dm0755 $(DESTDIR)$(PREFIX)/share/applications
	install -m0644 ${LAUNCHER} $(DESTDIR)$(PREFIX)/share/applications
	
	install -dm0755 $(DESTDIR)$(PREFIX)$(DATADIR)
	install -m0644 ${DIALOGRC} $(DESTDIR)$(PREFIX)$(DATADIR)
	
	install -dm0755 $(DESTDIR)/etc/skel/.config/autostart
	install -m0644 ${LIVE} $(DESTDIR)/etc/skel/.config/autostart

uninstall:
	for f in ${BIN}; do rm -f $(DESTDIR)$(PREFIX)/bin/$$f; done
	for f in ${LIBS}; do rm -f $(DESTDIR)$(PREFIX)$(LIBDIR)/$$f; done
	for f in ${LISTS}; do rm -f $(DESTDIR)$(PREFIX)$(DATADIR)/package-lists/$$f; done
	for f in ${LANG}; do rm -f $(DESTDIR)$(PREFIX)$(DATADIR)/translations/$$f; done
	for f in ${ICONS}; do rm -f $(DESTDIR)$(PREFIX)/share/icons/hicolor/48x48/apps/$$f; done
	for f in ${LAUNCHER}; do rm -f $(DESTDIR)$(PREFIX)/share/applications/$$f; done
	for f in ${DIALOGRC}; do rm -f $(DESTDIR)$(PREFIX)$(DATADIR)/$$f; done
	for f in ${LIVE}; do rm -f $(DESTDIR)/etc/skel/.config/autostart/$$f; done

install: install

uninstall: uninstall

dist:
	git archive --format=tar --prefix=manjaro-architect-$(Version)/ $(Version) | gzip -9 > manjaro-architect-$(Version).tar.gz
	gpg --detach-sign --use-agent manjaro-architect-$(Version).tar.gz

.PHONY: all clean install uninstall dist
