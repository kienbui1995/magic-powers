---
name: security-review
description: Use when reviewing code for security vulnerabilities, auth issues, data exposure, or before deploying to production
---

# Security Review

## When to Use
Before merging PRs, deploying to production, or when handling auth, user input, secrets, or sensitive data.

## Checklist

### Input & Validation
- [ ] All user input validated and sanitized
- [ ] SQL queries parameterized (no string concatenation)
- [ ] File paths validated (no path traversal)
- [ ] Content-Type checked on uploads

### Authentication & Authorization
- [ ] Auth required on all protected endpoints
- [ ] Role/permission checks at handler level
- [ ] Tokens have expiration and rotation
- [ ] No auth bypass via parameter manipulation

### Secrets & Configuration
- [ ] No hardcoded secrets, keys, or passwords
- [ ] Secrets loaded from env vars or secret manager
- [ ] `.env` files in `.gitignore`
- [ ] No secrets in logs or error messages

### Data Exposure
- [ ] Sensitive fields excluded from API responses
- [ ] Error messages don't leak internals
- [ ] Logs scrubbed of PII
- [ ] Debug endpoints disabled in production

### Dependencies
- [ ] No known CVEs in dependencies
- [ ] Lock files committed
- [ ] Minimal dependency surface

## Output Format
- 🔴 **Critical** — exploitable now, block deployment
- 🟡 **Warning** — potential risk, fix before next release
- 🟢 **Info** — hardening suggestion
