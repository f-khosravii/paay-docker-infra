# زیرساخت (Infrastructure)

راه‌اندازی زیرساخت محلی مبتنی بر Docker برای محیط‌های توسعه.

## سرویس‌ها

* PostgreSQL 17
* Redis 8

---

# پیش‌نیازها

* Docker
* Docker Compose
* GNU Make

---

# ساختار پروژه

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

# راه‌اندازی

## ۱. کپی فایل‌های محیطی

```bash
cp .env.example .env
cp postgres/.env.example postgres/.env
cp redis/.env.example redis/.env
```

## ۲. پر کردن مقادیر

**`.env`** (root — تنظیمات مشترک):
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

## ۳. راه‌اندازی همه سرویس‌ها

```bash
make init
```

این دستور Docker network را می‌سازد و همه سرویس‌ها را بالا می‌آورد.

---

# دستورات موجود

## همه سرویس‌ها

| دستور | توضیح |
|-------|-------|
| `make init` | ساخت network و راه‌اندازی همه سرویس‌ها |
| `make up` | راه‌اندازی همه سرویس‌ها |
| `make down` | توقف همه سرویس‌ها |
| `make restart` | راه‌اندازی مجدد همه سرویس‌ها |
| `make logs` | مشاهده لاگ همه سرویس‌ها |
| `make ps` | نمایش کانتینرهای در حال اجرا |
| `make clean` | توقف همه سرویس‌ها و حذف volume‌ها |

## PostgreSQL

| دستور | توضیح |
|-------|-------|
| `make postgres-up` | راه‌اندازی PostgreSQL |
| `make postgres-down` | توقف PostgreSQL |
| `make postgres-restart` | راه‌اندازی مجدد PostgreSQL |
| `make postgres-logs` | مشاهده لاگ PostgreSQL |
| `make postgres-exec` | ورود به psql داخل کانتینر |
| `make postgres-clean` | توقف و حذف volume های PostgreSQL |

## Redis

| دستور | توضیح |
|-------|-------|
| `make redis-up` | راه‌اندازی Redis |
| `make redis-down` | توقف Redis |
| `make redis-restart` | راه‌اندازی مجدد Redis |
| `make redis-logs` | مشاهده لاگ Redis |
| `make redis-exec` | ورود به redis-cli داخل کانتینر |
| `make redis-clean` | توقف و حذف volume های Redis |

## Network

| دستور | توضیح |
|-------|-------|
| `make network` | ساخت Docker network |

---

# اجرای سرویس‌ها به صورت مجزا

هر سرویس کاملاً مستقل است و می‌تواند به تنهایی اجرا شود. فقط باید network از قبل ساخته شده باشد:

```bash
# ساخت network
make network

# راه‌اندازی فقط PostgreSQL
cd postgres && docker compose up -d

# راه‌اندازی فقط Redis
cd redis && docker compose up -d
```

> نام network از متغیر `DOCKER_NETWORK` در فایل `.env` هر سرویس خوانده می‌شود.

---

# PostgreSQL

پورت پیش‌فرض: `5432`

تنظیمات (`postgres/.env`):

```env
POSTGRES_PORT=5432
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=
DOCKER_NETWORK=backend
```

---

# Redis

پورت پیش‌فرض: `6379`

تنظیمات (`redis/.env`):

```env
REDIS_PORT=6379
REDIS_PASSWORD=
DOCKER_NETWORK=backend
```

---

# Health Check

هر دو سرویس دارای Docker health check هستند. برای مشاهده وضعیت:

```bash
make ps
```

---

# پاک‌سازی

> ⚠️ این دستورات کانتینرها **و داده‌های دیتابیس** را حذف می‌کنند.

```bash
# حذف همه چیز
make clean

# حذف فقط داده‌های PostgreSQL
make postgres-clean

# حذف فقط داده‌های Redis
make redis-clean
```

---

# نکات مهم

* فایل‌های `.env` را commit نکنید.
* پوشه‌های `data/` را commit نکنید.
* قبل از اجرا، تمام فایل‌های `.env.example` را کپی کنید.
* نام Docker network از طریق متغیر `DOCKER_NETWORK` در فایل‌های `.env` تنظیم می‌شود.