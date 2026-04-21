re: purge up

up:
	@sudo bash scripts/install.sh
	@sudo k3d cluster start p3

purge:
	@sudo bash scripts/uninstall.sh
	@sudo bash scripts/remove-docker.sh || true

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: up purge re help
