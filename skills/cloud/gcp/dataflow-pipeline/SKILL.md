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
