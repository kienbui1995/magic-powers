---
name: api-design
description: Use when designing REST or GraphQL APIs - endpoint naming, versioning, error handling, pagination, authentication patterns
---

# API Design

## Overview

Good APIs are consistent, predictable, and hard to misuse. Design for the consumer, not the implementation.

## When to Use

- Creating new API endpoints or services
- Reviewing existing API design
- Planning API versioning strategy
- Designing error responses or pagination

## REST Design Rules

### URL Structure
```
GET    /api/v1/users          → List users
GET    /api/v1/users/:id      → Get user
POST   /api/v1/users          → Create user
PUT    /api/v1/users/:id      → Full update
PATCH  /api/v1/users/:id      → Partial update
DELETE /api/v1/users/:id      → Delete user
```

- Nouns, not verbs (`/users` not `/getUsers`)
- Plural resources (`/users` not `/user`)
- Nested for relationships: `/users/:id/orders`
- Max 2 levels of nesting — beyond that, use query params or top-level resource

### Response Format
```json
{
  "data": { ... },
  "meta": { "page": 1, "total": 100 },
  "errors": []
}
```

### Error Responses
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable description",
    "details": [{ "field": "email", "issue": "invalid format" }]
  }
}
```

Use standard HTTP status codes: 200, 201, 204, 400, 401, 403, 404, 409, 422, 429, 500.

### Pagination
```
GET /api/v1/users?page=2&per_page=20
GET /api/v1/users?cursor=abc123&limit=20  (preferred for large datasets)
```

### Versioning
- URL path: `/api/v1/` (simplest, recommended)
- Header: `Accept: application/vnd.api+json;version=1` (cleaner but harder to test)

## GraphQL Design Rules

- One graph, not REST-over-GraphQL
- Use connections pattern for pagination (edges/nodes/pageInfo)
- Input types for mutations: `createUser(input: CreateUserInput!)`
- Return affected object from mutations
- Use enums for fixed sets, not strings

## Checklist

- [ ] Consistent naming conventions across all endpoints
- [ ] Proper HTTP methods and status codes
- [ ] Pagination on all list endpoints
- [ ] Rate limiting headers (`X-RateLimit-*`)
- [ ] Authentication documented (Bearer token, API key)
- [ ] Versioning strategy defined
- [ ] Error format standardized
- [ ] OpenAPI/GraphQL schema documented

## Integration

- **magic-powers:security-review** — review auth and input validation
- **magic-powers:technical-writing** — generate API documentation
