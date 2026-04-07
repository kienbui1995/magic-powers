---
name: api-contract-testing
description: Use when validating API schemas, detecting breaking changes, or setting up consumer-driven contract testing
---

# API Contract Testing

## When to Use
When multiple services or teams consume an API and you need to catch breaking changes before they reach production.

## Core Jobs

### 1. Define the Contract
A contract = what the consumer expects:
- Request format: method, path, required headers, body schema
- Response format: status code, body schema, required fields
- Error responses: what errors can occur, in what format

Use OpenAPI spec as the source of truth. Every endpoint must be documented.

### 2. Consumer-Driven Contract Testing (Pact)
Let consumers define what they expect:
```python
# Consumer test (Python Pact)
@consumer('FrontendApp')
@provider('UserAPI')
def test_get_user(pact):
    pact.given('user 123 exists').upon_receiving('a request for user 123').with_request(
        method='GET', path='/api/v1/users/123'
    ).will_respond_with(200, body=Like({'id': '123', 'email': like('string')}))
```
Provider verifies it can satisfy all consumer contracts before deploying.

### 3. Breaking Change Detection
Breaking changes (always require major version bump):
- Removing a field
- Changing a field type
- Changing an endpoint path
- Making an optional field required
- Changing error format

Non-breaking (safe to add):
- Adding new optional fields
- Adding new endpoints
- Adding new optional parameters

Use tools: Spectral (OpenAPI linting), Optic, or Bump.sh for automated detection.

### 4. Contract Testing in CI
- Consumer pushes contract to Pact Broker on test pass
- Provider verifies contracts before merge
- Deploy only when all consumer contracts pass

## Key Outputs
- OpenAPI spec (source of truth)
- Consumer-driven contract tests (Pact or equivalent)
- Breaking change detection CI step
- Versioning policy

## Anti-Patterns
- Manual API documentation (drifts from implementation)
- Breaking changes with no version bump
- No contract tests — discovering breakage in production
- Consumer contract tests only — provider never verifies
