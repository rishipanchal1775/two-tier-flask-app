OS := $(shell uname)

DOCKER_COMPOSE := docker compose

build:
	@echo "Building for $(OS)"
	$(DOCKER_COMPOSE) build

run:
	@echo "Running for $(OS)"
	$(DOCKER_COMPOSE) up -d

stop:
	$(DOCKER_COMPOSE) down

clean: stop
	$(DOCKER_COMPOSE) rm -f
	docker system prune -f

