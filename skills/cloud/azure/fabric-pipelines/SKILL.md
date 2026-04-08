---
name: fabric-pipelines
description: Use when building data pipeline orchestration in Microsoft Fabric, configuring Copy Data activities, scheduling data movement, implementing control flow logic, or studying for DP-700 (Microsoft Fabric Data Engineer Associate).
---

# Fabric Pipelines

## When to Use
- Orchestrating data movement and transformation workflows in Microsoft Fabric
- Implementing control flow logic (loops, conditions, error handling) in data pipelines
- Scheduling and triggering pipeline runs (time-based, event-based)
- Moving data with Copy Data activity from 100+ sources to Fabric destinations
- Deciding between Fabric Pipelines and Notebooks for data orchestration
- Preparing for Microsoft Fabric Data Engineer Associate (DP-700) exam

## Core Jobs

### 1. Pipeline Structure
- **Pipeline** = orchestration workflow; not a compute engine (Spark, SQL run separately)
- Hierarchy: Pipeline → Stages (parallel groups) → Activities (individual tasks)
- YAML-compatible definition; visual canvas authoring in Fabric UI
- Fabric Pipelines ≈ Azure Data Factory pipelines — same core concepts, Fabric-native

### 2. Activity Types
| Activity | Purpose |
|----------|---------|
| **Copy Data** | Move data from source to sink; 100+ connectors |
| **Dataflow** | Execute Dataflow Gen2 transformation |
| **Notebook** | Run a Spark Notebook |
| **Stored Procedure** | Execute SQL stored procedure in Warehouse/SQL |
| **Get Metadata** | Retrieve file/folder metadata (exists, size, count) |
| **ForEach** | Iterate over array; execute child activities per item |
| **If Condition** | Branch execution based on boolean expression |
| **Until** | Loop until condition is true (with timeout) |
| **Delete** | Delete files from Lakehouse Files or storage |
| **Wait** | Pause pipeline for specified duration |

### 3. Copy Data Activity
- Primary activity for **data movement** (not transformation)
- Source → optional column mapping → sink
- Supports: file formats (CSV, JSON, Parquet, Avro, ORC), databases, APIs
- Common pattern: `ADLS Gen2 → Lakehouse Files/` (bronze ingestion)
- **Schema mapping**: auto-detect or explicit column-to-column mapping
- **Fault tolerance**: skip incompatible rows; log errors to storage

### 4. Parameters and Variables
| Concept | Scope | Set by |
|---------|-------|--------|
| **Pipeline parameters** | Pipeline-wide input | Trigger at runtime, parent pipeline, or manual |
| **Pipeline variables** | Pipeline-wide mutable | Set Variable activity within pipeline |

- Parameters are immutable during run; variables can change (e.g., counter in ForEach loop)
- ForEach passes `@item()` to child activities; access parameter with `@pipeline().parameters.myParam`

### 5. Triggers
| Trigger Type | When it fires |
|--------------|---------------|
| **Schedule** | Fixed cron schedule (e.g., daily at 2 AM UTC) |
| **Tumbling Window** | Fixed non-overlapping time windows; backfill-capable |
| **Storage Event** | File arrives in OneLake/ADLS (event-driven ingestion) |
| **Custom Event** | Azure Event Grid event matches filter |
| **Manual** | On-demand via UI or API |

- **Tumbling Window** = best for incremental load patterns (each window = one time slice)
- Schedule trigger = simple recurring; no window concept; all runs independent

### 6. Error Handling and Control Flow
- Each activity has: **On Success**, **On Failure**, **On Completion**, **On Skip** paths
- **Retry policy**: set max retry count and retry interval per activity
- **Failure path**: connect activities to handle errors (e.g., send Teams notification on failure)
- Global pipeline timeout: default 7 days; set shorter for critical pipelines
- Monitoring: all run history in **Monitoring Hub** with per-activity status and error details

## Key Concepts
- **Copy Data activity** — data movement only; no transformation logic; use Dataflow/Notebook for transforms
- **ForEach** — iterates array parameter; sequential or parallel (set parallelism degree)
- **Tumbling Window trigger** — non-overlapping fixed intervals; each window has its own run; good for incremental
- **Monitoring Hub** — central view of all pipeline/activity runs; filter by status, date, pipeline name
- **Linked service** — connection definition for external data sources (reusable across activities)
- **Dataset** — pointer to specific data within a linked service (table, file path, query)

## Checklist
- [ ] Copy Data activity used for movement; Dataflow/Notebook used for transformation?
- [ ] Pipeline parameters defined for dynamic values (table names, date ranges)?
- [ ] ForEach activity configured with appropriate parallelism (avoid too many concurrent connections)?
- [ ] Failure paths connected with notification or logging activity?
- [ ] Retry policy set on activities that may have transient failures (network, source availability)?
- [ ] Tumbling Window trigger used for incremental loads requiring backfill capability?
- [ ] Pipeline timeout set appropriately (not left at default 7 days for short workflows)?

## Output Format
- 🔴 **Critical** — using Copy Data activity for data transformation (it only moves data; no transform logic)
- 🔴 **Critical** — no failure path on critical activities; failures silently ignored
- 🟡 **Warning** — hardcoded values in pipeline activities instead of parameters (reduces reusability)
- 🟡 **Warning** — ForEach with sequential execution on large arrays (causes slow pipeline runs)
- 🟢 **Suggestion** — use Tumbling Window trigger for incremental load to enable backfill on failure

## Exam Tips
- **Copy Data activity = data movement, not transformation** — for transformation, use Dataflow Gen2 activity or Notebook activity
- **ForEach = iterate over array parameter** — use sequential for rate-limited sources; parallel for independent items (set batch count)
- **Pipeline parameters vs variables** — parameters are read-only inputs set at trigger time; variables are mutable within pipeline execution
- **Tumbling Window trigger** — fixed non-overlapping intervals (e.g., hourly); each window runs independently; enables backfill for missed runs
- **Fabric Pipelines ≈ Azure Data Factory** — same activity types and concepts; exam may test ADF knowledge in Fabric context
- **Monitor pipelines in Monitoring Hub** — check activity run details for input/output and error messages; not in workspace item list
