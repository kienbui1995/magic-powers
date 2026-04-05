---
name: caching-strategy
description: Use when implementing caching - Redis, CDN, HTTP cache headers, application-level memoization, or cache invalidation patterns
---

# Caching Strategy

## Overview

Caching trades freshness for speed. The hard part isn't adding a cache — it's invalidating it correctly.

**Core principle:** Cache at the right layer, with the right TTL, and a clear invalidation strategy.

## When to Use

- Slow API responses that serve repeated data
- High database load from identical queries
- Static assets delivery optimization
- Reducing third-party API calls

## Cache Layers (top to bottom)

| Layer | TTL | Best For |
|-------|-----|----------|
| **CDN** (Cloudflare, CloudFront) | Hours-days | Static assets, public pages |
| **HTTP cache** (browser) | Minutes-hours | API responses, images |
| **Application cache** (Redis/Memcached) | Seconds-minutes | DB query results, computed data |
| **In-process** (memoization) | Request lifetime | Expensive computations within a request |

## Cache-Aside Pattern (most common)

```
1. Check cache for key
2. Cache hit → return cached value
3. Cache miss → fetch from source, store in cache, return
```

## Invalidation Strategies

| Strategy | How | Use When |
|----------|-----|----------|
| **TTL expiry** | Set expiration time | Data can be slightly stale |
| **Write-through** | Update cache on every write | Strong consistency needed |
| **Event-driven** | Invalidate on data change event | Microservices, async systems |
| **Cache tags** | Tag entries, purge by tag | Related data changes together |

## HTTP Cache Headers

```
# Immutable static assets (hashed filenames)
Cache-Control: public, max-age=31536000, immutable

# API responses (revalidate)
Cache-Control: private, max-age=0, must-revalidate
ETag: "abc123"

# No caching
Cache-Control: no-store
```

## Anti-Patterns

| Pattern | Problem |
|---------|---------|
| Cache everything | Stale data bugs, memory waste |
| No TTL | Cache grows forever |
| Cache without invalidation plan | Stale data served indefinitely |
| Caching user-specific data in shared cache | Data leaks between users |
| Cache stampede | All caches expire simultaneously → DB overload |

## Redis Quick Reference

```bash
SET user:123 '{"name":"..."}' EX 300    # 5 min TTL
GET user:123
DEL user:123                              # Invalidate
```

## Integration

- **magic-powers:performance-optimization** — identify what to cache via profiling
- **magic-powers:infrastructure-review** — review cache infrastructure
- **magic-powers:database-optimization** — reduce DB load with query caching
