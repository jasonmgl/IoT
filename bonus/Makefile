re: purge up

up:
	@sudo bash scripts/install.sh
	@sudo k3d cluster start bonus

purge:
	@sudo bash scripts/uninstall.sh

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: up purge re test help
