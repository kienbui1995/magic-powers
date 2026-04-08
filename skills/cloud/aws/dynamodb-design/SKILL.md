---
name: dynamodb-design
description: Use when designing DynamoDB schemas, choosing partition and sort keys, planning GSI/LSI indexes, selecting capacity modes, or implementing DynamoDB Streams and DAX. Covers AWS DEA-C01 and DVA-C02 NoSQL design domains.
---

# Amazon DynamoDB Design

## When to Use
- Designing a NoSQL schema for a new DynamoDB table
- Choosing partition key and sort key to support required access patterns
- Planning Global Secondary Indexes (GSI) and Local Secondary Indexes (LSI)
- Selecting between Provisioned and On-Demand capacity modes
- Implementing event-driven reactions with DynamoDB Streams + Lambda
- Caching hot read patterns with DAX (DynamoDB Accelerator)
- Preparing for AWS DEA-C01 or DVA-C02 exams

## Core Jobs

### 1. Partition Key Design

- **Partition key = hash key** — determines physical storage partition (1 partition = 10GB, 3000 RCU, 1000 WCU)
- High cardinality keys → even data distribution across partitions
- Avoid hot partition keys (e.g., status field with only 3 values, date field with millions of writes per day)

**Good partition key examples**:
- `user_id` (UUID) — high cardinality, random distribution
- `order_id` (UUID) — unique per order
- `device_id` — high cardinality for IoT

**Hot partition fixes**:
1. **Write sharding**: append random suffix `user_id#1`, `user_id#2` … `user_id#N`; scatter reads across shards then aggregate
2. **Composite key**: combine high-cardinality attribute with time bucket (`user_id#2024-01`)
3. **Partition key + sort key**: use composite primary key to spread items under same "logical" entity

### 2. GSI vs LSI

| Feature | Global Secondary Index (GSI) | Local Secondary Index (LSI) |
|---------|-----------------------------|-----------------------------|
| Partition key | Different from table partition key | SAME as table partition key |
| Sort key | Any attribute (optional) | Different from table sort key |
| Capacity | Separate RCU/WCU from base table | Shares capacity with base table |
| Consistency | Eventually consistent ONLY | Supports strongly consistent reads |
| Size limit | No constraint per partition | 10GB per partition key value |
| Creation time | Anytime (even after table creation) | ONLY at table creation time |
| Max per table | 20 GSIs | 5 LSIs |
| Projection | Can project any attributes | Can project any attributes |

**GSI use case**: Query orders by customer email (different partition key than order_id):
```
Table: PK=order_id, SK=timestamp
GSI: PK=customer_email, SK=order_date
```

**LSI use case**: Query user's posts sorted by likes (same user_id partition, different sort):
```
Table: PK=user_id, SK=post_date
LSI: PK=user_id, SK=like_count
```

### 3. Capacity Mode Selection

| Mode | Pricing | Best For | Scaling |
|------|---------|---------|---------|
| **Provisioned** | Per RCU/WCU-hour | Predictable, sustained workloads | Manual or Auto Scaling |
| **On-Demand** | Per request (Read Request Unit / Write Request Unit) | New, unpredictable, spiky workloads | Automatic, instant |

**Cost comparison**: On-Demand = ~2–2.5x more expensive per RCU/WCU than right-sized Provisioned + Auto Scaling.

**Auto Scaling (Provisioned)**: Set min/max RCU/WCU; DynamoDB adjusts within bounds using CloudWatch alarms. Scale-up is fast; scale-down slower (4 decreases/day limit historically, now managed automatically).

### 4. Read Consistency Models

| Type | Freshness | Cost | Use Case |
|------|----------|------|---------|
| **Eventually consistent** | May be slightly stale | 0.5 RCU per 4KB | Default; fine for most reads |
| **Strongly consistent** | Always latest data | 1 RCU per 4KB | Financial balances, inventory counts |
| **Transactional** | ACID across items | 2 RCU per 4KB | Multi-step operations needing atomicity |

**GSI reads are always eventually consistent** — never strongly consistent.

### 5. DynamoDB Streams

- Captures a time-ordered sequence of item-level changes (INSERT, MODIFY, REMOVE)
- Retention: 24 hours (non-configurable)
- StreamViewType options:
  - `KEYS_ONLY` — only PK/SK of changed item
  - `NEW_IMAGE` — full item after change
  - `OLD_IMAGE` — full item before change
  - `NEW_AND_OLD_IMAGES` — both before and after

**Lambda integration**:
- Lambda polls stream and invokes function in batches (up to 10,000 records)
- Exactly-once processing: bisect on error to identify bad record; send to DLQ
- Parallel streams: up to 2 Lambda functions per shard concurrently

### 6. DAX (DynamoDB Accelerator)

- **In-memory cache** for DynamoDB; write-through caching
- **Microsecond read latency** (vs single-digit millisecond from DynamoDB)
- Transparent API compatibility — same DynamoDB SDK calls, just point to DAX endpoint
- Cache types:
  - **Item cache** — caches individual item GetItem/TransactGetItems results
  - **Query cache** — caches Query/Scan results (based on query parameters as key)
- DAX does NOT help write-heavy workloads; helps read-heavy patterns with hot items
- Multi-AZ cluster: deploy at least 3 nodes across AZs for HA

### 7. DynamoDB Transactions

- `TransactWriteItems`: up to 100 items, across multiple tables, all-or-nothing ACID
- `TransactGetItems`: up to 100 items, atomic consistent read
- Use cases: inventory deduction + order creation; bank transfer (debit + credit)
- Cost: 2x the normal RCU/WCU (transactional reads/writes)
- Cannot mix transactional and non-transactional operations in same call

## Key Concepts

- **RCU (Read Capacity Unit)** — 1 strongly consistent read of 4KB/s; 2 eventually consistent reads of 4KB/s
- **WCU (Write Capacity Unit)** — 1 write of 1KB/s
- **Hot partition** — single partition receiving disproportionate traffic (bottleneck at 3000 RCU or 1000 WCU)
- **Adaptive capacity** — DynamoDB automatically boosts hot partition capacity (short-term relief; not a long-term fix)
- **Conditional writes** — `ConditionExpression` on PutItem/UpdateItem/DeleteItem; optimistic locking pattern
- **TTL (Time to Live)** — mark items for automatic deletion after timestamp; no WCU consumed; deletion within 48h
- **Global tables** — multi-region, multi-active replication; last-writer-wins conflict resolution
- **Export to S3** — point-in-time snapshot of table to S3 in DynamoDB JSON or ION format (no RCU consumed)

## Checklist

- [ ] Partition key has high cardinality (no hot partitions)?
- [ ] All required access patterns covered by table keys or indexes (GSI/LSI)?
- [ ] LSI created at table creation time (cannot add later)?
- [ ] GSI WCU provisioned separately from base table?
- [ ] Capacity mode chosen: On-Demand for new/spiky, Provisioned + Auto Scaling for steady?
- [ ] TTL enabled for ephemeral data (sessions, cache, events)?
- [ ] DynamoDB Streams + Lambda for event-driven reactions?
- [ ] DAX cluster deployed for read-heavy hot-item workloads?

## Output Format

- 🔴 **Critical** — hot partition key with low cardinality (status, boolean, region with few values); LSI added after table creation (impossible — must recreate table)
- 🟡 **Warning** — On-Demand mode used for sustained high-throughput (2x cost vs Provisioned + Auto Scaling); missing index for required access pattern (application doing full table scans)
- 🟢 **Suggestion** — TTL for session/cache data; DAX for read-heavy hot items; write sharding for uneven write distribution

## Exam Tips

- **Hot partition** = too many reads/writes to same partition key → use write sharding (add random suffix `#0` to `#N`)
- **GSI = eventually consistent reads only**; LSI supports strongly consistent reads (same partition key as table)
- **DynamoDB Streams retention = 24 hours** only; process promptly; use Lambda bisect-on-error + DLQ for failures
- **DAX = read-heavy workloads** with hot items; does NOT help write-heavy; microsecond latency vs DynamoDB's milliseconds
- **On-Demand = ~2x more expensive** at sustained load vs right-sized Provisioned + Auto Scaling; use for unpredictable/new workloads only
- **Conditional writes = optimistic locking** — prevent lost updates in concurrent write scenarios (e.g., check version attribute before updating)
- **LSI must be created at table creation time** — cannot be added later; plan access patterns before creating table
- **Global Tables** use last-writer-wins conflict resolution; applications must handle potential conflicts in multi-region active-active writes
