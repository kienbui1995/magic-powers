---
name: environment-setup
description: Use when bootstrapping new projects, setting up dev environments, writing onboarding docs, or configuring local development tooling
---

# Environment Setup

## Overview

A new developer should go from `git clone` to running the app in under 15 minutes. If it takes longer, your setup is broken.

## When to Use

- Starting a new project from scratch
- Onboarding new team members
- Standardizing dev environments across team
- Writing setup documentation

## The 15-Minute Rule

```
git clone → install deps → copy env → start → working app
```

Every project needs a `README.md` with these exact steps. If any step requires tribal knowledge, document it.

## Essential Project Files

| File | Purpose |
|------|---------|
| `README.md` | Setup instructions, architecture overview |
| `.env.example` | All env vars with dummy values and comments |
| `.editorconfig` | Consistent formatting across editors |
| `.gitignore` | Exclude build artifacts, deps, secrets |
| `Makefile` or `package.json` scripts | Common commands (`make dev`, `npm run dev`) |
| `docker-compose.yml` | Local services (DB, Redis, etc.) |

## .env.example Pattern

```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/myapp

# Auth
JWT_SECRET=change-me-in-production

# External APIs
STRIPE_KEY=sk_test_...
```

**Rule:** `.env.example` committed to git, `.env` in `.gitignore`.

## One-Command Setup

```bash
# Makefile
setup:
	cp .env.example .env
	docker-compose up -d
	npm install
	npm run db:migrate
	npm run db:seed
	@echo "Ready! Run 'make dev' to start."

dev:
	npm run dev
```

## Checklist

- [ ] `README.md` has step-by-step setup instructions
- [ ] `.env.example` has all required variables with comments
- [ ] `make setup` or equivalent one-command bootstrap
- [ ] Local services via docker-compose (DB, cache, etc.)
- [ ] Seed data for development
- [ ] Works on macOS and Linux (document Windows if supported)

## Integration

- **magic-powers:docker-containerization** — containerized dev environment
- **magic-powers:technical-writing** — write clear onboarding docs
- **magic-powers:dependency-management** — lock file and version management
