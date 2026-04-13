re: clean up

up:
	@sudo bash scripts/init.sh
	@sudo k3d cluster start p3

purge:
	@sudo rm -f /usr/local/bin/kubectl
	@sudo rm -f /usr/local/bin/k3d
	@sudo rm -f /usr/local/bin/argocd
	@sudo bash scripts/remove-docker.sh || true

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: up purge re help
