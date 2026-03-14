PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin
SCRIPT  = ros-kill-all

.PHONY: all install uninstall test lint

all:
	@echo "ros-kill-all is a shell script — nothing to compile."
	@echo "Run 'make install' to install system-wide."

install:
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 $(SCRIPT) $(DESTDIR)$(BINDIR)/$(SCRIPT)
	@echo "Installed to $(DESTDIR)$(BINDIR)/$(SCRIPT)"

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(SCRIPT)
	@echo "Uninstalled $(SCRIPT)"

test:
	@echo "── Running tests ──────────────────────"
	@bash -n $(SCRIPT) && echo "  syntax: OK"
	@./$(SCRIPT) --version
	@./$(SCRIPT) --help > /dev/null && echo "  --help: OK"
	@./$(SCRIPT) --list > /dev/null && echo "  --list: OK"
	@./$(SCRIPT) --dry-run > /dev/null && echo "  --dry-run: OK"
	@echo "── All tests passed ───────────────────"

lint:
	@command -v shellcheck >/dev/null 2>&1 || \
		{ echo "shellcheck not found — install with: apt install shellcheck"; exit 1; }
	shellcheck $(SCRIPT)
	@echo "shellcheck: OK"
