---
name: authentication-patterns
description: Use when implementing auth - OAuth 2.0, JWT, session management, API keys, RBAC, or reviewing auth security
---

# Authentication Patterns

## Overview

Auth is the most security-critical part of any application. Use proven patterns, never roll your own crypto.

## When to Use

- Implementing login/signup flows
- Adding OAuth/social login
- Designing API authentication
- Reviewing auth security
- Implementing role-based access control

## Pattern Selection

| Pattern | Best For | Avoid When |
|---------|----------|------------|
| Session + cookie | Server-rendered web apps | Mobile/SPA without same-origin |
| JWT (access + refresh) | SPAs, mobile apps, microservices | Simple server-rendered apps |
| OAuth 2.0 + OIDC | Social login, SSO, third-party auth | Internal-only tools |
| API keys | Server-to-server, public APIs | User-facing auth |

## JWT Best Practices

- **Short-lived access tokens** — 15 minutes max
- **Long-lived refresh tokens** — stored in httpOnly cookie, rotated on use
- **Never store JWTs in localStorage** — XSS vulnerable
- **Include minimal claims** — user ID, roles. Not PII.
- **Validate on every request** — check signature, expiry, issuer
- **Use RS256 or ES256** — not HS256 for distributed systems

## OAuth 2.0 Flow (Authorization Code + PKCE)

```
1. Client generates code_verifier + code_challenge
2. Redirect to /authorize?response_type=code&code_challenge=...
3. User authenticates with provider
4. Provider redirects back with authorization code
5. Client exchanges code + code_verifier for tokens
6. Store access token in memory, refresh token in httpOnly cookie
```

## Security Checklist

- [ ] Passwords hashed with bcrypt/argon2 (cost factor ≥12)
- [ ] Rate limiting on login endpoints
- [ ] Account lockout after N failed attempts
- [ ] CSRF protection on session-based auth
- [ ] Refresh token rotation (one-time use)
- [ ] Secure cookie flags: `httpOnly`, `secure`, `sameSite=strict`
- [ ] No secrets in JWTs or URLs

## Integration

- **magic-powers:api-design** — auth headers and error responses
- **magic-powers:security-review** — audit auth implementation
