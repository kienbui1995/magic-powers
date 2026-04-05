---
name: ci-cd-pipeline
description: Use when setting up or improving CI/CD pipelines - GitHub Actions, automated testing, deployment, release automation
---

# CI/CD Pipeline

## Overview

Automate everything between code push and production deployment. A good pipeline catches bugs early and deploys confidently.

## When to Use

- Setting up CI/CD for a new project
- Adding automated tests to pipeline
- Improving deployment speed or reliability
- Implementing release automation

## Pipeline Stages

```
Push → Lint → Test → Build → Security Scan → Deploy Staging → Deploy Production
```

### Minimum Viable Pipeline
1. **Lint** — catch style/syntax issues instantly
2. **Test** — unit + integration tests
3. **Build** — verify it compiles/bundles
4. **Deploy** — automated to staging, gated to production

## GitHub Actions Template

```yaml
name: CI
on: [push, pull_request]
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4  # or setup-python, etc.
      - run: npm ci
      - run: npm run lint
      - run: npm test
      - run: npm run build
```

## Best Practices

- **Fast feedback** — lint and unit tests should finish in <2 minutes
- **Fail fast** — run cheapest checks first (lint before test before build)
- **Cache dependencies** — `actions/cache` for node_modules, pip cache, etc.
- **Branch protection** — require CI pass before merge
- **Environment secrets** — never hardcode, use GitHub Secrets / Vault
- **Parallel jobs** — split test suites across runners
- **Artifact storage** — save build outputs for deployment stage

## Deployment Strategies

| Strategy | Risk | Rollback | Use When |
|----------|------|----------|----------|
| Rolling | Low | Slow | Default for most apps |
| Blue/Green | Low | Instant | Need instant rollback |
| Canary | Lowest | Fast | High-traffic production |
| Recreate | High | Slow | Dev/staging only |

## Checklist

- [ ] All tests run in CI (not just locally)
- [ ] Pipeline fails on lint errors
- [ ] Secrets stored securely (not in code)
- [ ] Deploy to staging automatically on merge to main
- [ ] Production deploy requires approval or tag
- [ ] Pipeline runs in <10 minutes

## Integration

- **magic-powers:finishing-a-development-branch** — merge workflow that triggers CI
- **magic-powers:docker-containerization** — build container images in CI
- **magic-powers:security-review** — add security scanning to pipeline
