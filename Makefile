SCRIPTS = \
	pomerge.in \
	poscatter.in \
	string-kde4-checkup.in \
	string-lookup.in \
	string-lookup-2.in \
	string-obsolete.in \
	string-pack.in \
	string-update.in

prefix ?= /usr/local

setpath: $(SCRIPTS)
	for script in $(SCRIPTS); do \
		sed -e "s:_PREFIX_:$(prefix):" $$script > $${script/.in} ; \
	done

install: setpath
	test -d $(DESTDIR) || mkdir -p $(DESTDIR) ; \
	test -d $(DESTDIR)/$(prefix)/bin || mkdir -p $(DESTDIR)/$(prefix)/bin ; \
	test -d $(DESTDIR)/$(prefix)/share/kde-l10n-scripts/ || mkdir -p $(DESTDIR)/$(prefix)/share/kde-l10n-scripts/ ; \
	for script in $(SCRIPTS); do \
		install -m 0755 $${script/.in} $(DESTDIR)/$(prefix)/bin ; \
	done ; \
	install -m 0644 common.sh $(DESTDIR)/$(prefix)/share/kde-l10n-scripts/

clean:
	for script in $(SCRIPTS); do \
		rm -rf $${script/.in} ; \
	done

.PHONY: install setpath clean
