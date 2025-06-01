# BetterGR Microservices Setup

## Development Guidelines

### 1. Go Version Consistency

Make sure each microservice uses the same Go version in both `go.mod` and `Dockerfile`.

**In `go.mod`:**

```go
go 1.24.0
```

**In `Dockerfile`:**

```dockerfile
FROM golang:1.24-alpine AS base
```

---

### 2. Environment Variable Loading in `server.go`

Update all `server.go` files in the microservices to safely load the `.env` file without failing if it’s missing.

** Replace this code:**

```go
err := godotenv.Load()
if err != nil {
    klog.Fatalf("Error loading .env file")
}
```

** With this code:**

```go
if err := godotenv.Load(); err != nil {
    klog.Warning("Warning: No .env file loaded, proceeding with environment variables only")
}
```

---

## Microservices

This repository contains the Docker Compose setup and microservices for the BetterGR system, including services for:

- Students
- Staff
- Courses
- Grades
- Homework
- Keycloak (Auth)
- PostgreSQL (Database)

---

## 🐳 Docker Compose Setup

Run the following command from the `main-root/setup` directory to build and start all services:

```bash
docker compose up --build
```
