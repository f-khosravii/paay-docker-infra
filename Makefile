NETWORK ?= $(shell grep DOCKER_NETWORK .env 2>/dev/null | cut -d '=' -f2 || echo "backend")

.PHONY: up down restart logs ps \
        postgres-up postgres-down postgres-logs postgres-restart postgres-exec \
        redis-up redis-down redis-logs redis-restart redis-exec \
        clean postgres-clean redis-clean \
        network init

# ────────────────────────────────────────
# All services
# ────────────────────────────────────────

up:
	docker compose -f postgres/docker-compose.yml up -d
	docker compose -f redis/docker-compose.yml up -d

down:
	docker compose -f postgres/docker-compose.yml down
	docker compose -f redis/docker-compose.yml down

restart: down up

logs:
	docker compose -f postgres/docker-compose.yml logs -f &
	docker compose -f redis/docker-compose.yml logs -f

ps:
	docker compose -f postgres/docker-compose.yml ps
	docker compose -f redis/docker-compose.yml ps

clean:
	docker compose -f postgres/docker-compose.yml down -v
	docker compose -f redis/docker-compose.yml down -v

# ────────────────────────────────────────
# PostgreSQL
# ────────────────────────────────────────

postgres-up:
	docker compose -f postgres/docker-compose.yml up -d

postgres-down:
	docker compose -f postgres/docker-compose.yml down

postgres-restart: postgres-down postgres-up

postgres-logs:
	docker compose -f postgres/docker-compose.yml logs -f

postgres-clean:
	docker compose -f postgres/docker-compose.yml down -v

postgres-exec:
	docker exec -it infra-postgres psql -U $${POSTGRES_USER} -d $${POSTGRES_DB}

# ────────────────────────────────────────
# Redis
# ────────────────────────────────────────

redis-up:
	docker compose -f redis/docker-compose.yml up -d

redis-down:
	docker compose -f redis/docker-compose.yml down

redis-restart: redis-down redis-up

redis-logs:
	docker compose -f redis/docker-compose.yml logs -f

redis-clean:
	docker compose -f redis/docker-compose.yml down -v

redis-exec:
	docker exec -it infra-redis redis-cli -a $${REDIS_PASSWORD}

# ────────────────────────────────────────
# Network
# ────────────────────────────────────────

network:
	docker network create $(NETWORK) || true

init: network up