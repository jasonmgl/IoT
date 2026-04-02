re: clean up

up:
	@sudo bash scripts/setup_vm.sh

clean:
	@sudo rm -f /usr/local/bin/kubectl
	@sudo rm -f /usr/local/bin/k3d
	-@sudo bash scripts/remove-docker.sh

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: up clean re help
