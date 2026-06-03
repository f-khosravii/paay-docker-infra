# Infrastructure

Docker-based local infrastructure setup for development environments.

## Services

* PostgreSQL 17
* Redis 8

---

# Requirements

* Docker
* Docker Compose
* GNU Make

---

# Project Structure

```txt
.
├── .env
├── .env.example
├── Makefile
│
├── postgres/
│   ├── docker-compose.yml
│   ├── .env
│   ├── .env.example
│   └── data/
│
└── redis/
    ├── docker-compose.yml
    ├── redis.conf
    ├── .env
    ├── .env.example
    └── data/
```

---

# Setup

## 1. Copy environment files

```bash
cp .env.example .env
cp postgres/.env.example postgres/.env
cp redis/.env.example redis/.env
```

## 2. Fill in the values

**`.env`** (root — shared config):
```env
DOCKER_NETWORK=backend
```

**`postgres/.env`**:
```env
POSTGRES_PORT=5432
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=
DOCKER_NETWORK=backend
```

**`redis/.env`**:
```env
REDIS_PORT=6379
REDIS_PASSWORD=
DOCKER_NETWORK=backend
```

## 3. Start all services

```bash
make init
```

This creates the Docker network and starts all services.

---

# Available Commands

## All services

| Command | Description |
|---------|-------------|
| `make init` | Create network and start all services |
| `make up` | Start all services |
| `make down` | Stop all services |
| `make restart` | Restart all services |
| `make logs` | Follow logs for all services |
| `make ps` | Show running containers |
| `make clean` | Stop all services and remove volumes |

## PostgreSQL

| Command | Description |
|---------|-------------|
| `make postgres-up` | Start PostgreSQL |
| `make postgres-down` | Stop PostgreSQL |
| `make postgres-restart` | Restart PostgreSQL |
| `make postgres-logs` | Follow PostgreSQL logs |
| `make postgres-exec` | Open psql shell inside container |
| `make postgres-clean` | Stop and remove PostgreSQL volumes |

## Redis

| Command | Description |
|---------|-------------|
| `make redis-up` | Start Redis |
| `make redis-down` | Stop Redis |
| `make redis-restart` | Restart Redis |
| `make redis-logs` | Follow Redis logs |
| `make redis-exec` | Open redis-cli inside container |
| `make redis-clean` | Stop and remove Redis volumes |

## Network

| Command | Description |
|---------|-------------|
| `make network` | Create Docker network |

---

# Running Services Individually

Each service is fully independent and can be run on its own. The Docker network must exist beforehand:

```bash
# Create the network
make network

# Start only PostgreSQL
cd postgres && docker compose up -d

# Start only Redis
cd redis && docker compose up -d
```

> The network name is read from `DOCKER_NETWORK` in each service's `.env` file.

---

# PostgreSQL

Default port: `5432`

Configuration (`postgres/.env`):

```env
POSTGRES_PORT=5432
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=
DOCKER_NETWORK=backend
```

---

# Redis

Default port: `6379`

Configuration (`redis/.env`):

```env
REDIS_PORT=6379
REDIS_PASSWORD=
DOCKER_NETWORK=backend
```

---

# Health Checks

Both services include Docker health checks. Check their status with:

```bash
make ps
```

---

# Cleanup

> ⚠️ This command removes all containers **and database data**.

```bash
# Remove everything
make clean

# Remove only PostgreSQL data
make postgres-clean

# Remove only Redis data
make redis-clean
```

---

# Notes

* Do not commit `.env` files.
* Do not commit `data/` directories.
* Copy all `.env.example` files before starting services.
* The Docker network name is configured via `DOCKER_NETWORK` in each `.env` file.