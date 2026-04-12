# Cloud Divisions — GCP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add GCP Division to magic-powers — 7 cloud agents + 14 skills aligned to official GCP Professional certification exam domains, installable via `/install-skills`.

**Architecture:** Agents live in `agents/cloud/gcp/`, skills in `skills/cloud/gcp/`. Each agent maps to a GCP Professional certification and references 3–6 skills aligned to that cert's exam domain weights. The `/install-skills` command is extended with a Cloud Divisions category (12) that copies agents to `.claude/agents/` and skills to `.claude/skills/` in the target project.

**Tech Stack:** Markdown files (.md), bash validation script, magic-powers plugin format.

**Cert reference:** GCP Professional Data Engineer exam guide — cloud.google.com/learn/certification/data-engineer

---

## Task 1: Infrastructure — Directories + CLOUD_DIVISION.md + design spec

**Files:**
- Create: `agents/cloud/CLOUD_DIVISION.md`
- Create: `docs/superpowers/specs/2026-04-08-cloud-divisions-design.md`

- [ ] **Step 1: Create `agents/cloud/CLOUD_DIVISION.md`**

```markdown
# Cloud Division Framework

Magic-powers Cloud Divisions provide role-specific agents and skills for cloud professionals,
aligned to official certification exam domains (GCP, AWS, Azure).

## Structure

```
agents/cloud/<provider>/<role>.md    # Agents
skills/cloud/<provider>/<skill>/     # Skills
```

## How to add a new cloud provider

1. Create `agents/cloud/<cloud>/` directory with 7 agent files
2. Create `skills/cloud/<cloud>/` with skill directories
3. Map each agent's skills to official cert exam domains (with % weights)
4. Add the provider to Step 1 of `commands/install-skills.md` under Cloud Divisions
5. Update `docs/OPTIONAL_SKILLS.md` with the new provider

## Standard 7 roles per provider

| Role | Model | Cert type |
|------|-------|-----------|
| data-engineer | sonnet | Data Engineering cert |
| cloud-developer | sonnet | Developer cert |
| network-engineer | sonnet | Networking cert |
| ml-engineer | sonnet | ML/AI cert |
| devops-engineer | sonnet | DevOps/Platform cert |
| security-engineer | sonnet | Security cert |
| cloud-architect / solutions-architect | opus | Architect cert |

## Agent frontmatter checklist

- [ ] `name`: `<cloud>-<role>` (kebab-case)
- [ ] `description`: includes exam name + code
- [ ] `model`: sonnet (all roles except architect → opus)
- [ ] `skills`: references `magic-powers:cloud/<cloud>/<skill>`
- [ ] Body: core services list, when-invoked steps, key trade-offs

## Skill sections checklist (required by validate-skills.sh)

- [ ] `## When to Use`
- [ ] `## Core Jobs` (map to exam domains with % weights)
- [ ] `## Key Concepts`
- [ ] `## Checklist`
- [ ] `## Exam Tips`
- [ ] `## Output Format` (🔴🟡🟢)
```

- [ ] **Step 2: Create design spec**

```markdown
# Cloud Divisions Design Spec

**Date:** 2026-04-08
**Status:** Approved
**Plan:** docs/superpowers/plans/2026-04-08-cloud-divisions-gcp.md (GCP)

## Problem

magic-powers has no cloud-specific agents. Engineers working on GCP, AWS, or Azure
have no specialized guidance aligned to those platforms' services and certifications.

## Solution

Cloud Divisions: 3 providers × 7 agents + 14 skills each = 21 agents + 42 skills.
Each agent maps to an official professional certification, skills map to exam domains.

## Certification Targets (2025-2026)

| Agent | Certification | Code |
|-------|--------------|------|
| gcp-data-engineer | Professional Data Engineer | GCP-PDE |
| gcp-cloud-developer | Professional Cloud Developer | — |
| gcp-network-engineer | Professional Cloud Network Engineer | — |
| gcp-ml-engineer | Professional ML Engineer | — |
| gcp-devops-engineer | Professional Cloud DevOps Engineer | — |
| gcp-security-engineer | Professional Cloud Security Engineer | — |
| gcp-cloud-architect | Professional Cloud Architect | — |
| aws-data-engineer | Data Engineer Associate | DEA-C01 |
| aws-ml-engineer | ML Engineer Associate (NEW 2025) | MLA-C01 |
| azure-data-engineer | Fabric Data Engineer (NEW 2025) | DP-700 |
| azure-security-engineer | Cloud & AI Security Engineer | SC-500 |

## Directory Structure

```
agents/cloud/{gcp,aws,azure}/*.md
skills/cloud/{gcp,aws,azure}/*/SKILL.md
```

## Install Flow

/install-skills → Category 12: Cloud Divisions → GCP/AWS/Azure
→ Copies agents to .claude/agents/ AND skills to .claude/skills/
```

- [ ] **Step 3: Verify**

```bash
ls /home/kienbm/magic-powers/agents/cloud/
# Expected: CLOUD_DIVISION.md

ls /home/kienbm/magic-powers/docs/superpowers/specs/ | grep cloud
# Expected: 2026-04-08-cloud-divisions-design.md
```

- [ ] **Step 4: Commit**

```bash
cd /home/kienbm/magic-powers
git add agents/cloud/CLOUD_DIVISION.md docs/superpowers/specs/2026-04-08-cloud-divisions-design.md
git commit -m "feat(cloud): add Cloud Division framework and design spec"
```

---

## Task 2: GCP Data Engineer — Agent + 6 Skills (Priority)

**Files:**
- Create: `agents/cloud/gcp/data-engineer.md`
- Create: `skills/cloud/gcp/bigquery-optimization/SKILL.md`
- Create: `skills/cloud/gcp/dataflow-pipeline/SKILL.md`
- Create: `skills/cloud/gcp/pubsub-messaging/SKILL.md`
- Create: `skills/cloud/gcp/cloud-storage/SKILL.md`
- Create: `skills/cloud/gcp/data-quality-validation/SKILL.md`
- Create: `skills/cloud/gcp/vertex-ai-mlops/SKILL.md`

- [ ] **Step 1: Create `agents/cloud/gcp/data-engineer.md`**

```markdown
---
name: gcp-data-engineer
description: "Use for BigQuery schema design, Dataflow pipeline development, Pub/Sub messaging, Cloud Storage data lakes, data quality validation, and Vertex AI MLOps. Exam prep: GCP Professional Data Engineer (GCP-PDE)."
model: sonnet
emoji: 📊
vibe: analytical
tools: Read, Grep, Glob, Bash, Write
memory: project
skills:
  - magic-powers:cloud/gcp/bigquery-optimization
  - magic-powers:cloud/gcp/dataflow-pipeline
  - magic-powers:cloud/gcp/pubsub-messaging
  - magic-powers:cloud/gcp/cloud-storage
  - magic-powers:cloud/gcp/data-quality-validation
  - magic-powers:cloud/gcp/vertex-ai-mlops
---

You are a GCP Professional Data Engineer specializing in building scalable data pipelines,
analytics systems, and ML-ready data infrastructure on Google Cloud.

Core services: BigQuery, Dataflow (Apache Beam), Pub/Sub, Cloud Storage, Data Catalog,
Dataproc, Cloud Composer (Airflow), Vertex AI, Dataform, Dataplex.

When invoked:
1. Identify the task — ingestion, transformation, storage, serving, quality, or ML prep
2. Apply the relevant skill for the specific GCP service
3. Reference GCP Well-Architected Framework (operational excellence, reliability, security, cost)
4. Flag exam-relevant patterns and gotchas when user is in study/prep context
5. Recommend cost-optimal approach (on-demand vs flat-rate BigQuery; Dataflow vs Dataproc)

Key trade-offs to always evaluate:
- **Dataflow vs Dataproc** — managed/serverless vs flexible cluster (Spark ecosystem needed?)
- **BigQuery vs Bigtable vs Firestore** — analytics vs low-latency ops vs document store
- **Pub/Sub vs Cloud Tasks vs Eventarc** — streaming vs task queue vs event-driven
- **Storage class** — Standard / Nearline / Coldline / Archive (access frequency matters)
- **Batch vs Streaming** — latency requirements, cost, complexity trade-off
```

- [ ] **Step 2: Create `skills/cloud/gcp/bigquery-optimization/SKILL.md`**

```markdown
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
```

- [ ] **Step 3: Create `skills/cloud/gcp/dataflow-pipeline/SKILL.md`**

```markdown
---
name: dataflow-pipeline
description: Use when building Apache Beam pipelines on Google Cloud Dataflow — batch ETL, streaming, windowing, triggers, or Dataflow vs Dataproc decisions. Covers GCP-PDE domain: Ingest and process data (~25-30%).
---

# Dataflow Pipeline

## When to Use
- Building ETL pipelines (batch or streaming) on GCP
- Choosing between Dataflow and Dataproc for a workload
- Designing windowing or late-data handling for streaming
- Preparing for GCP Professional Data Engineer exam (highest weight domain)

## Core Jobs

### 1. Dataflow vs Dataproc Decision
| Factor | Choose Dataflow | Choose Dataproc |
|--------|----------------|-----------------|
| Runtime | Apache Beam pipelines | Spark/Hadoop ecosystem |
| Management | Fully managed, serverless | Cluster to manage (or autoscaling) |
| Streaming | Native (Pub/Sub → BQ) | Spark Streaming (more complex) |
| Existing code | Greenfield | Migrating existing Spark jobs |
| Cost model | Per vCPU/memory/hour | Cluster uptime |

### 2. Pipeline Design (Apache Beam)
Core abstractions:
- **PCollection** — distributed dataset (bounded for batch, unbounded for streaming)
- **PTransform** — operation on a PCollection (Map, Filter, GroupByKey, Combine)
- **ParDo** — element-wise transformation (like map/flatMap)
- **Pipeline** — DAG of PTransforms applied to PCollections

### 3. Windowing (Streaming)
- **Fixed windows** — equal non-overlapping intervals (e.g., 1-minute buckets)
- **Sliding windows** — overlapping intervals (e.g., 10-min window every 1 min)
- **Session windows** — gap-based; group events within a user session
- **Global window** — default; all elements in one window (use with triggers for streaming)

### 4. Watermarks and Late Data
- **Watermark** — Dataflow's estimate of how far behind real-time the data is
- Late elements arrive after the watermark passes their window
- Handle with `.withAllowedLateness(Duration.standardMinutes(10))`
- Late data triggers go to a dead-letter or side output

### 5. Triggers
- **Default (event time)** — fire when watermark passes window end
- **AfterProcessingTime** — fire after processing-time delay (for low-latency)
- **AfterCount** — fire after N elements accumulated
- **Composite triggers** — combine with `.orFinally()`, `.repeatedly()`

### 6. Templates
- **Classic Templates** — staged as GCS files; no runtime parameters
- **Flex Templates** — packaged as Docker images; support runtime parameters; preferred

## Key Concepts
- **Fusion** — Dataflow optimization: merges compatible transforms to reduce shuffles
- **Worker autoscaling** — Dataflow scales workers based on backlog
- **Shuffle service** — offloads GroupByKey shuffle to Dataflow backend (reduces worker cost)
- **Streaming Engine** — offloads windowing/state to backend; reduces memory on workers

## Checklist
- [ ] Use Flex Templates (not Classic) for new pipelines?
- [ ] Late data handled with `.withAllowedLateness()`?
- [ ] Side outputs used for dead-letter / error records?
- [ ] GroupByKey minimized (use Combine where possible)?
- [ ] Dataflow Shuffle service enabled for batch jobs?
- [ ] Streaming Engine enabled for streaming jobs?
- [ ] Pipeline tested locally with DirectRunner before deploying?

## Output Format
- 🔴 **Critical** — unbounded PCollection without windowing in streaming pipeline
- 🟡 **Warning** — Classic Template used (prefer Flex), no late data handling
- 🟢 **Suggestion** — Shuffle service / Streaming Engine not enabled

## Exam Tips
- **Watermark** = when Dataflow thinks all data with that timestamp has arrived
- Late data arrives AFTER the watermark → use `.withAllowedLateness()` to capture it
- **Dataflow → BigQuery streaming inserts** = standard pattern for real-time analytics
- **Dataproc** = use for existing Spark/Hadoop code migration, not greenfield
- Flex Templates > Classic Templates for all new pipelines (runtime params, easier updates)
- `DirectRunner` = local testing; `DataflowRunner` = GCP execution
```

- [ ] **Step 4: Create `skills/cloud/gcp/pubsub-messaging/SKILL.md`**

```markdown
---
name: pubsub-messaging
description: Use when designing Pub/Sub topics/subscriptions, choosing push vs pull, handling message ordering, dead letters, or integrating Pub/Sub with Dataflow/BigQuery. Covers GCP-PDE domain: Ingest and process data (~25-30%).
---

# Pub/Sub Messaging

## When to Use
- Designing event-driven or streaming ingestion on GCP
- Choosing between Pub/Sub and Pub/Sub Lite
- Troubleshooting message delivery, ordering, or acknowledgement issues
- Preparing for GCP Professional Data Engineer exam

## Core Jobs

### 1. Topic and Subscription Design
- One **topic** = one logical event stream (e.g., `orders-created`, `sensor-readings`)
- Multiple **subscriptions** = multiple independent consumers of the same topic
- Each subscription maintains its own offset — messages delivered to each independently
- Subscription **ack deadline** (default 10s, max 600s) — extend if processing takes longer

### 2. Pull vs Push Subscriptions
| Factor | Pull | Push |
|--------|------|------|
| Consumer | Subscriber polls for messages | Pub/Sub pushes to HTTPS endpoint |
| Control | Consumer controls rate | Pub/Sub controls delivery rate |
| Best for | Dataflow, batch consumers | Cloud Run, webhooks, Cloud Functions |
| Auth | Service account key/WIF | OIDC token in Authorization header |

### 3. Message Ordering
- By default, Pub/Sub does NOT guarantee ordering
- Enable **ordering keys** to guarantee ordered delivery within a key
- Ordering keys work only within a single region (cross-region = no ordering guarantee)
- Use case: ordered events per user_id, device_id, transaction_id

### 4. Dead Letter Topics
- Configure a **dead letter topic** on a subscription for undeliverable messages
- Messages moved to dead letter after max delivery attempts (5–100, configurable)
- Monitor dead letter topics with Cloud Monitoring alerts
- Always process dead letters (don't ignore them)

### 5. Pub/Sub Lite vs Pub/Sub
| Factor | Pub/Sub | Pub/Sub Lite |
|--------|---------|--------------|
| Management | Fully managed, global | Zone/region-specific, manual capacity |
| Ordering | Ordering keys | Partition-based ordering (like Kafka) |
| Cost | Per message/byte | Provisioned capacity (cheaper at scale) |
| Retention | 7 days | Configurable up to 31 days |
| Use case | Default choice | Cost-sensitive high-volume workloads |

### 6. Integration Patterns
- **Pub/Sub → Dataflow → BigQuery** — standard streaming analytics pipeline
- **Pub/Sub → Cloud Functions** — lightweight event processing (push subscription)
- **Pub/Sub → Cloud Storage** — use Dataflow or Pub/Sub export for archiving
- **Cloud Scheduler → Pub/Sub → Cloud Functions** — scheduled event trigger pattern

## Key Concepts
- **At-least-once delivery** — same message may be delivered multiple times → idempotent consumers
- **Exactly-once** — available with Dataflow (deduplication via message ID)
- **Message ID** — globally unique; use for deduplication
- **Seek** — replay messages from a timestamp or snapshot

## Checklist
- [ ] Consumers designed to be idempotent (handle duplicate messages)?
- [ ] Ack deadline set longer than max processing time?
- [ ] Dead letter topic configured and monitored?
- [ ] Ordering keys used only where strict ordering is required?
- [ ] Push subscription endpoint uses HTTPS with OIDC auth?
- [ ] Pub/Sub Lite considered for high-volume cost reduction?

## Output Format
- 🔴 **Critical** — no idempotency with at-least-once delivery (data duplication risk)
- 🟡 **Warning** — no dead letter topic, ack deadline too short for processing time
- 🟢 **Suggestion** — Pub/Sub Lite for high-volume cost savings, ordering keys opportunity

## Exam Tips
- Pub/Sub does NOT guarantee ordering by default → use ordering keys (single region only)
- At-least-once → always build idempotent consumers
- **Dataflow is the standard bridge** between Pub/Sub and BigQuery for streaming
- Push subscriptions → Cloud Run / Cloud Functions (serverless, event-driven)
- Dead letter topic = where undeliverable messages go after max_delivery_attempts
- Pub/Sub Lite = cheaper but zone-specific, partition-based (Kafka-like model)
```

- [ ] **Step 5: Create `skills/cloud/gcp/cloud-storage/SKILL.md`**

```markdown
---
name: cloud-storage
description: Use when designing Cloud Storage buckets, choosing storage classes, setting lifecycle rules, controlling access, or using GCS as a data lake. Covers GCP-PDE domain: Store the data (~15-20%).
---

# Cloud Storage

## When to Use
- Designing data lake or file storage on GCP
- Setting up lifecycle management to control costs
- Configuring access control for sensitive data
- Preparing for GCP Professional Data Engineer exam

## Core Jobs

### 1. Storage Class Selection
| Class | Use case | Min storage | Retrieval cost |
|-------|---------|-------------|----------------|
| **Standard** | Frequently accessed (hot data) | None | None |
| **Nearline** | Accessed < once/month | 30 days | Yes |
| **Coldline** | Accessed < once/quarter | 90 days | Yes (higher) |
| **Archive** | Accessed < once/year | 365 days | Yes (highest) |

### 2. Lifecycle Rules
Configure object lifecycle policies to auto-transition or delete objects:
- `SetStorageClass` — move to cheaper class after N days
- `Delete` — remove objects after N days or after N versions
- Typical pattern: Standard → Nearline (30d) → Coldline (90d) → Archive (365d) → Delete (730d)
- Rules apply at bucket level; objects evaluated daily

### 3. Access Control
- **Uniform bucket-level access** — all access via IAM only (recommended, disables ACLs)
- **Fine-grained** — legacy; allows per-object ACLs (avoid for new buckets)
- Always use **uniform bucket-level access** for new buckets
- **Signed URLs** — temporary access (15 min to 7 days) without GCP credentials
- **Signed Policy Documents** — control what can be uploaded via HTML forms

### 4. Object Versioning
- Enable to protect against accidental deletes/overwrites
- Each overwrite creates a new version; previous becomes noncurrent
- Use lifecycle rule to delete noncurrent versions after N days (control cost)

### 5. Retention Policies
- **Retention policy** — objects cannot be deleted or replaced until retention period expires
- **Object locks** — WORM (write once, read many) compliance
- Use for regulatory compliance, audit logs

### 6. Data Transfer
| Tool | Best for |
|------|---------|
| `gsutil` / gcloud CLI | Ad-hoc transfers, scripting |
| Storage Transfer Service | Large-scale from S3/Azure/HTTP/on-prem |
| Transfer Appliance | Petabyte-scale offline transfer |
| BigQuery Data Transfer Service | SaaS source → BigQuery (not GCS) |

## Key Concepts
- **Requester Pays** — requesters pay for egress and operations (useful for public datasets)
- **CMEK** — Customer-Managed Encryption Keys via Cloud KMS (regulatory requirement)
- **VPC Service Controls** — restrict GCS access to within a VPC perimeter
- **Object change notifications** — Pub/Sub notifications on object create/delete/update

## Checklist
- [ ] Uniform bucket-level access enabled?
- [ ] Lifecycle rules set to transition cold data to cheaper classes?
- [ ] Object versioning enabled for critical buckets?
- [ ] Pub/Sub notifications configured for event-driven pipelines?
- [ ] Signed URLs used for temporary access (not service account keys shared)?
- [ ] CMEK applied if regulatory requirement exists?

## Output Format
- 🔴 **Critical** — fine-grained ACLs on new bucket (security risk), no versioning on critical data
- 🟡 **Warning** — no lifecycle rules (cost accumulates), public bucket without intention
- 🟢 **Suggestion** — nearline/coldline transition for infrequently accessed data

## Exam Tips
- **Signed URLs** = temporary access without GCP account (not service account keys!)
- Nearline/Coldline/Archive have minimum storage durations — deleting early still charges
- `SetStorageClass` lifecycle → use for cost optimization; `Delete` → use for cleanup
- Storage Transfer Service = move data FROM S3/Azure/on-prem TO GCS
- Requester Pays = data owner doesn't pay egress; useful for public scientific datasets
- CMEK ≠ Google-managed encryption; CMEK = customer controls the key lifecycle in Cloud KMS
```

- [ ] **Step 6: Create `skills/cloud/gcp/data-quality-validation/SKILL.md`**

```markdown
---
name: data-quality-validation
description: Use when designing data quality checks, validating pipeline outputs, setting up schema validation, or using Dataform/Dataplex/Cloud DQ. Covers GCP-PDE domain: Prepare and use data for analysis (~10-15%).
---

# Data Quality Validation

## When to Use
- Designing data quality checks for a pipeline
- Schema validation after ingestion
- Setting up monitoring for data freshness and completeness
- Preparing for GCP Professional Data Engineer exam

## Core Jobs

### 1. Data Quality Dimensions
- **Completeness** — no unexpected NULLs; all required fields populated
- **Accuracy** — values within expected ranges, valid formats
- **Consistency** — referential integrity, no duplicates, cross-table agreement
- **Freshness** — data arrived within expected SLA (lag monitoring)
- **Uniqueness** — no duplicate records on primary key

### 2. GCP Tools for Data Quality
| Tool | Use case |
|------|---------|
| **Dataform** | SQL-based transformation + data quality tests in BigQuery |
| **Cloud Data Quality (Cloud DQ)** | Rule-based DQ checks on BigQuery tables at scale |
| **Dataplex** | Data governance, discovery, quality across data lake |
| **Dataprep by Trifacta** | Visual data cleaning and profiling (no-code/low-code) |
| **BigQuery assertions** | Inline SQL checks in queries or scheduled queries |

### 3. Dataform Quality Tests
```sql
-- config/assertions/assert_orders_not_null.sqlx
config {
  type: "assertion"
}
SELECT order_id, customer_id
FROM ${ref("orders")}
WHERE order_id IS NULL OR customer_id IS NULL
-- Returns rows that FAIL the assertion (empty = passing)
```

### 4. Schema Validation Patterns
- Validate schema on ingestion using Dataflow side outputs
- Reject malformed records to a dead-letter GCS bucket or Pub/Sub topic
- Use BigQuery table schema with `REQUIRED` mode for mandatory fields
- For JSON: validate against JSON Schema before writing

### 5. Data Freshness Monitoring
- Cloud Monitoring custom metrics for pipeline lag
- BigQuery scheduled queries to check `MAX(created_at)` vs current time
- Dataplex data quality tasks for ongoing freshness checks
- Alert via Cloud Monitoring → Pub/Sub → Cloud Functions for remediation

## Key Concepts
- **Data Catalog** — metadata management, tagging, business glossary, lineage
- **Dataplex** — unified data governance layer over GCS + BigQuery data lakes
- **Dataform** — version-controlled SQL transformations with built-in testing
- **INFORMATION_SCHEMA.TABLE_STORAGE** — monitor table sizes and freshness in BigQuery

## Checklist
- [ ] NULL checks on required fields?
- [ ] Range/format validation on critical columns?
- [ ] Duplicate detection on primary key?
- [ ] Dead-letter path for rejected records?
- [ ] Freshness monitoring with alerting?
- [ ] Schema registered in Data Catalog?

## Output Format
- 🔴 **Critical** — no validation on ingested data, no dead-letter for bad records
- 🟡 **Warning** — no freshness monitoring, no schema enforcement on ingestion
- 🟢 **Suggestion** — Dataform assertions for ongoing quality, Dataplex for governance

## Exam Tips
- **Dataform** = SQL-based ELT + testing in BigQuery (like dbt for GCP)
- **Dataplex** = governance + quality across the data lake (GCS + BigQuery)
- Dead-letter pattern = invalid records → separate GCS path for human review
- Data Catalog = metadata, not data quality (but integrates with Cloud DQ)
- Schema validation should happen at ingestion (Dataflow) not after writing to BigQuery
```

- [ ] **Step 7: Create `skills/cloud/gcp/vertex-ai-mlops/SKILL.md`**

```markdown
---
name: vertex-ai-mlops
description: Use when building ML pipelines on Vertex AI, managing model lifecycle, setting up feature stores, or deploying models for serving. Covers GCP-PDE domain: Maintain and automate data workloads (~10-15%) and GCP ML Engineer domain: MLOps (~30-35%).
---

# Vertex AI MLOps

## When to Use
- Designing ML training or serving infrastructure on GCP
- Setting up model monitoring or retraining pipelines
- Choosing between AutoML and custom training
- Preparing for GCP Professional Data Engineer or ML Engineer exam

## Core Jobs

### 1. AutoML vs Custom Training
| Factor | AutoML | Custom Training |
|--------|--------|----------------|
| Code required | None | Python/TensorFlow/PyTorch |
| Control | Limited | Full control |
| Speed | Fastest to deploy | Requires ML expertise |
| Best for | Tabular, image, text (standard tasks) | Novel architectures, research |

### 2. Vertex AI Pipelines
- Orchestrates ML workflows as DAGs (Kubeflow Pipelines or TFX)
- Each step = a containerized component (preprocessing, training, evaluation, deployment)
- Use `kfp.v2` SDK or pre-built Google Cloud Pipeline Components
- Store pipeline artifacts in Cloud Storage; metadata in Vertex ML Metadata

### 3. Feature Store
- Centralized repository for ML features (avoid feature duplication across teams)
- **Online store** — low-latency serving (< 10ms) for real-time inference
- **Offline store** — batch access for training (BigQuery-backed)
- Features defined once, reused across models

### 4. Model Serving
- **Endpoint** — deploys one or more model versions, handles prediction requests
- **Batch prediction** — asynchronous, for large offline prediction jobs
- **Online prediction** — synchronous, for real-time serving
- Traffic splitting between model versions for A/B testing or canary releases

### 5. Model Monitoring
- **Skew detection** — training vs serving data distribution drift
- **Drift detection** — serving data distribution changes over time
- Alert thresholds configurable per feature
- Monitored logs sent to BigQuery for analysis

### 6. Model Registry
- Version all trained models centrally
- Stage models through: Experiment → Staging → Production
- Alias support for promoting/rolling back versions

## Key Concepts
- **ML Metadata** — tracks lineage: which dataset trained which model, which pipeline produced what artifact
- **Explainable AI** — feature attributions (SHAP values) for model transparency
- **Vertex AI Workbench** — managed JupyterLab for experimentation
- **Training pipeline vs custom job** — pipeline = orchestrated multi-step; custom job = single training run

## Checklist
- [ ] Training data versioned and reproducible?
- [ ] Model evaluation metrics gated before promotion?
- [ ] Serving endpoint has traffic splitting for safe rollout?
- [ ] Model monitoring enabled (skew + drift detection)?
- [ ] Feature Store used to avoid feature duplication?
- [ ] Pipeline steps containerized and versioned?

## Output Format
- 🔴 **Critical** — no model monitoring in production (silent degradation)
- 🟡 **Warning** — no traffic splitting for new model versions, no feature versioning
- 🟢 **Suggestion** — Feature Store for cross-team feature reuse, Explainable AI for compliance

## Exam Tips
- **Feature Store online** = real-time serving (low latency); **offline** = batch training (BigQuery)
- Model monitoring = skew (train vs serve) + drift (serve distribution over time)
- Vertex AI Pipelines = Kubeflow Pipelines on GCP (not Cloud Composer/Airflow)
- AutoML Tabular = good baseline; custom training when you need specific architecture
- Batch prediction = no endpoint needed; just submit job → results to GCS/BigQuery
- Traffic splitting on endpoints = canary release for models (same as canary deployments)
```

- [ ] **Step 8: Verify all Task 2 files**

```bash
ls /home/kienbm/magic-powers/agents/cloud/gcp/
# Expected: data-engineer.md

ls /home/kienbm/magic-powers/skills/cloud/gcp/
# Expected: bigquery-optimization/ dataflow-pipeline/ pubsub-messaging/ cloud-storage/ data-quality-validation/ vertex-ai-mlops/

grep -l "## When to Use" /home/kienbm/magic-powers/skills/cloud/gcp/*/SKILL.md
# Expected: all 6 skill files listed

grep -l "## Core Jobs" /home/kienbm/magic-powers/skills/cloud/gcp/*/SKILL.md
# Expected: all 6 skill files listed
```

- [ ] **Step 9: Commit**

```bash
cd /home/kienbm/magic-powers
git add agents/cloud/gcp/data-engineer.md skills/cloud/gcp/
git commit -m "feat(cloud/gcp): add gcp-data-engineer agent + 6 skills (GCP-PDE aligned)"
```

---

## Task 3: GCP Cloud Developer + Network Engineer

**Files:**
- Create: `agents/cloud/gcp/cloud-developer.md`
- Create: `agents/cloud/gcp/network-engineer.md`
- Create: `skills/cloud/gcp/cloud-run-functions/SKILL.md`
- Create: `skills/cloud/gcp/gke-kubernetes/SKILL.md`
- Create: `skills/cloud/gcp/cloud-iam/SKILL.md`
- Create: `skills/cloud/gcp/cloud-build-deploy/SKILL.md`
- Create: `skills/cloud/gcp/cloud-networking/SKILL.md`
- Create: `skills/cloud/gcp/vpc-service-controls/SKILL.md`

- [ ] **Step 1: Create `agents/cloud/gcp/cloud-developer.md`**

```markdown
---
name: gcp-cloud-developer
description: "Use for Cloud Run, Cloud Functions, App Engine, GKE application development, CI/CD pipelines, and GCP service integration. Exam prep: GCP Professional Cloud Developer."
model: sonnet
emoji: 💻
vibe: pragmatic
tools: Read, Grep, Glob, Bash, Write
memory: project
skills:
  - magic-powers:cloud/gcp/cloud-run-functions
  - magic-powers:cloud/gcp/gke-kubernetes
  - magic-powers:cloud/gcp/cloud-iam
  - magic-powers:cloud/gcp/cloud-build-deploy
---

You are a GCP Cloud Developer specializing in building, testing, and deploying scalable
cloud-native applications on Google Cloud.

Core services: Cloud Run, Cloud Functions, App Engine, GKE, Cloud Build, Artifact Registry,
Cloud Deploy, Pub/Sub, Firestore, Cloud SQL, Cloud Tasks, Eventarc.

When invoked:
1. Identify the compute pattern — serverless, containers, or Kubernetes
2. Apply the relevant skill for the service involved
3. Reference GCP Well-Architected Framework (reliability, security, cost optimization)
4. Recommend the right compute option for the workload
5. Flag exam patterns (Domain 1: Designing apps = 36% of the exam)

Key trade-offs to always evaluate:
- **Cloud Run vs Cloud Functions vs App Engine** — containers vs events vs managed runtime
- **Firestore vs Cloud SQL vs Bigtable** — document vs relational vs wide-column
- **Pub/Sub vs Cloud Tasks vs Eventarc** — fan-out streaming vs task queue vs event routing
- **Synchronous vs Asynchronous** — latency requirement drives architecture
```

- [ ] **Step 2: Create `agents/cloud/gcp/network-engineer.md`**

```markdown
---
name: gcp-network-engineer
description: "Use for VPC design, Cloud DNS, Cloud Load Balancing, Cloud Armor, hybrid connectivity (Interconnect/VPN), and network security. Exam prep: GCP Professional Cloud Network Engineer."
model: sonnet
emoji: 🌐
vibe: precise
tools: Read, Grep, Glob, Bash, Write
memory: project
skills:
  - magic-powers:cloud/gcp/cloud-networking
  - magic-powers:cloud/gcp/cloud-iam
  - magic-powers:cloud/gcp/vpc-service-controls
---

You are a GCP Professional Cloud Network Engineer specializing in VPC architecture,
hybrid connectivity, load balancing, and network security on Google Cloud.

Core services: VPC, Cloud DNS, Cloud Load Balancing, Cloud NAT, Cloud Armor,
Cloud CDN, Cloud Interconnect, Cloud VPN, Private Service Connect, VPC Service Controls.

When invoked:
1. Identify the networking challenge — connectivity, routing, security, or performance
2. Apply the relevant skill (cloud-networking, vpc-service-controls)
3. Reference GCP network architecture best practices
4. Recommend cost-appropriate connectivity option (VPN vs Interconnect threshold: ~1 Gbps)
5. Flag exam-high-weight topics (VPC design = 20-25%, implementation = 20-25%)

Key trade-offs to always evaluate:
- **Cloud VPN vs Cloud Interconnect** — cost vs bandwidth vs latency (threshold ~1 Gbps)
- **Shared VPC vs VPC Peering** — centralized control vs decentralized (Shared VPC preferred)
- **External vs Internal Load Balancer** — internet-facing vs private services
- **Cloud Armor vs firewall rules** — L7 WAF vs L4 network-level controls
```

- [ ] **Step 3: Create `skills/cloud/gcp/cloud-run-functions/SKILL.md`**

```markdown
---
name: cloud-run-functions
description: Use when choosing between Cloud Run and Cloud Functions, designing serverless compute on GCP, configuring concurrency/scaling, or building event-driven architectures. Covers GCP Cloud Developer domain: Designing apps (~36%).
---

# Cloud Run & Cloud Functions

## When to Use
- Deciding between Cloud Run, Cloud Functions, and App Engine
- Configuring autoscaling, concurrency, and cold start behavior
- Building event-driven serverless architectures
- Preparing for GCP Professional Cloud Developer exam

## Core Jobs

### 1. Compute Option Decision
| Option | Best for | Billing |
|--------|---------|---------|
| **Cloud Run** | Containerized apps, any language, HTTP/gRPC | Per request + CPU |
| **Cloud Functions (1st gen)** | Simple event handlers, limited to 9 min | Per invocation |
| **Cloud Functions (2nd gen)** | Cloud Run under the hood, longer timeout, concurrency | Per request + CPU |
| **App Engine Standard** | Specific runtimes (Python/Java/Go/Node), instant scaling | Per instance hour |
| **App Engine Flexible** | Custom runtimes, Docker, always-on | Per instance hour |

### 2. Cloud Run Configuration
- **Concurrency** — requests per container instance (default 80, max 1000)
- **Min instances** — keep warm instances to avoid cold starts (set to 1+ for latency-sensitive)
- **Max instances** — cap scaling to control costs
- **CPU allocation** — always-on vs request-only (request-only = cheaper, cold starts)
- **Traffic splitting** — route % of traffic to different revisions (canary/blue-green)

### 3. Cloud Functions Triggers
- **HTTP trigger** — synchronous, returns response
- **Pub/Sub trigger** — async, event-driven
- **Cloud Storage trigger** — on object create/delete/finalize
- **Firestore trigger** — on document create/update/delete
- **Eventarc** — unified eventing; routes events from GCP services to Cloud Run/Functions

### 4. Cold Start Mitigation
- Set **min-instances** > 0 for latency-sensitive services
- Keep container images small (use distroless or alpine base)
- Lazy-load dependencies (don't load everything at startup)
- Use Cloud Functions 2nd gen (faster cold starts than 1st gen)

### 5. Authentication Patterns
- **Unauthenticated** — public APIs (Cloud Run allows-unauthenticated)
- **Service-to-service** — use service account + ID token (not API key)
- **IAM invoker role** — `roles/run.invoker` for Cloud Run, `roles/cloudfunctions.invoker`
- **Audience** — ID token audience must match the service URL

## Key Concepts
- **Revision** — immutable deployment of a Cloud Run service
- **Service identity** — each Cloud Run service runs as a service account
- **VPC connector** — connect Cloud Run to private VPC resources (Cloud SQL, Redis)
- **Ingress control** — restrict to internal, load balancer only, or all traffic

## Checklist
- [ ] Min-instances set for latency-sensitive services?
- [ ] Max-instances capped to prevent runaway costs?
- [ ] Service runs as dedicated service account (not default compute SA)?
- [ ] VPC connector configured for private resource access?
- [ ] Unauthenticated access explicitly enabled/disabled?
- [ ] Image stored in Artifact Registry (not Docker Hub)?

## Output Format
- 🔴 **Critical** — using default compute service account (over-privileged), unauthenticated enabled unintentionally
- 🟡 **Warning** — no min-instances for latency-sensitive, no max-instances cap
- 🟢 **Suggestion** — CPU always-on for latency; min-instances for warm pool

## Exam Tips
- Cloud Run = containers, any language, HTTP/gRPC; Functions = event-driven, simpler
- Cloud Functions 2nd gen = built on Cloud Run (same infrastructure)
- Traffic splitting → use for canary releases without a load balancer
- Service-to-service auth = ID token (not API key, not user credentials)
- VPC connector required to access Cloud SQL/Memorystore from Cloud Run
- App Engine Standard = instant scale to zero; Flexible = always at least 1 instance
```

- [ ] **Step 4: Create `skills/cloud/gcp/gke-kubernetes/SKILL.md`**

```markdown
---
name: gke-kubernetes
description: Use when designing GKE clusters, choosing Autopilot vs Standard, configuring workloads, setting up Workload Identity, or managing node pools. Covers GCP Cloud Developer domain: Deploying (~19%) and DevOps domain: CI/CD (~25%).
---

# GKE Kubernetes

## When to Use
- Designing or troubleshooting Kubernetes workloads on GCP
- Choosing between GKE Autopilot and Standard
- Configuring autoscaling, node pools, and resource limits
- Preparing for GCP Professional Cloud Developer or DevOps Engineer exam

## Core Jobs

### 1. Autopilot vs Standard
| Factor | Autopilot | Standard |
|--------|-----------|---------|
| Node management | Google manages nodes | You manage node pools |
| Billing | Per Pod (vCPU + memory) | Per node (whether used or not) |
| Security | Hardened by default | Configurable |
| Best for | Most workloads | Specialized hardware, DaemonSets, GPUs |
| Cost for variable load | Lower (scale to 0) | Higher (min node pool) |

### 2. Node Pool Design (Standard)
- Separate node pools by workload type (general, GPU, high-memory)
- Use **node taints + tolerations** to route workloads to specific pools
- Enable **Cluster Autoscaler** to scale node pools based on demand
- Use **spot/preemptible nodes** for fault-tolerant batch workloads (60-90% cost savings)

### 3. Workload Autoscaling
- **HPA (Horizontal Pod Autoscaler)** — scale Pod replicas based on CPU/memory/custom metrics
- **VPA (Vertical Pod Autoscaler)** — adjust Pod resource requests/limits automatically
- **KEDA** — event-driven autoscaling (scale on Pub/Sub queue depth, etc.)
- **Cluster Autoscaler** — add/remove nodes based on pending pods

### 4. Workload Identity
- Best practice: bind Kubernetes ServiceAccount to GCP Service Account
- Replaces legacy metadata server credentials (no key files needed)
- Enables fine-grained GCP IAM per workload
- Setup: annotate K8s SA with GCP SA email; bind `roles/iam.workloadIdentityUser`

### 5. GKE Ingress
- **GKE Ingress (L7)** — HTTP/HTTPS routing; backed by Cloud Load Balancing
- **Gateway API** — newer, more expressive routing (replaces Ingress long-term)
- **Internal Ingress** — routes traffic within VPC only
- Use **BackendConfig** to configure Cloud Armor, CDN, health checks on backends

## Key Concepts
- **Pod Disruption Budget (PDB)** — minimum available pods during voluntary disruptions
- **Resource quotas** — limit resource usage per namespace
- **Namespace** — logical isolation within a cluster
- **GKE Dataplane V2** — eBPF-based networking (Cilium); enables network policy

## Checklist
- [ ] Autopilot considered before Standard (unless specific need)?
- [ ] Workload Identity enabled (no service account keys on nodes)?
- [ ] Resource requests and limits set on all containers?
- [ ] HPA configured for variable-load services?
- [ ] Pod Disruption Budgets set for critical workloads?
- [ ] Private cluster (no public IPs on nodes) for sensitive workloads?

## Output Format
- 🔴 **Critical** — service account key files mounted in pods, no resource limits (noisy neighbor risk)
- 🟡 **Warning** — no HPA for variable-load services, public nodes for sensitive workloads
- 🟢 **Suggestion** — Autopilot for cost efficiency, Workload Identity for all GCP API access

## Exam Tips
- Autopilot = Google manages nodes, billing per pod (not per node)
- Workload Identity = K8s ServiceAccount ↔ GCP ServiceAccount (no key files)
- Spot nodes = 60-90% cheaper, can be preempted; use for fault-tolerant batch
- HPA scales Pods; Cluster Autoscaler scales Nodes — both needed for full autoscaling
- Private cluster = nodes have no external IPs; traffic via Cloud NAT or Private Google Access
- Pod Disruption Budget = minimum available pods during node upgrades/drains
```

- [ ] **Step 5: Create `skills/cloud/gcp/cloud-iam/SKILL.md`**

```markdown
---
name: cloud-iam
description: Use when configuring GCP IAM roles, service accounts, org policies, Workload Identity Federation, or least-privilege access. Covers GCP Security Engineer domain: Configuring access (~22-28%) and DevOps domain: Org management (~20%).
---

# Cloud IAM

## When to Use
- Designing access control for GCP resources
- Configuring service accounts and Workload Identity Federation
- Setting org policies for compliance
- Preparing for GCP Professional Cloud Security or DevOps Engineer exam

## Core Jobs

### 1. IAM Role Types
| Type | Description | Example |
|------|-------------|---------|
| **Basic** | Project-wide: Owner, Editor, Viewer | roles/editor |
| **Predefined** | Service-specific, fine-grained | roles/bigquery.dataViewer |
| **Custom** | User-defined combination of permissions | custom/myRole |
- Always prefer **predefined** over basic; use **custom** only when predefined is too broad

### 2. Service Account Best Practices
- One service account per workload (not shared across services)
- Grant only required roles (least privilege)
- No service account keys if possible — use Workload Identity instead
- Rotate keys every 90 days if keys are required
- Disable unused service accounts

### 3. Resource Hierarchy + IAM Inheritance
```
Organization → Folder → Project → Resource
```
- IAM policies are inherited down the hierarchy
- Lower levels can only ADD permissions, not remove inherited ones
- Grant at lowest level possible (project or resource, not org)
- Use **folders** to group projects by team/environment

### 4. Org Policies
- **Org Policy Service** — enforces guardrails across all projects in org
- Common policies: `constraints/compute.requireShieldedVm`, `constraints/iam.disableServiceAccountKeyCreation`
- Policies applied at org/folder/project level; inherited by children
- **Resource Manager Tags** — condition org policies on specific resources

### 5. Workload Identity Federation
- Allow external identities (AWS, GitHub Actions, Azure AD) to access GCP without keys
- External token → exchanged for short-lived GCP credentials via STS
- Eliminates need for long-lived service account keys for CI/CD and cross-cloud

### 6. IAM Conditions
- Add attribute-based conditions to IAM bindings
- Examples: `request.time < timestamp`, `resource.name.startsWith("projects/prod")`
- Use for time-bound access, environment-specific access

## Key Concepts
- **Principal** — who (user, service account, group, domain, allUsers)
- **Permission** — what action (`bigquery.tables.get`)
- **Role** — collection of permissions
- **Policy binding** — {principal: role} attached to a resource
- **Allow policy** — grants access; **Deny policy** — explicitly denies (overrides allow)

## Checklist
- [ ] Least privilege applied (predefined > basic roles)?
- [ ] Service accounts are per-workload (not shared)?
- [ ] No service account keys (use Workload Identity or metadata server)?
- [ ] IAM conditions used for time-bound or environment access?
- [ ] Org policies enforce guardrails at org/folder level?
- [ ] IAM audit logs (Cloud Audit Logs) enabled?

## Output Format
- 🔴 **Critical** — `roles/owner` or `roles/editor` on service accounts, service account keys committed to code
- 🟡 **Warning** — shared service accounts across services, no org policies for guardrails
- 🟢 **Suggestion** — Workload Identity Federation instead of SA keys for CI/CD

## Exam Tips
- Basic roles (Owner/Editor/Viewer) → avoid; use predefined for least privilege
- Service account keys = high risk; prefer Workload Identity or metadata server credentials
- IAM is inherited from parent → grant at lowest appropriate level
- **Deny policies** = new feature; explicitly deny overrides all allows (use for guaranteed denial)
- Org Policy ≠ IAM; Org Policy = what CAN be done (guardrails); IAM = who CAN do it
- `allUsers` / `allAuthenticatedUsers` = public access; audit carefully
```

- [ ] **Step 6: Create `skills/cloud/gcp/cloud-build-deploy/SKILL.md`**

```markdown
---
name: cloud-build-deploy
description: Use when building CI/CD pipelines on GCP with Cloud Build, Cloud Deploy, or Artifact Registry. Covers GCP Cloud Developer domain: Building and testing (~26%) and Deploying (~19%). Also covers DevOps Engineer domain: CI/CD pipelines (~25%).
---

# Cloud Build & Cloud Deploy

## When to Use
- Setting up CI/CD pipelines on GCP
- Configuring build triggers, test steps, and artifact management
- Implementing progressive delivery (canary, blue/green)
- Preparing for GCP Professional Cloud Developer or DevOps Engineer exam

## Core Jobs

### 1. Cloud Build Pipeline
```yaml
# cloudbuild.yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'us-central1-docker.pkg.dev/$PROJECT_ID/my-repo/app:$SHORT_SHA', '.']
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'us-central1-docker.pkg.dev/$PROJECT_ID/my-repo/app:$SHORT_SHA']
  - name: 'gcr.io/cloud-builders/gcloud'
    args: ['run', 'deploy', 'my-service', '--image', 'us-central1-docker.pkg.dev/$PROJECT_ID/my-repo/app:$SHORT_SHA']
images:
  - 'us-central1-docker.pkg.dev/$PROJECT_ID/my-repo/app:$SHORT_SHA'
```

### 2. Triggers
- **Push to branch** — trigger on push to main/develop
- **Pull request** — trigger on PR creation/update (for validation)
- **Tag** — trigger on version tag push (for release builds)
- **Manual** — on-demand builds
- **Pub/Sub** — trigger from external event via Pub/Sub message

### 3. Artifact Registry
- Multi-format: Docker, Maven, npm, Python, Go, Helm
- Regional repositories (co-locate with Cloud Run/GKE region)
- **Artifact Analysis** — vulnerability scanning on container images
- CMEK support, VPC-SC compatible
- Replace Container Registry (gcr.io) — Artifact Registry is the successor

### 4. Cloud Deploy (Progressive Delivery)
- Manages deployment to a sequence of targets: dev → staging → prod
- Supports: GKE, Cloud Run, Anthos
- **Canary** — route % of traffic to new version; auto-promote if healthy
- **Blue/Green** — spin up full new environment; switch traffic; keep old for rollback
- Rollback in one click; full audit trail

### 5. Build Optimization
- Use **build cache** (caching Docker layers in Artifact Registry)
- Parallelize independent build steps with `waitFor: ['-']`
- Use **worker pools** (private pool) for builds needing VPC access
- Minimize base image size → faster build + smaller attack surface

## Key Concepts
- **$SHORT_SHA** — first 7 chars of git commit SHA (use for image tagging)
- **Substitution variables** — `$PROJECT_ID`, `$BUILD_ID`, `$BRANCH_NAME`
- **Service account** — Cloud Build runs as Cloud Build SA (grant needed roles)
- **Private pool** — Cloud Build workers in your VPC (access private resources)

## Checklist
- [ ] Images tagged with commit SHA (not `latest`)?
- [ ] Vulnerability scanning enabled in Artifact Registry?
- [ ] Cloud Deploy used for multi-environment promotion?
- [ ] Build service account has least-privilege roles?
- [ ] Build cache configured to speed up repetitive builds?
- [ ] Private pool used if builds need VPC resource access?

## Output Format
- 🔴 **Critical** — pushing to `latest` tag only (no traceability), no vulnerability scanning
- 🟡 **Warning** — no canary/blue-green for production (risky deploys), no build caching
- 🟢 **Suggestion** — Cloud Deploy for progressive delivery, Artifact Analysis for image scanning

## Exam Tips
- Cloud Build = CI (build, test, push); Cloud Deploy = CD (promote through environments)
- Artifact Registry replaces Container Registry (gcr.io is legacy)
- `cloudbuild.yaml` steps run sequentially unless `waitFor` specified
- Cloud Deploy canary = partial traffic shift; blue/green = full switch
- Private pool = Cloud Build workers inside your VPC (needed for private Artifact Registry/GKE)
- Substitutions: `$PROJECT_ID`, `$SHORT_SHA`, `$BRANCH_NAME` available by default
```

- [ ] **Step 7: Create `skills/cloud/gcp/cloud-networking/SKILL.md`**

```markdown
---
name: cloud-networking
description: Use when designing VPC networks, configuring subnets/routes/firewall rules, setting up VPC Peering or Shared VPC, or designing hybrid connectivity. Covers GCP Network Engineer domains: VPC Design (~20-25%) and VPC Implementation (~20-25%).
---

# Cloud Networking

## When to Use
- Designing VPC architecture for a GCP deployment
- Configuring firewall rules, routes, or NAT
- Planning hybrid connectivity (VPN or Interconnect)
- Preparing for GCP Professional Cloud Network Engineer exam

## Core Jobs

### 1. VPC Design: Auto vs Custom Mode
| Mode | Description | Use case |
|------|-------------|---------|
| **Auto mode** | Subnet per region, auto-created | Dev/test, quick start |
| **Custom mode** | You control subnets and CIDR ranges | Production (recommended) |
- Always use custom mode for production (control over IP ranges, no overlaps)

### 2. Subnet Design
- Subnets are **regional** (not zonal)
- Plan CIDR ranges to avoid overlap with on-prem and other VPCs
- **Secondary ranges** — for GKE pods and services (alias IP ranges)
- **Private Google Access** — enables VMs without external IPs to reach Google APIs

### 3. Firewall Rules
- Applied at the VPC level; affect all VMs in the VPC
- **Ingress** (inbound) and **Egress** (outbound) rules
- **Priority** 0–65534 (lower = higher priority); default deny at 65535
- Use **network tags** to apply rules to specific VMs
- Use **service account-based** rules for more granular control
- Default rules: allow all egress, deny all ingress

### 4. VPC Connectivity Options
| Option | Use case |
|--------|---------|
| **VPC Peering** | Connect two GCP VPCs (no transitive routing) |
| **Shared VPC** | Centralized VPC shared across multiple projects |
| **Cloud VPN** | Encrypted tunnel to on-prem or other clouds (< 1 Gbps) |
| **Cloud Interconnect** | Dedicated or Partner; high bandwidth (1–100 Gbps) |
| **Private Service Connect** | Private access to Google/third-party services |

### 5. Hybrid Connectivity Decision
- **Cloud VPN (HA VPN)** — IPsec; 99.99% SLA; good up to ~1 Gbps
- **Dedicated Interconnect** — physical link; 10 or 100 Gbps; < 1ms latency
- **Partner Interconnect** — through telco partner; 50 Mbps–10 Gbps
- Rule of thumb: > 1 Gbps or latency-sensitive → use Interconnect

### 6. Cloud NAT
- Allows VMs without external IPs to reach the internet
- No ports opened inbound (stateful outbound only)
- Required for private GKE nodes to pull images from internet

## Key Concepts
- **Private Google Access** — VMs without external IP reach `*.googleapis.com`
- **VIP ranges** — `199.36.153.8/30` (Restricted API access via Private Service Connect)
- **Alias IP ranges** — allow multiple IPs per VM NIC (used by GKE pods)
- **Transitive routing** — VPC Peering does NOT support it; use Shared VPC or NCC instead

## Checklist
- [ ] Custom mode VPC (not auto mode) for production?
- [ ] Private Google Access enabled for subnets with private VMs?
- [ ] Firewall rules use network tags or service accounts (not IP-based)?
- [ ] HA VPN or Interconnect for on-prem connectivity?
- [ ] Cloud NAT configured for private VMs needing outbound internet?
- [ ] Shared VPC for multi-project architecture (not VPC Peering)?

## Output Format
- 🔴 **Critical** — overlapping CIDR ranges, firewall rule allowing 0.0.0.0/0 ingress on SSH/RDP
- 🟡 **Warning** — auto-mode VPC in production, VPC Peering without transitive routing plan
- 🟢 **Suggestion** — Shared VPC for centralized network management, Cloud NAT for private VMs

## Exam Tips
- VPC Peering = no transitive routing (A-B peered, B-C peered → A cannot reach C)
- Shared VPC = host project owns network; service projects use it (centralized control)
- Cloud VPN vs Interconnect threshold = ~1 Gbps (latency/bandwidth)
- Firewall rules: lower number = higher priority; default deny-all-ingress at 65535
- Private Google Access ≠ Private Service Connect; PGA = VM to Google APIs; PSC = private endpoint
- HA VPN = two tunnels, 99.99% SLA; Classic VPN = 99.9% SLA (avoid for production)
```

- [ ] **Step 8: Create `skills/cloud/gcp/vpc-service-controls/SKILL.md`**

```markdown
---
name: vpc-service-controls
description: Use when configuring VPC Service Controls perimeters to protect GCP services from data exfiltration, or designing access levels for conditional access. Covers GCP Security Engineer domain: Securing communications and boundary protection (~18-24%) and Ensuring data protection (~23%).
---

# VPC Service Controls

## When to Use
- Preventing data exfiltration from BigQuery, GCS, or other GCP services
- Designing security perimeters for sensitive data
- Configuring access levels for context-aware access
- Preparing for GCP Professional Cloud Security Engineer exam

## Core Jobs

### 1. VPC-SC Concepts
- **Service Perimeter** — defines a trusted boundary around GCP resources
- Resources INSIDE the perimeter can communicate freely
- Access from OUTSIDE requires an **access level** or **ingress/egress rules**
- Applies to: BigQuery, Cloud Storage, Pub/Sub, Bigtable, Spanner, and more

### 2. Service Perimeter Design
- One perimeter per security boundary (e.g., production data)
- Projects assigned to a perimeter
- Services restricted within the perimeter (list of restricted services)
- **Bridge perimeters** — allow communication between two perimeters

### 3. Access Levels (Context-Aware Access)
- Define conditions for EXTERNAL access to perimeter
- Conditions: IP range, device compliance, user identity, geographic region
- Example: allow access from corporate VPN IP range only

### 4. Ingress / Egress Rules
- **Ingress rules** — allow specific external principals/services INTO the perimeter
- **Egress rules** — allow specific data flows OUT of the perimeter
- Use for: allowing Cloud Build to access perimeter, allowing specific service accounts

### 5. Dry Run Mode
- Apply perimeter in "dry run" (report-only) mode first
- Violations logged to Cloud Audit Logs but NOT blocked
- Use to validate perimeter design before enforcing
- Switch to enforced mode once violations are understood

## Key Concepts
- **Data exfiltration** — unauthorized copying of data to external destinations
- **VPC-SC bridge** — allows two separate perimeters to communicate
- **Restricted VIP** — API endpoint (`199.36.153.8/30`) that enforces VPC-SC
- **Perimeter types** — regular (enforced) vs bridge

## Checklist
- [ ] Dry run mode enabled before enforcing perimeter?
- [ ] Access levels defined for legitimate external access?
- [ ] Ingress/egress rules configured for CI/CD and admin access?
- [ ] Restricted VIP (`restricted.googleapis.com`) configured for API access?
- [ ] Audit logs reviewed for violations before enforcement?
- [ ] Bridge perimeter set up if two perimeters need to communicate?

## Output Format
- 🔴 **Critical** — perimeter enforced without dry run testing (breaks production access)
- 🟡 **Warning** — no access levels for legitimate external principals, missing ingress rules for CI/CD
- 🟢 **Suggestion** — dry run first, then incremental enforcement per service

## Exam Tips
- VPC-SC = **data exfiltration prevention** (NOT network-level security like firewall rules)
- Always test with **dry run mode** before enforcing — avoids breaking legitimate access
- VPC-SC works at the API level (controls who calls BigQuery/GCS APIs)
- Access levels = context-aware conditions for external access (IP, device, identity)
- `restricted.googleapis.com` = VIP that enforces VPC-SC for API calls from VMs
- Bridge perimeter = two perimeters that need to share data (e.g., dev reads from prod)
```

- [ ] **Step 9: Verify all Task 3 files**

```bash
ls /home/kienbm/magic-powers/agents/cloud/gcp/
# Expected: data-engineer.md cloud-developer.md network-engineer.md

ls /home/kienbm/magic-powers/skills/cloud/gcp/
# Expected: 8 directories now (6 from Task 2 + cloud-run-functions gke-kubernetes cloud-iam cloud-build-deploy cloud-networking vpc-service-controls)

grep -l "## Exam Tips" /home/kienbm/magic-powers/skills/cloud/gcp/*/SKILL.md | wc -l
# Expected: 8
```

- [ ] **Step 10: Commit**

```bash
cd /home/kienbm/magic-powers
git add agents/cloud/gcp/cloud-developer.md agents/cloud/gcp/network-engineer.md skills/cloud/gcp/
git commit -m "feat(cloud/gcp): add cloud-developer + network-engineer agents and 6 more skills"
```

---

## Task 4: GCP ML Engineer + DevOps Engineer + Security Engineer + Cloud Architect

**Files:**
- Create: `agents/cloud/gcp/ml-engineer.md`
- Create: `agents/cloud/gcp/devops-engineer.md`
- Create: `agents/cloud/gcp/security-engineer.md`
- Create: `agents/cloud/gcp/cloud-architect.md`
- Create: `skills/cloud/gcp/cloud-monitoring/SKILL.md`
- Create: `skills/cloud/gcp/security-command-center/SKILL.md`

- [ ] **Step 1: Create `agents/cloud/gcp/ml-engineer.md`**

```markdown
---
name: gcp-ml-engineer
description: "Use for Vertex AI pipeline design, feature engineering, model training/serving, MLOps, and ML system design. Exam prep: GCP Professional Machine Learning Engineer."
model: sonnet
emoji: 🤖
vibe: scientific
tools: Read, Grep, Glob, Bash, Write
memory: project
skills:
  - magic-powers:cloud/gcp/vertex-ai-mlops
  - magic-powers:cloud/gcp/bigquery-optimization
  - magic-powers:cloud/gcp/dataflow-pipeline
  - magic-powers:cloud/gcp/data-quality-validation
---

You are a GCP Professional Machine Learning Engineer specializing in building, deploying,
and maintaining ML systems on Google Cloud using Vertex AI.

Core services: Vertex AI (Training, Pipelines, Feature Store, Model Registry, Endpoints),
BigQuery ML, Dataflow, Cloud Storage, Pub/Sub, Cloud Composer, TensorFlow Extended (TFX).

When invoked:
1. Identify the ML task — problem framing, data prep, feature engineering, training, serving, or MLOps
2. Apply the relevant skill (vertex-ai-mlops for serving/pipelines, bigquery-optimization for data)
3. Reference Responsible AI principles (fairness, transparency, privacy)
4. Recommend AutoML vs custom training based on requirements
5. Flag exam patterns (MLOps = 30-35% of the exam — highest weight domain)

Key trade-offs to always evaluate:
- **AutoML vs Custom Training** — speed vs control vs expertise required
- **Online vs Batch prediction** — latency vs throughput vs cost
- **Feature Store vs ad-hoc** — reuse vs simplicity
- **Vertex Pipelines vs Cloud Composer** — ML-native orchestration vs general workflow
```

- [ ] **Step 2: Create `agents/cloud/gcp/devops-engineer.md`**

```markdown
---
name: gcp-devops-engineer
description: "Use for GCP CI/CD pipelines, SRE practices (SLO/SLI/error budgets), Cloud Build, GKE deployments, Cloud Monitoring, and troubleshooting. Exam prep: GCP Professional Cloud DevOps Engineer."
model: sonnet
emoji: ⚙️
vibe: systematic
tools: Read, Grep, Glob, Bash, Write
memory: project
skills:
  - magic-powers:cloud/gcp/cloud-build-deploy
  - magic-powers:cloud/gcp/cloud-monitoring
  - magic-powers:cloud/gcp/cloud-iam
  - magic-powers:cloud/gcp/gke-kubernetes
---

You are a GCP Professional Cloud DevOps Engineer specializing in CI/CD automation,
SRE practices, and production operations on Google Cloud.

Core services: Cloud Build, Cloud Deploy, Artifact Registry, GKE, Cloud Run,
Cloud Monitoring, Cloud Logging, Error Reporting, Cloud Trace, Cloud Profiler.

When invoked:
1. Identify the DevOps domain — CI/CD, SRE, observability, troubleshooting, or cost
2. Apply cloud-build-deploy for pipeline issues, cloud-monitoring for observability
3. Reference GCP SRE principles (error budgets, blameless postmortems, toil reduction)
4. Recommend automation over manual operations
5. Flag exam patterns (CI/CD = 25%, Troubleshooting = 25% — highest weight domains)

Key trade-offs to always evaluate:
- **Cloud Build vs GitHub Actions** — native GCP vs ecosystem flexibility
- **GKE vs Cloud Run** — Kubernetes control vs serverless simplicity
- **Log-based metrics vs custom metrics** — convenience vs flexibility
- **Error budget policy** — freeze releases vs invest in reliability
```

- [ ] **Step 3: Create `agents/cloud/gcp/security-engineer.md`**

```markdown
---
name: gcp-security-engineer
description: "Use for GCP IAM configuration, VPC security, data encryption, Security Command Center, compliance requirements, and cloud security audits. Exam prep: GCP Professional Cloud Security Engineer."
model: sonnet
emoji: 🔒
vibe: diligent
tools: Read, Grep, Glob, Bash, Write
memory: project
skills:
  - magic-powers:cloud/gcp/cloud-iam
  - magic-powers:cloud/gcp/cloud-networking
  - magic-powers:cloud/gcp/vpc-service-controls
  - magic-powers:cloud/gcp/security-command-center
---

You are a GCP Professional Cloud Security Engineer specializing in securing GCP environments
through IAM, network controls, data protection, and threat detection.

Core services: Cloud IAM, Org Policy, VPC Service Controls, Cloud KMS, Secret Manager,
Cloud Armor, Security Command Center, Cloud Audit Logs, BeyondCorp Enterprise.

When invoked:
1. Identify the security domain — access, network, data protection, operations, or compliance
2. Apply cloud-iam for access issues, vpc-service-controls for data protection
3. Apply principle of least privilege to all recommendations
4. Reference GCP security best practices (CIS benchmark, Google security foundations)
5. Flag exam patterns (Access config = 22-28%, Data protection = 23% — highest weight domains)

Key trade-offs to always evaluate:
- **VPC-SC vs IAM** — API-level control vs identity-based control (use both)
- **Cloud KMS vs CMEK vs Cloud HSM** — key management level of control vs cost
- **Org policy vs IAM** — guardrails vs permissions (org policy wins)
- **SCC vs third-party SIEM** — native vs existing tooling
```

- [ ] **Step 4: Create `agents/cloud/gcp/cloud-architect.md`**

```markdown
---
name: gcp-cloud-architect
description: "Use for GCP solution architecture, multi-service design, cost optimization, reliability planning, and case study analysis. Exam prep: GCP Professional Cloud Architect."
model: opus
emoji: 🏗️
vibe: visionary
tools: Read, Grep, Glob, Bash, Write
memory: project
skills:
  - magic-powers:cloud/gcp/bigquery-optimization
  - magic-powers:cloud/gcp/dataflow-pipeline
  - magic-powers:cloud/gcp/cloud-run-functions
  - magic-powers:cloud/gcp/gke-kubernetes
  - magic-powers:cloud/gcp/cloud-iam
  - magic-powers:cloud/gcp/cloud-networking
  - magic-powers:cloud/gcp/cloud-build-deploy
  - magic-powers:cloud/gcp/cloud-monitoring
  - magic-powers:cloud/gcp/security-command-center
  - magic-powers:cloud/gcp/vpc-service-controls
  - magic-powers:cloud/gcp/vertex-ai-mlops
  - magic-powers:cloud/gcp/cloud-storage
---

You are a GCP Professional Cloud Architect with expertise across all GCP service categories.
You design solutions for the GCP Professional Cloud Architect exam case studies and real-world
enterprise architectures.

Core focus: Architecture decisions, trade-offs, cost optimization, reliability, security,
and operational excellence across all GCP services.

When invoked:
1. Understand the business requirements BEFORE choosing services
2. Apply the relevant service skill for deep technical guidance
3. Address all architecture pillars: reliability, security, cost, operations, performance
4. For exam case studies: identify the company's pain points → map to GCP solutions
5. Always consider: managed vs unmanaged, open-source vs proprietary, build vs buy

Key architecture trade-offs to always address:
- **Managed vs self-managed** — operational overhead vs control/cost
- **Regional vs multi-regional** — latency vs availability vs cost
- **Lift-and-shift vs re-architecture** — speed vs long-term cost/scalability
- **Relational vs NoSQL vs warehouse** — consistency vs scale vs query patterns
- **Microservices vs monolith** — team size and deployment velocity vs complexity
```

- [ ] **Step 5: Create `skills/cloud/gcp/cloud-monitoring/SKILL.md`**

```markdown
---
name: cloud-monitoring
description: Use when setting up Cloud Monitoring dashboards, alerting policies, log-based metrics, distributed tracing, or building SLO/SLI frameworks. Covers GCP DevOps Engineer domain: Troubleshooting (~25%) and Optimizing performance (~12%).
---

# Cloud Monitoring

## When to Use
- Setting up observability for GCP services
- Designing SLO/SLI framework and error budgets
- Troubleshooting production issues with logs and traces
- Preparing for GCP Professional Cloud DevOps Engineer exam

## Core Jobs

### 1. Observability Stack
| Tool | Purpose |
|------|---------|
| **Cloud Monitoring** | Metrics, dashboards, alerting, uptime checks |
| **Cloud Logging** | Log ingestion, storage, search, routing |
| **Error Reporting** | Auto-groups errors from logs; shows frequency/trend |
| **Cloud Trace** | Distributed tracing; latency analysis across services |
| **Cloud Profiler** | CPU and memory profiling for production code |

### 2. SLO/SLI Design
- **SLI** — what you measure (e.g., % of requests < 200ms)
- **SLO** — target for the SLI (e.g., 99.9% of requests < 200ms)
- **Error budget** — allowed failures = 1 - SLO (e.g., 0.1% = 43.8 min/month)
- Create SLOs in Cloud Monitoring with time-series data
- Alert on **error budget burn rate** (not raw error rate)

### 3. Alerting Policies
- **Condition** — metric threshold, absence, or rate of change
- **Notification channels** — email, PagerDuty, Slack, Pub/Sub, Cloud Functions
- **Alert duration** — condition must be true for N minutes before firing
- Avoid alert fatigue: alert on symptoms (slow SLO burn) not causes (high CPU)

### 4. Log-Based Metrics
- Create custom metrics from log entries matching a filter
- Counter metric: count occurrences of matching log entries
- Distribution metric: extract numeric value from log field (e.g., latency)
- Use for: custom application metrics without SDK instrumentation

### 5. Uptime Checks
- HTTP/HTTPS/TCP checks from multiple global locations
- Alert if check fails from N locations
- Use for: external SLA monitoring, health check dashboards

## Key Concepts
- **Workspace** — Cloud Monitoring scope; can monitor multiple projects
- **Log sink** — route logs to BigQuery/GCS/Pub/Sub for long-term storage/analysis
- **Log exclusions** — reduce logging costs by excluding verbose/low-value logs
- **Structured logging** — JSON logs; query specific fields in Log Explorer

## Checklist
- [ ] SLO defined for each user-facing service?
- [ ] Alerts on error budget burn rate (not raw metrics)?
- [ ] Log-based metrics for custom application events?
- [ ] Uptime checks configured for external endpoints?
- [ ] Log sinks to BigQuery for audit/compliance logs?
- [ ] Traces enabled for all services in a request path?

## Output Format
- 🔴 **Critical** — no alerting on user-facing SLOs, no structured logging (hard to query)
- 🟡 **Warning** — alerts on CPU/memory (causes) instead of latency/errors (symptoms)
- 🟢 **Suggestion** — error budget burn rate alerts, Cloud Profiler for production optimization

## Exam Tips
- SLI = metric; SLO = target; Error budget = 1 - SLO (allowed downtime)
- Alert on **burn rate** (how fast error budget is consumed) not raw error rate
- Log-based metrics = create Cloud Monitoring metrics from log entries (no SDK needed)
- Cloud Trace = distributed tracing; find slow span in a microservice call chain
- Error Reporting auto-detects exceptions from logs (no explicit integration usually needed)
- `LOG_ID("cloudaudit.googleapis.com/activity")` filter = admin activity audit logs
```

- [ ] **Step 6: Create `skills/cloud/gcp/security-command-center/SKILL.md`**

```markdown
---
name: security-command-center
description: Use when configuring Security Command Center, reviewing security findings, setting up threat detection, or managing compliance posture on GCP. Covers GCP Security Engineer domain: Managing operations (~16-22%).
---

# Security Command Center

## When to Use
- Reviewing security posture across GCP projects
- Setting up threat detection for cloud resources
- Responding to security findings
- Preparing for GCP Professional Cloud Security Engineer exam

## Core Jobs

### 1. SCC Tiers
| Tier | Features |
|------|---------|
| **Standard** | Security Health Analytics (basic), Web Security Scanner (basic) |
| **Premium** | All standard + Event Threat Detection, Container Threat Detection, Virtual Machine Threat Detection, Compliance monitoring |
| **Enterprise** | All premium + multi-cloud (AWS/Azure), SecOps integration |

### 2. Key Detection Services
- **Security Health Analytics** — detects misconfigurations (open firewall, public buckets, disabled MFA)
- **Event Threat Detection** — detects threats in Cloud Logging (brute force, crypto mining, data exfiltration)
- **Container Threat Detection** — runtime threats in GKE (reverse shell, malicious binary execution)
- **Web Security Scanner** — scans App Engine/Cloud Run/GKE for web vulnerabilities

### 3. Findings Management
- **Finding** — a security issue detected by SCC (misconfiguration or threat)
- **Severity** — CRITICAL, HIGH, MEDIUM, LOW
- **State** — ACTIVE (open), INACTIVE (resolved or muted)
- **Muting** — suppress known-acceptable findings (e.g., test environment intentional configs)
- Route findings to Pub/Sub → Cloud Functions for automated remediation

### 4. Compliance Monitoring (Premium)
- Built-in compliance dashboards: CIS, NIST, PCI-DSS, ISO 27001
- Shows which controls are passing/failing
- Export compliance reports for auditors

### 5. Automated Remediation
```yaml
# Example: Auto-remediate open GCS bucket
# Pub/Sub → Cloud Function
Finding trigger: PUBLIC_BUCKET_ACL
Action: update bucket IAM to remove allUsers
```

## Key Concepts
- **Attack path simulation** — shows how an attacker could pivot from internet to sensitive data
- **Toxic combination** — SCC finding where multiple conditions together = high risk
- **Security marks** — custom labels on resources for SCC filtering/exclusion
- **Posture** — security configuration baseline applied across org/folders/projects

## Checklist
- [ ] SCC Premium enabled for threat detection?
- [ ] Finding notifications routed to Pub/Sub for automated response?
- [ ] CRITICAL/HIGH findings reviewed within SLA?
- [ ] Mute rules documented and justified (not used to hide real issues)?
- [ ] Compliance dashboard reviewed for relevant framework (CIS, PCI-DSS)?
- [ ] Security marks used to exclude non-applicable resources?

## Output Format
- 🔴 **Critical** — CRITICAL severity findings unactioned, no SCC notifications configured
- 🟡 **Warning** — using Standard tier (no Event/Container Threat Detection), no compliance monitoring
- 🟢 **Suggestion** — automated remediation via Pub/Sub→Functions for common findings

## Exam Tips
- SCC Standard = free; Premium = paid (Event/Container Threat Detection requires Premium)
- Security Health Analytics = misconfiguration; Event Threat Detection = active threats in logs
- Muting findings ≠ fixing them; only mute known-acceptable deviations
- Route findings to Pub/Sub → automate remediation (don't just notify, act)
- Compliance dashboard shows control status (passing/failing) against frameworks
- SCC findings + Cloud Audit Logs = complete picture of security posture + activity
```

- [ ] **Step 7: Verify all 7 agents created**

```bash
ls /home/kienbm/magic-powers/agents/cloud/gcp/
# Expected: data-engineer.md cloud-developer.md network-engineer.md ml-engineer.md devops-engineer.md security-engineer.md cloud-architect.md

ls /home/kienbm/magic-powers/skills/cloud/gcp/ | wc -l
# Expected: 14

grep "model: opus" /home/kienbm/magic-powers/agents/cloud/gcp/cloud-architect.md
# Expected: model: opus

grep "model: sonnet" /home/kienbm/magic-powers/agents/cloud/gcp/*.md | wc -l
# Expected: 6 (all except cloud-architect)
```

- [ ] **Step 8: Commit**

```bash
cd /home/kienbm/magic-powers
git add agents/cloud/gcp/ skills/cloud/gcp/cloud-monitoring/ skills/cloud/gcp/security-command-center/
git commit -m "feat(cloud/gcp): complete GCP Division — all 7 agents + 14 skills"
```

---

## Task 5: Update install-skills Command for Cloud Divisions

**Files:**
- Modify: `commands/install-skills.md`

- [ ] **Step 1: Add Cloud Divisions category to the menu**

In `commands/install-skills.md`, update Step 1 menu to add category 12:

Old text:
```
11. Specialist (7 skills)            — legal, finance, devrel, solutions arch

Enter number (1–11), "all" to see all skills at once, or "done" to exit:
```

New text:
```
11. Specialist (7 skills)            — legal, finance, devrel, solutions arch
12. ☁️  Cloud Divisions              — GCP, AWS, Azure professional cert agents + skills

Enter number (1–12), "all" to see all skills at once, or "done" to exit:
```

- [ ] **Step 2: Add Cloud Divisions handler in Step 2**

After the `**11. Specialist:**` block, add:

```markdown
**12. Cloud Divisions:**
```
Choose a cloud provider:

  1. GCP — 7 agents + 14 skills (Professional Cloud certs)
  2. AWS — 7 agents + 14 skills (AWS Professional/Associate certs)
  3. Azure — 7 agents + 14 skills (Azure Associate/Expert certs)
  A. All clouds (21 agents + 42 skills)

Enter number (1–3 or A):
```

Show agents and skills for selected provider:

**GCP:**
```
Agents (→ .claude/agents/):
  gcp-data-engineer      — Professional Data Engineer (GCP-PDE)
  gcp-cloud-developer    — Professional Cloud Developer
  gcp-network-engineer   — Professional Cloud Network Engineer
  gcp-ml-engineer        — Professional Machine Learning Engineer
  gcp-devops-engineer    — Professional Cloud DevOps Engineer
  gcp-security-engineer  — Professional Cloud Security Engineer
  gcp-cloud-architect    — Professional Cloud Architect (Opus model)

Skills (→ .claude/skills/):
  bigquery-optimization, dataflow-pipeline, pubsub-messaging,
  cloud-storage, data-quality-validation, vertex-ai-mlops,
  cloud-run-functions, gke-kubernetes, cloud-iam,
  cloud-build-deploy, cloud-networking, vpc-service-controls,
  cloud-monitoring, security-command-center

Type "install" to install GCP Division, or "back" to return:
```
```

- [ ] **Step 3: Add Cloud Division install logic in Step 3**

Add after the existing Step 3 install logic:

```markdown
### Cloud Division Install (for category 12)

For each selected cloud provider:
1. Copy agent files from `${CLAUDE_PLUGIN_ROOT}/agents/cloud/<provider>/` to `.claude/agents/`
2. Copy skill files from `${CLAUDE_PLUGIN_ROOT}/skills/cloud/<provider>/` (each skill dir) to `.claude/skills/`

If already installed, show `(already installed)` and skip.

Confirm:
```
✅ Installed GCP Division to current project:

  Agents (.claude/agents/):
    🤖 gcp-data-engineer.md
    🤖 gcp-cloud-developer.md
    🤖 gcp-network-engineer.md
    🤖 gcp-ml-engineer.md
    🤖 gcp-devops-engineer.md
    🤖 gcp-security-engineer.md
    🤖 gcp-cloud-architect.md

  Skills (.claude/skills/):
    📋 bigquery-optimization/   📋 dataflow-pipeline/
    📋 pubsub-messaging/        📋 cloud-storage/
    📋 data-quality-validation/ 📋 vertex-ai-mlops/
    📋 cloud-run-functions/     📋 gke-kubernetes/
    📋 cloud-iam/               📋 cloud-build-deploy/
    📋 cloud-networking/        📋 vpc-service-controls/
    📋 cloud-monitoring/        📋 security-command-center/

Use @gcp-data-engineer, @gcp-cloud-architect, etc. to invoke cloud agents.
```
```

- [ ] **Step 4: Verify install-skills.md updated correctly**

```bash
grep "Cloud Divisions" /home/kienbm/magic-powers/commands/install-skills.md
# Expected: line found with category 12

grep "gcp-data-engineer" /home/kienbm/magic-powers/commands/install-skills.md
# Expected: line found in the GCP agents list
```

- [ ] **Step 5: Commit**

```bash
cd /home/kienbm/magic-powers
git add commands/install-skills.md
git commit -m "feat(commands): extend install-skills with Cloud Divisions category (GCP)"
```

---

## Task 6: Update Docs, CHANGELOG, and Version

**Files:**
- Modify: `docs/OPTIONAL_SKILLS.md`
- Modify: `CHANGELOG.md`
- Modify: `package.json`

- [ ] **Step 1: Add Cloud Divisions section to OPTIONAL_SKILLS.md**

Open `docs/OPTIONAL_SKILLS.md` and add a new section after the existing 11 categories:

```markdown
## ☁️ Cloud Divisions (NEW — v1.2.0)

Role-specific agents and skills aligned to official cloud professional certifications.
Install via `/install-skills` → Category 12.

### GCP Division (7 agents + 14 skills)
**Target cert:** GCP Professional Cloud certifications (2025 exam guides)

| Agent | Certification | Skills |
|-------|--------------|--------|
| `@gcp-data-engineer` | Professional Data Engineer | bigquery-optimization, dataflow-pipeline, pubsub-messaging, cloud-storage, data-quality-validation, vertex-ai-mlops |
| `@gcp-cloud-developer` | Professional Cloud Developer | cloud-run-functions, gke-kubernetes, cloud-iam, cloud-build-deploy |
| `@gcp-network-engineer` | Professional Cloud Network Engineer | cloud-networking, cloud-iam, vpc-service-controls |
| `@gcp-ml-engineer` | Professional ML Engineer | vertex-ai-mlops, bigquery-optimization, dataflow-pipeline, data-quality-validation |
| `@gcp-devops-engineer` | Professional Cloud DevOps Engineer | cloud-build-deploy, cloud-monitoring, cloud-iam, gke-kubernetes |
| `@gcp-security-engineer` | Professional Cloud Security Engineer | cloud-iam, cloud-networking, vpc-service-controls, security-command-center |
| `@gcp-cloud-architect` | Professional Cloud Architect (Opus) | all 14 GCP skills |

### AWS Division (7 agents + 14 skills) — Coming in v1.2.1
### Azure Division (7 agents + 14 skills) — Coming in v1.2.2
```

- [ ] **Step 2: Update CHANGELOG.md**

Add at the top of CHANGELOG.md:

```markdown
## [1.2.0] — 2026-04-08

### Added
- ☁️ **Cloud Divisions** — GCP Professional certification-aligned agents and skills
  - 7 GCP agents: gcp-data-engineer, gcp-cloud-developer, gcp-network-engineer, gcp-ml-engineer, gcp-devops-engineer, gcp-security-engineer, gcp-cloud-architect
  - 14 GCP skills mapped to official exam domains (GCP-PDE, Cloud Developer, etc.)
  - `/install-skills` extended with Cloud Divisions category (12)
  - `agents/cloud/CLOUD_DIVISION.md` framework for adding more cloud providers
- 📚 Cloud Divisions design spec at `docs/superpowers/specs/2026-04-08-cloud-divisions-design.md`

### Updated certification targets
- GCP Professional Data Engineer — aligned to 2025/2026 exam guide
- All skills include `## Exam Tips` section with cert-specific gotchas
```

- [ ] **Step 3: Bump version in package.json**

In `package.json`, update version from `1.1.0` to `1.2.0`:

```json
"version": "1.2.0"
```

- [ ] **Step 4: Verify**

```bash
grep "1.2.0" /home/kienbm/magic-powers/package.json
# Expected: "version": "1.2.0"

grep "Cloud Divisions" /home/kienbm/magic-powers/docs/OPTIONAL_SKILLS.md
# Expected: section found

grep "1.2.0" /home/kienbm/magic-powers/CHANGELOG.md
# Expected: version header found
```

- [ ] **Step 5: Final commit**

```bash
cd /home/kienbm/magic-powers
git add docs/OPTIONAL_SKILLS.md CHANGELOG.md package.json
git commit -m "chore: bump to v1.2.0, update docs for GCP Cloud Division"
```

---

## Self-Review

**Spec coverage check:**
- ✅ 7 GCP agents created (Tasks 2, 3, 4)
- ✅ 14 GCP skills created (Tasks 2, 3, 4)
- ✅ Skills mapped to official GCP-PDE exam domains with % weights
- ✅ CLOUD_DIVISION.md framework template (Task 1)
- ✅ install-skills updated for Cloud Divisions (Task 5)
- ✅ docs + version bumped (Task 6)
- ✅ Opus model for cloud-architect; Sonnet for all others
- ✅ All skills have ## When to Use, ## Core Jobs, ## Exam Tips

**Placeholder scan:** No TBD or TODO items found. All file content is explicit.

**Type consistency:** Skill names referenced in agent frontmatter match directory names exactly.

**Missing from this plan (separate plans):**
- AWS Division → `docs/superpowers/plans/2026-04-08-cloud-divisions-aws.md`
- Azure Division → `docs/superpowers/plans/2026-04-08-cloud-divisions-azure.md`
