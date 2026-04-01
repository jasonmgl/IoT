re: fclean up

up:
	@vagrant validate && vagrant up --provider=virtualbox

provision:
	@vagrant provision

down:
	@vagrant halt

clean: down
	@rm -rf ./.node-token

fclean: clean
	@vagrant destroy -f
	@rm -rf .vagrant

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: fclean clean up down provision re help