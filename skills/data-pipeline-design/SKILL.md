---
name: data-pipeline-design
description: Use when designing ETL/ELT pipelines, choosing between streaming vs batch, or architecting data flow between systems
---

# Data Pipeline Design

## When to Use
When building or reviewing data movement between systems — ingestion, transformation, and delivery to consumers.

## Core Jobs

### 1. Choose the Pattern
**Batch (ETL/ELT)**:
- Data moves on schedule (hourly, daily)
- Use when: latency tolerance > 1 hour, source systems can't stream, cost matters
- Tools: Airflow, dbt, Spark, AWS Glue

**Streaming**:
- Data moves continuously (seconds to milliseconds)
- Use when: real-time dashboards, fraud detection, event-driven systems
- Tools: Kafka, Flink, Kinesis, Pub/Sub

**Hybrid**: batch for historical backfill, streaming for current data (Lambda architecture)

### 2. Design the Pipeline Stages
```
Source → Ingest → Validate → Transform → Load → Serve
```
For each stage define:
- What enters, what exits (schema)
- Error handling (dead-letter queue or retry)
- Latency requirement
- Volume (rows/sec at peak)

### 3. Handle Failures
- Idempotent transforms: re-running produces same result
- Checkpointing: resume from last successful point
- Dead-letter queues: capture failed records for inspection
- Alerting: pipeline lag > N minutes → page on-call

### 4. Document the Lineage
- Source → destination for each field
- Transformation logic (not just code — business intent)
- Owner per pipeline segment

## Key Outputs
- Pipeline architecture diagram
- Schema definitions (source and target)
- Failure handling spec
- Lineage documentation

## Anti-Patterns
- No idempotency — reruns create duplicates
- Streaming everything when batch suffices (costs 10x more)
- No data quality checks at ingestion
- Pipelines with no owner
