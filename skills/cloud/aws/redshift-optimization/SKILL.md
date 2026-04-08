---
name: redshift-optimization
description: Use when designing Amazon Redshift schemas, optimizing query performance, choosing distribution and sort keys, planning RA3 clusters, or comparing Redshift vs Athena. Covers AWS DEA-C01 data warehousing domain.
---

# Amazon Redshift Optimization

## When to Use
- Designing data warehouse schemas for Amazon Redshift
- Optimizing slow or expensive Redshift queries
- Choosing distribution styles and sort keys for tables
- Planning RA3 vs DC2 node types and storage strategy
- Deciding between Redshift and Athena for a query workload
- Preparing for AWS Certified Data Engineer Associate (DEA-C01) exam

## Core Jobs

### 1. Distribution Style Selection

| Style | Behavior | Best For |
|-------|----------|---------|
| **EVEN** | Rows distributed round-robin across slices | Tables with no frequent joins; full table scans |
| **KEY** | Rows distributed by hash of a column value | Fact tables joined to large dimension tables (co-locate data) |
| **ALL** | Entire table copied to EVERY node | Small, frequently-joined dimension tables (< a few million rows) |
| **AUTO** | Redshift picks EVEN or ALL automatically | Default for new tables; let Redshift optimize |

**Decision process**:
1. Small dimension table (< 3M rows) → **ALL**
2. Large fact table or large dimension → **KEY** (use the join column as distribution key)
3. No joins, full scans → **EVEN**
4. New table without clear pattern → **AUTO**

Co-locating data (KEY distribution on join column) avoids expensive network data redistribution during joins.

### 2. Sort Key Types

| Sort Key Type | Behavior | Best For |
|---------------|----------|---------|
| **COMPOUND** | Columns sorted in order of definition; prefix queries optimized | Queries always filter on leading column(s) |
| **INTERLEAVED** | Equal weight to all sort columns | Queries filter on ANY of the sort key columns |

**COMPOUND sort key rules**:
- Add columns in order of query filter frequency (most common first)
- Queries filtering only on non-leading columns see no sort benefit
- Interleaved sort keys degrade over time with VACUUM/ANALYZE requirements

**Example**: Table queried primarily by `sale_date`, secondarily by `region`:
```sql
SORTKEY (sale_date, region)  -- COMPOUND, filter on sale_date or (sale_date + region)
```

### 3. Redshift vs Athena Decision

| Factor | Amazon Redshift | Amazon Athena |
|--------|----------------|---------------|
| Data location | Loaded into Redshift Managed Storage | Stays in S3 (no loading) |
| Query type | Complex analytics, frequent JOINs, CTEs | Ad-hoc, exploratory queries |
| Performance | Faster for repeated complex queries (compiled, cached) | Slower for complex JOINs (scan S3) |
| Cost model | Cluster-hour (provisioned) or per-query (Serverless) | Per TB scanned |
| Best for | Regular BI workloads, dashboards, complex analytics | Occasional queries, data lake exploration |

**Rule**: Use Redshift for structured, frequent, complex analytics (dashboards, reports). Use Athena for ad-hoc queries on S3 without loading data.

### 4. RA3 Nodes — Managed Storage

- **RA3 = separate compute and storage** — Redshift Managed Storage backed by S3
- Pay for compute (nodes) and storage separately; scale each independently
- **Data sharing**: share live data across Redshift clusters without copying (cross-account, cross-AZ)
- **AQUA (Advanced Query Accelerator)**: hardware-accelerated cache close to storage (RA3 clusters)
- RA3 vs DC2: RA3 for data > 1TB or growing datasets; DC2 for < 500GB with predictable, fast local SSD needs

### 5. Redshift Spectrum

- Query S3 data directly from Redshift using Spectrum nodes — **no data loading needed**
- Uses Glue Data Catalog (or Redshift external schema) for table metadata
- Pushes predicates and aggregations down to Spectrum layer (S3 processing)
- Best practice: partition S3 data by frequently filtered columns (date, region) for Spectrum queries
- Cost: per TB scanned by Spectrum (like Athena)

### 6. VACUUM and ANALYZE

| Operation | Purpose | When to Run |
|-----------|---------|-------------|
| **VACUUM** | Reclaim disk space from deleted/updated rows; re-sort unsorted data | After large DELETE or UPDATE operations |
| `VACUUM SORT ONLY` | Re-sort data without reclaiming space | After heavy inserts that disrupted sort order |
| `VACUUM DELETE ONLY` | Reclaim space only, no re-sort | Fast cleanup without full sort pass |
| **ANALYZE** | Update statistics for query planner | After significant data changes |

- Automatic VACUUM runs in the background; can be disabled per table
- Automatic ANALYZE triggered by DML operations; prefer manual for large imports

### 7. Workload Management (WLM)

- **WLM queues** — allocate memory and concurrency slots by query type
- **Concurrency Scaling** — automatically adds cluster capacity for burst read queries (extra Redshift clusters)
- **Short Query Acceleration (SQA)** — automatically prioritizes short queries over long ones
- **Manual WLM**: define queues by user group or query group label
- **Auto WLM**: Redshift manages memory and concurrency dynamically (recommended)

## Key Concepts

- **Slice** — smallest unit of parallel processing; each node has multiple slices (2–16 per node type)
- **Leader node** — compiles queries, generates execution plans, coordinates worker nodes
- **Compute node** — stores data and executes query steps in parallel across slices
- **Zone map** — 1MB block-level min/max tracking; sort key enables zone map pruning to skip blocks
- **Columnar storage** — data stored by column, not row; compression and column projection reduce I/O
- **Compression encoding** — per-column compression (AZ64, LZO, ZSTD, Runlength, Delta); ANALYZE COMPRESSION auto-selects
- **COPY command** — bulk parallel load from S3 (preferred over INSERT); uses all slices simultaneously
- **UNLOAD command** — parallel export from Redshift to S3 (creates multiple files, one per slice)

## Checklist

- [ ] Distribution KEY on join column for large fact + large dimension table pairs?
- [ ] ALL distribution applied to small dimension tables (< 3M rows)?
- [ ] Compound sort key leading column matches most common WHERE filter?
- [ ] VACUUM and ANALYZE scheduled after large DELETE/UPDATE operations?
- [ ] WLM configured (Auto WLM or manual queues) for different workload types?
- [ ] Redshift Spectrum considered for historical/cold data on S3 (avoid loading)?
- [ ] COPY command used for bulk loads (not row-by-row INSERT)?
- [ ] Concurrency Scaling enabled for burst read query scenarios?

## Output Format

- 🔴 **Critical** — distribution mismatch causing cross-node data redistribution on every join (DS_DIST_BOTH in EXPLAIN plan)
- 🟡 **Warning** — missing sort key on date-range filtered table; VACUUM not run after bulk deletes; manual WLM with wrong memory allocation
- 🟢 **Suggestion** — ALL distribution opportunity for small dimension table; Concurrency Scaling for burst workload; Spectrum for infrequently queried historical data

## Exam Tips

- **Distribution KEY** = put large fact table and its large dimension table on same nodes (reduces network shuffle); join column must be the DISTKEY for both tables
- **ALL distribution** = only for small dimension tables (< few million rows); copying to every node is wasteful at large scale
- **COMPOUND sort key** = filter on leading columns; add columns in order of filter frequency — non-leading column filters get NO sort benefit
- **RA3** = pay for compute and storage separately; supports cross-cluster and cross-account data sharing without copying data
- **Redshift Spectrum** reads from S3 using Glue Data Catalog; no data loading needed; costs per TB scanned
- **WLM (Workload Management)** = queue-based resource allocation; use SQA (Short Query Acceleration) to prevent short queries from waiting behind long-running ones
- **COPY command** = bulk parallel load (preferred); uses all compute slices simultaneously from S3
- **VACUUM** reclaims space after deletes (Redshift uses MVCC — deleted rows are marked, not immediately removed)
