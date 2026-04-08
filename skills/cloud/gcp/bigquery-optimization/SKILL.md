---
name: bigquery-optimization
description: Use when designing BigQuery schemas, optimizing queries, managing partitioning/clustering, controlling costs, or studying for GCP Professional Data Engineer (GCP-PDE). Covers domains: Design data processing systems (~22%) and Store the data (~15-20%).
---

# BigQuery Optimization

## When to Use
- Designing tables for an analytics use case on GCP
- Queries are slow or unexpectedly expensive
- Planning partitioning/clustering strategy
- Preparing for GCP Professional Data Engineer exam

## Core Jobs

### 1. Schema Design
- Prefer **denormalized** schemas for analytics (avoid JOINs at scale)
- Use **ARRAY** and **STRUCT** for nested/repeated data instead of separate tables
- Choose correct column types: INT64 over STRING for IDs, TIMESTAMP over STRING for dates
- Avoid nullable columns on high-cardinality fields

### 2. Partitioning Strategy
- **Time-unit partitioned** (DAY, HOUR, MONTH, YEAR) — most common, use for time-series data
- **Integer range partitioned** — for numeric IDs with predictable ranges
- **Ingestion-time partitioned** — auto-partitions on load time (_PARTITIONTIME pseudo-column)
- Always add partition filter in queries (`WHERE date = '2024-01-01'`) to reduce bytes billed

### 3. Clustering
- Apply after partitioning; up to 4 clustering columns
- Order columns by highest cardinality first (most selective → least selective)
- Best for filter columns: user_id, country, event_type
- Clustering improves query performance but does NOT reduce bytes billed (unlike partitioning)

### 4. Query Optimization
- Avoid `SELECT *` — select only needed columns (columnar storage)
- Filter early with `WHERE` on partitioned/clustered columns
- Use `WITH` CTEs for readability; avoid deep nesting
- Avoid self-joins; use window functions instead
- Use `APPROX_COUNT_DISTINCT` for large cardinality estimates

### 5. Cost Management
- **On-demand pricing** — pay per bytes scanned (good for irregular workloads)
- **Capacity pricing (slots)** — flat-rate, good for predictable high-volume workloads
- Monitor with INFORMATION_SCHEMA.JOBS_BY_PROJECT
- Use BI Engine for in-memory acceleration of dashboard queries
- Materialized views for repeated aggregations (auto-refresh on DML)

### 6. Access Control
- Use **Authorized Views** for row/column-level security without data duplication
- Apply dataset-level IAM before table-level (principle of least privilege)
- Column-level security via **Policy Tags** (BigQuery column security + Data Catalog)

## Key Concepts
- **Slot** — unit of BigQuery compute (1 slot = 1 CPU thread for query processing)
- **Shuffle** — cross-node data transfer; minimize with partition pruning
- **Materialized View** — pre-computed results, auto-refreshed; use for repeated aggregations
- **INFORMATION_SCHEMA** — metadata views for monitoring jobs, tables, partitions

## Checklist
- [ ] Table partitioned on a date/timestamp column?
- [ ] Clustering applied (up to 4 cols, high cardinality first)?
- [ ] All queries use partition filter in WHERE clause?
- [ ] SELECT * avoided — only needed columns selected?
- [ ] Authorized views used for sensitive data instead of data copies?
- [ ] Materialized views created for repeated aggregations?
- [ ] Cost monitoring via INFORMATION_SCHEMA.JOBS?

## Output Format
- 🔴 **Critical** — full table scan with no partition filter (unbounded cost)
- 🟡 **Warning** — missing clustering, suboptimal JOIN order, no partition pruning
- 🟢 **Suggestion** — materialized view opportunity, slot reservation candidate

## Exam Tips
- **Partitioning reduces cost** (fewer bytes scanned); **clustering improves performance** (not cost)
- Authorized views → share data without duplicating; row-level security without VPC-SC
- `INFORMATION_SCHEMA.JOBS_BY_PROJECT` → monitor slot usage and bytes billed
- Flat-rate (capacity) pricing → predictable cost for high-volume; on-demand → pay-per-query
- BI Engine → in-memory cache for Looker/Data Studio; does NOT replace Bigtable for OLTP
- Cross-region BigQuery JOIN → significant data transfer cost; prefer co-located datasets
