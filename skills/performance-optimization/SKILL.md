---
name: performance-optimization
description: Use when diagnosing slow code, optimizing queries, reducing latency, or profiling application performance
---

# Performance Optimization

## Overview

Measure first, optimize second. Never optimize without profiling data — intuition about bottlenecks is wrong ~90% of the time.

**Core principle:** Profile → Identify bottleneck → Fix → Measure improvement → Repeat.

## When to Use

- Slow API responses or page loads
- High CPU/memory usage
- Database query performance issues
- Before scaling infrastructure (optimize first, scale second)

## The Optimization Loop

```
1. Define target metric (e.g., p95 < 200ms)
2. Profile to find actual bottleneck
3. Fix the #1 bottleneck only
4. Measure — did it improve?
5. Repeat until target met
```

## Common Bottlenecks by Layer

### Database (most common)
- N+1 queries → eager loading / batch queries
- Missing indexes → add index on WHERE/JOIN/ORDER columns
- Full table scans → check EXPLAIN plan
- Over-fetching → SELECT only needed columns

### Application
- Synchronous I/O → async/concurrent
- Unnecessary computation in hot paths → cache or precompute
- Memory leaks → profile heap, check for growing collections
- Serialization overhead → use faster serializer or reduce payload

### Network
- Too many round trips → batch requests, GraphQL
- Large payloads → compress, paginate, lazy load
- No caching → add Cache-Control headers, ETags
- DNS/TLS overhead → connection pooling, keep-alive

### Frontend
- Large bundle → code splitting, tree shaking
- Render blocking → lazy load below-fold content
- Too many re-renders → memoize, virtualize lists
- Unoptimized images → WebP, responsive sizes, CDN

## Anti-Patterns

| Pattern | Problem |
|---------|---------|
| Premature optimization | Wasting time on non-bottlenecks |
| Optimizing without measuring | No proof it helped |
| Micro-optimizing | Loop tricks save nanoseconds, architecture saves seconds |
| Caching everything | Cache invalidation bugs, stale data |

## Integration

- **magic-powers:database-optimization** — deep dive on query performance
- **magic-powers:caching-strategy** — when caching is the right fix
- **magic-powers:infrastructure-review** — when scaling is needed after optimization
