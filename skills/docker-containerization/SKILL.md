---
name: docker-containerization
description: Use when creating Dockerfiles, docker-compose configs, optimizing container images, or setting up containerized development environments
---

# Docker & Containerization

## Overview

Containers should be small, secure, and reproducible. A good Dockerfile builds fast, runs lean, and has no secrets baked in.

## When to Use

- Creating Dockerfiles for new projects
- Optimizing image size or build time
- Setting up docker-compose for local development
- Reviewing container security

## Multi-Stage Build Pattern

```dockerfile
# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Stage 2: Runtime
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
USER node
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

## Best Practices

- **Small base images** — use `alpine` or `distroless`, not `ubuntu`
- **Multi-stage builds** — build deps don't belong in runtime image
- **Layer ordering** — copy `package.json` before source code (cache deps layer)
- **Non-root user** — always `USER node` or `USER appuser`
- **No secrets in image** — use env vars, mounted secrets, or build args (not COPY)
- **.dockerignore** — exclude `node_modules`, `.git`, `.env`, test files
- **Pin versions** — `node:20.11-alpine` not `node:latest`
- **Health checks** — `HEALTHCHECK CMD curl -f http://localhost:3000/health`
- **One process per container** — don't run supervisor/multiple services

## Image Size Targets

| Stack | Target Size |
|-------|-------------|
| Node.js | <150MB |
| Python | <200MB |
| Go | <20MB (static binary) |
| Java | <200MB (JRE slim) |

## Docker Compose for Dev

```yaml
services:
  app:
    build: .
    ports: ["3000:3000"]
    volumes: ["./src:/app/src"]  # hot reload
    env_file: .env
    depends_on:
      db: { condition: service_healthy }
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: app
      POSTGRES_PASSWORD: dev
    healthcheck:
      test: ["CMD-SHELL", "pg_isready"]
      interval: 5s
```

## Security Checklist

- [ ] Non-root user
- [ ] No secrets in image layers
- [ ] Pinned base image versions
- [ ] Minimal packages installed (no curl/wget in prod unless needed)
- [ ] Read-only filesystem where possible
- [ ] Scan with `docker scout` or `trivy`

## Integration

- **magic-powers:ci-cd-pipeline** — build and push images in CI
- **magic-powers:infrastructure-review** — review container orchestration
- **magic-powers:environment-setup** — containerized dev environments
