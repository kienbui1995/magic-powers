---
name: database-optimization
description: Use when reviewing database schemas, slow queries, missing indexes, or planning migrations
---

# Database Optimization

## When to Use
When designing schemas, reviewing slow queries, planning migrations, or auditing database performance.

## Process

1. **Schema review** — normalization, types, constraints, naming
2. **Index analysis** — identify missing indexes from query patterns
3. **Query optimization** — rewrite N+1, subqueries, full scans
4. **Migration safety** — check for locks, data loss, rollback plan

## Schema Checklist
- [ ] Primary keys on all tables
- [ ] Foreign keys with appropriate ON DELETE
- [ ] NOT NULL where business logic requires
- [ ] Appropriate column types (no text for dates, etc.)
- [ ] Created/updated timestamps
- [ ] Indexes on foreign keys and frequent WHERE/JOIN columns

## Query Red Flags
- `SELECT *` in production code
- Missing `LIMIT` on unbounded queries
- N+1 query patterns (loop of individual selects)
- Subqueries that could be JOINs
- Missing indexes on WHERE/ORDER BY columns
- Full table scans on large tables

## Migration Safety
- Add columns as nullable first, backfill, then add NOT NULL
- Create indexes CONCURRENTLY when possible
- Never rename columns in one step — add new, migrate, drop old
- Always include rollback migration
- Test on production-size dataset

## Output Format
- 🔴 **Critical** — data loss risk or production outage
- 🟡 **Warning** — performance issue or schema smell
- 🟢 **Suggestion** — optimization opportunity
