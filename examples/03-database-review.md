# Example: Database Schema Review

Using database-optimizer and security-reviewer together for a schema change.

## Scenario

You're adding a `payments` table and want it reviewed before migration.

## 1. Schema Review (Sonnet)

```
You: @database-optimizer Review this migration adding a payments table:
     - id, user_id (FK), amount, currency, status, provider_ref, created_at
     - Index on user_id and status
```

Database optimizer checks:
- Missing `updated_at` column
- Suggests composite index on `(user_id, created_at)` for user payment history
- Recommends `DECIMAL` over `FLOAT` for amount
- Suggests partial index on `status = 'pending'` for payment processing queries

## 2. Security Check (Haiku)

```
You: @security-reviewer Check the payments table and API for security issues.
```

Security reviewer flags:
- PCI compliance: don't store full card numbers
- Ensure `provider_ref` is not logged
- Add row-level security if multi-tenant
- Verify amount validation (no negative values)

## Cost: ~$0.08 total

> **Note:** Cost figures are estimates based on Anthropic API pricing as of early 2025. Actual costs vary by input/output length. See [Anthropic pricing](https://www.anthropic.com/pricing) for current rates.
