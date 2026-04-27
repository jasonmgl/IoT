TOOLBOX=$(sudo kubectl -n gitlab get pod -l app=toolbox -o jsonpath='{.items[0].metadata.name}')

re: purge up

up:
	@sudo bash scripts/install.sh
	@sudo k3d cluster start bonus

purge:
	@sudo bash scripts/uninstall.sh

test:
	@sudo kubectl -n gitlab exec "$(sudo kubectl -n gitlab get pod -l app=toolbox -o jsonpath='{.items[0].metadata.name}')" -- gitlab-rails runner 'puts "users=#{User.count}"'

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: up purge re test help
