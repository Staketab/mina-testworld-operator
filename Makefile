include .env
COMPOSE_ALL_FILES := -f docker-compose.operator.yml -f docker-compose.load-tester.yml -f docker-compose.node-exporter.yml
COMPOSE_OPERATOR := -f docker-compose.operator.yml
COMPOSE_LOAD_TESTER := -f docker-compose.load-tester.yml
COMPOSE_NODE_EXPORTER := -f docker-compose.node-exporter.yml
SERVICES := operator load-tester node-exporter

compose_v2_not_supported = $(shell command docker compose 2> /dev/null)
ifeq (,$(compose_v2_not_supported))
  DOCKER_COMPOSE_COMMAND = docker-compose
else
  DOCKER_COMPOSE_COMMAND = docker compose
endif

# --------------------------
.PHONY: keystore setup op lt nodex op-down lt-down nodex-down logs

keystore:
	sudo docker run --interactive --tty --rm --entrypoint=mina-libp2p-generate-keypair --volume $(pwd)/keys:/keys ${MINA} --privkey-path ${LIBP2P_KEYPATH}

setup:		    ## Generate LIB_P2P Keystore.
	@make keystore

op:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_OPERATOR} up -d

lt:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_LOAD_TESTER} up -d

nodex:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_NODE_EXPORTER} up -d

op-down:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_OPERATOR} down

lt-down:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_LOAD_TESTER} down

nodex-down:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_NODE_EXPORTER} down

logs:
	$(DOCKER_COMPOSE_COMMAND) logs -f