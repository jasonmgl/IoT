re: fclean up

up:
	@vagrant validate && vagrant up --provider=virtualbox

provision:
	@vagrant provision

down:
	@vagrant halte

clean:
	@rm -rf ./.node-token

fclean: clean
	@vagrant destroy -f
	@rm -rf .vagrant

.PHONY: fclean clean up down provision