CLUSTER_IP := 192.168.56.110

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
	@curl -fsS -H "Host:app1.local" http://$(CLUSTER_IP) >/dev/null && echo "app1: Ok" || true
	@curl -fsS -H "Host:app2.local" http://$(CLUSTER_IP) >/dev/null && echo "app2: Ok" || true
	@curl -fsS -H "Host:app3.local" http://$(CLUSTER_IP) >/dev/null && echo "app3: Ok" || true

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: fclean clean up down provision re test help
