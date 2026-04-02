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

test:
	@curl -v -H "Host:app1.local" 192.168.56.110
	@curl -v -H "Host:app2.local" 192.168.56.110
	@curl -v -H "Host:app2.local" 192.168.56.110
	@curl -v -H "Host:app2.local" 192.168.56.110
	@curl -v -H "Host:app3.local" 192.168.56.110

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: fclean clean up down provision re test help
