---
name: technical-documentation
description: Use when writing API docs, runbooks, user guides, architecture docs, or internal wikis
---

# Technical Documentation

## When to Use
When writing documentation that engineers, operators, or technical users will rely on to understand or operate a system.

## Core Jobs

### 1. Choose the Doc Type
| Type | Audience | Goal | Example |
|------|----------|------|---------|
| Tutorial | Beginners | Learning by doing | "Build your first API integration" |
| How-to guide | Intermediate | Achieve specific goal | "How to configure SSO" |
| Reference | Experienced | Lookup information | API endpoint reference |
| Explanation | Anyone | Understand why | "How our auth system works" |

Match the type to what the reader actually needs.

### 2. Writing Principles
- **Docs are code**: version them in git, review them like PRs
- **Test every code example**: if it doesn't run, don't publish it
- **Lead with the outcome**: what will they achieve by reading this?
- **Use second person**: "You will configure..." not "The user configures..."
- **Short sentences**: one idea per sentence
- **Active voice**: "Click Save" not "The Save button should be clicked"

### 3. API Reference Structure
Per endpoint:
```
## POST /api/v1/users

Create a new user account.

**Request**
Headers: Authorization: Bearer {token}
Body: { "email": "string", "name": "string" }

**Response (201)**
{ "id": "uuid", "email": "string", "created_at": "iso8601" }

**Errors**
400: Validation error (missing required field)
409: Email already exists
```

### 4. Keep Docs Current
- Add docs to Definition of Done for every feature
- Review docs in PRs (not separately)
- Measure: track docs pages with no updates in 6+ months
- Delete outdated docs — stale docs are worse than no docs

## Key Outputs
- Documentation structured by type (tutorial, reference, etc.)
- Code examples that are tested in CI
- Docs maintenance process

## Anti-Patterns
- Writing docs after launch (never gets done)
- Docs that describe the desired state, not actual behavior
- No examples — abstract descriptions without "show me"
- Single long page instead of structured hierarchy
