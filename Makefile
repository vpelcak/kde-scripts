SCRIPTS = \
	lookup \
	lookup2 \
	obsol \
	pology \
	pomerge \
	poscatter

prefix ?= /usr/local

setpath:
	sed -i -e "s:_PREFIX_:$(prefix):" $(SCRIPTS)

install: setpath
	test -d $(DESTDIR) || mkdir -p $(DESTDIR) ; \
	test -d $(DESTDIR)/$(prefix)/bin || mkdir -p $(DESTDIR)/$(prefix)/bin ; \
	test -d $(DESTDIR)/$(prefix)/share/kde-l10n-scripts/ || mkdir -p $(DESTDIR)/$(prefix)/share/kde-l10n-scripts/ ; \
	for script in $(SCRIPTS); do \
		install -m 0755 $$script $(DESTDIR)/$(prefix)/bin ; \
	done ; \
	install -m 0644 common.sh $(DESTDIR)/$(prefix)/share/kde-l10n-scripts/

.PHONY: install setpath
