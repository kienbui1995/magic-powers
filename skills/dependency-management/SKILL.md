---
name: dependency-management
description: Use when updating packages, auditing vulnerabilities, managing version pinning, or evaluating new dependencies
---

# Dependency Management

## Overview

Every dependency is a liability — it can break, have vulnerabilities, or become unmaintained. Be deliberate about what you add and keep it updated.

## When to Use

- Adding new dependencies to a project
- Running security audits
- Updating outdated packages
- Evaluating whether to add vs. build

## Adding Dependencies — Decision Framework

```
Do I really need this package?
├── Can I write it in <50 lines? → Write it yourself
├── Is it a core utility (lodash for 1 function)? → Import just that function or skip
├── Check: maintained? >1000 weekly downloads? Recent commits? → No? Skip it
└── Yes to all → Add it, pin the version
```

## Version Pinning Strategy

| Environment | Strategy | Example |
|-------------|----------|---------|
| App (deployed) | Pin exact | `"express": "4.18.2"` |
| Library (published) | Range | `"express": "^4.18.0"` |
| Lock file | Always commit | `package-lock.json`, `poetry.lock` |

## Security Audit Workflow

```bash
# Node.js
npm audit
npm audit fix

# Python
pip-audit
safety check

# General
snyk test
```

**Schedule:** Run `npm audit` / `pip-audit` weekly in CI. Block merges on critical/high vulnerabilities.

## Update Strategy

1. **Patch updates** (4.18.1 → 4.18.2) — auto-merge via Dependabot/Renovate
2. **Minor updates** (4.18 → 4.19) — review changelog, run tests, merge
3. **Major updates** (4.x → 5.x) — dedicated PR, read migration guide, test thoroughly

## Checklist

- [ ] Lock file committed to git
- [ ] No unused dependencies (`depcheck`, `pip-extra-reqs`)
- [ ] Security audit passes (no critical/high)
- [ ] Dependabot or Renovate configured
- [ ] License compatibility checked for new deps

## Integration

- **magic-powers:ci-cd-pipeline** — run audit in CI
- **magic-powers:security-review** — review dependency security posture
