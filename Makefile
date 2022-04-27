# ============== DOCKER =================

# Basic commands
image_build:
	docker build -t book_notes/server .

start:
	docker run book_notes/server

stop:
	docker stop book_notes/server

# Envirunments
docker_dev_run:
	docker-compose -f ./docker/dev/docker-compose.yaml up

docker_prod_run:
	docker-compose -f ./docker/prod/docker-compose.yaml up

# ============== TESTS ===================
test_unit:
	dart test test/unit

test_integration:
	dart test test/integration