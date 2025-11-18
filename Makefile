.POSIX:

PREFIX = /usr/local

all:
	for f in *; \
	do \
		if grep -E -n -e '#!' "$$f" | grep -E -q -e '^1:'; \
		then \
			chmod a+rx "$$f"; \
		fi; \
	done

clean:
	true
	
install:
	for f in *; \
	do \
		if [ -x "$$f" ]; \
		then \
			cp "$$f" "$(ROOTDIR)$(PREFIX)/bin"; \
		fi; \
	done

uninstall:
	for f in *; \
	do \
		fpath="$(ROOTDIR)$(PREFIX)/bin/`basename "$$f"`"; \
		if [ -x "$$fpath" ]; \
		then \
			rm -f "$$fpath"; \
		fi; \
	done

reinstall: uninstall install
