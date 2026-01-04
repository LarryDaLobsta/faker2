# Faker2.0

Faker2.0 is a backend-focused data generation service written in Go.  
The goal of this project is **not** to be a full-featured product yet, but to serve as a practical, evolving codebase for sharpening real-world backend engineering skills.

This repository emphasizes:
- clear separation of concerns
- production-grade tooling
- explicit resource management
- reproducible data generation

---

## Why This Project Exists

I’m using this project to deepen my understanding of modern Go backend development by building something end-to-end with real constraints.

Specifically, this project focuses on:

- **Go context usage**
  - `context.Context` for cancellation, timeouts, and background work
  - separating HTTP framework context from Go’s standard context

- **Concurrency & lifecycle management**
  - `defer` for cleanup
  - proper use of connection pools
  - understanding when and why to close resources

- **Backend architecture**
  - HTTP handlers (Fiber)
  - business logic / validation layer
  - data access layer (sqlc)
  - clean dependency boundaries

- **Database-first development**
  - schema migrations with `golang-migrate`
  - Postgres as the source of truth
  - explicit constraints and indexes
  - cascade deletes and ownership modeling

- **Type-safe database access**
  - raw SQL queries
  - compile-time safety with `sqlc`
  - no ORMs

The project is intentionally scoped to remain understandable while still reflecting how real backend systems are built.

---

## What Faker2.0 Does (Current Scope)

- Allows creation of **dataset “runs”**
  - A dataset represents a generation request (parameters + seed)
- Stores generation parameters for auditability and reproducibility
- Links generated records back to the dataset that created them
- Exposes health checks and database readiness endpoints

Future iterations will add:
- random data generation
- CSV export
- a lightweight UI for dataset history and inspection

---

## Tech Stack

- **Language:** Go
- **HTTP Framework:** Fiber
- **Database:** PostgreSQL
- **Migrations:** golang-migrate
- **Query Generation:** sqlc
- **Containerization:** Docker (for Postgres only)

---

## Project Structure (High-Level)
cmd/api/           # Application entrypoint
internal/
db/              # DB pool + sqlc generated code
http/            # HTTP handlers / routes
service/         # Business logic & validation
repo/            # Data access layer (sqlc wrappers)
gen/              # Random data generation (planned)
migrations/        # Database schema migrations

---

## Running the Project Locally

### Requirements
- Go 1.22+
- Docker Desktop
- Postgres client tools (optional)

### Start Postgres
```bash
docker compose up -d

migrate -path migrations \
  -database "postgres://faker2:faker2@localhost:5432/faker2?sslmode=disable" \
  up

sqlc generate -f internal/db/sqlc.yaml

go run ./cmd/api

Health checks
	•	GET /health
	•	GET /db/health

⸻

Branching Strategy
	•	main → stable, documented, runnable
	•	dev → active development

All new work happens on dev and is merged into main when stable.

⸻

Status

This project is under active development and intentionally evolving.
Breaking changes may occur on the dev branch.

The focus is correctness, clarity, and learning—not speed.