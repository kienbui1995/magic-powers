---
name: glue-etl
description: Use when building ETL pipelines with AWS Glue, managing the Glue Data Catalog, designing crawler strategies, or choosing between Glue and EMR. Covers AWS DEA-C01 domain: Data Ingestion and Transformation.
---

# AWS Glue ETL

## When to Use
- Building serverless ETL pipelines on AWS without managing infrastructure
- Deciding between AWS Glue and Amazon EMR for a transformation workload
- Designing Glue Data Catalog schema and crawler strategies
- Using Glue Studio (visual ETL) or Glue Notebooks for data preparation
- Implementing incremental data processing with job bookmarks
- Preparing for AWS Certified Data Engineer Associate (DEA-C01) exam

## Core Jobs

### 1. Glue vs EMR Decision

| Factor | Choose AWS Glue | Choose Amazon EMR |
|--------|----------------|-------------------|
| Management | Fully serverless, no cluster to manage | Cluster management required (or EMR Serverless) |
| Runtime | Apache Spark (managed), Python shell | Spark, Hadoop, Hive, Presto, Flink — full ecosystem |
| Existing code | Greenfield ETL | Migrating existing Spark/Hadoop jobs |
| Data Catalog | Built-in (Hive metastore compatible) | Uses Glue Data Catalog or own Hive metastore |
| Streaming | Glue Streaming (micro-batch) | Spark Streaming, Flink (true streaming) |
| Cost model | DPU-hours billed per job run | Cluster uptime (can be costly for short jobs) |
| Best for | Simple-to-moderate ETL, scheduled batch | Complex Spark workloads, custom libraries, ML |

**Decision rule**: Default to Glue for new ETL workloads. Choose EMR when you need custom Spark configurations, non-Spark runtimes, or are migrating existing cluster-based jobs.

### 2. DynamicFrame vs DataFrame

| Aspect | DynamicFrame | DataFrame |
|--------|-------------|-----------|
| Schema | Flexible — handles inconsistent/nested schemas automatically | Requires clean, defined schema |
| Origin | Glue-native abstraction | Apache Spark native |
| Operations | Glue-specific transforms (ApplyMapping, ResolveChoice, DropNullFields) | Full Spark SQL API |
| Convert | `df = dynamic_frame.toDF()` | `dyf = DynamicFrame.fromDF(df, glue_ctx, "name")` |
| Best for | Reading messy source data with mixed types | Complex aggregations, window functions, joins |

**Rule**: Use DynamicFrame for reading from sources with schema inconsistencies. Convert to DataFrame for complex Spark operations, then convert back to DynamicFrame for writing.

### 3. Glue Data Catalog

- Central metadata repository — Hive metastore compatible
- Shared by Athena, Redshift Spectrum, EMR, Lake Formation
- Structure: **Data Catalog → Databases → Tables → Partitions**
- Tables can point to S3, RDS, DynamoDB, JDBC sources
- Schema versions tracked automatically; schema evolution supported
- Used as the metadata layer for AWS Lake Formation governance

### 4. Job Bookmarks (Incremental Processing)

- Tracks which data has already been processed in previous job runs
- Prevents reprocessing of old data in incremental loads from S3, JDBC, DynamoDB
- Configuration:
  - `--job-bookmark-option job-bookmark-enable` — enable bookmarks
  - `--job-bookmark-option job-bookmark-disable` — full refresh (no bookmark)
  - `--job-bookmark-option job-bookmark-pause` — pause without resetting
- Works by tracking S3 object metadata (ETags, last modified) and file offsets
- Reset bookmark via Glue console or `reset_job_bookmark` API call

### 5. Glue Crawlers

- Auto-discover schema from S3, JDBC, DynamoDB, and other sources
- Creates/updates tables in the Glue Data Catalog
- Detect new partitions and schema changes on each run
- Classifier hierarchy: built-in (JSON, CSV, Parquet, ORC) → custom classifiers
- Schedule: on-demand, cron-based, or triggered via EventBridge
- Best practice: schedule crawlers AFTER data arrives, not continuously

### 6. Glue Workflows and Orchestration

- Orchestrate multi-step ETL: crawlers → triggers → jobs → triggers → jobs
- Trigger types:
  - **Scheduled** — cron expression
  - **On-demand** — manual or API
  - **Conditional** — fires when specified jobs/crawlers succeed, fail, or complete
- Use EventBridge for more complex event-driven orchestration (S3 upload → Glue job)
- For complex ML/data pipelines: Step Functions + Glue > Glue Workflows alone

### 7. Glue Streaming (Continuous ETL)

- Reads from Kinesis Data Streams or Apache Kafka (MSK) in micro-batches
- Window sizes: 100 seconds minimum; not true real-time like Kinesis Analytics
- Use when: near-real-time ETL to S3/Redshift, applying transformations to streaming data
- Glue Streaming vs Kinesis Data Analytics: Glue = batch-oriented ETL; KDA = real-time SQL/Flink analytics

## Key Concepts

- **DPU (Data Processing Unit)** — unit of compute for Glue; 1 DPU = 4 vCPU + 16GB RAM; billed per second
- **Glue Studio** — visual drag-and-drop ETL builder; generates PySpark code; supports custom transforms
- **pushDownPredicate** — filter applied at the S3 partition level before loading data into Glue job; reduces DPU cost
- **ResolveChoice** — handles ambiguous type conflicts in DynamicFrame (cast, project, make_struct, make_array)
- **ApplyMapping** — rename columns and change types in DynamicFrame
- **Connection** — Glue object storing JDBC/network configuration for databases (RDS, Redshift, on-prem)
- **Development endpoint** — deprecated; use Glue Notebooks (Jupyter-based) instead
- **Glue Data Quality** — rule-based quality checks on datasets; integrates with Glue ETL jobs

## Checklist

- [ ] Job bookmarks enabled for incremental S3/JDBC sources?
- [ ] DynamicFrame used for messy sources; DataFrame for complex transforms?
- [ ] pushDownPredicate applied to filter S3 partitions before loading?
- [ ] Crawler scheduled after data lands (not continuously)?
- [ ] Glue Data Catalog used as shared metastore for Athena and Redshift Spectrum?
- [ ] Worker type chosen appropriately (G.1X for memory-intensive, G.2X for complex shuffles)?
- [ ] ResolveChoice transform applied to handle schema inconsistencies?
- [ ] Sensitive data masked or transformed in Glue job (not stored raw in target)?

## Output Format

- 🔴 **Critical** — no job bookmark on incremental load (full table reprocessed every run)
- 🟡 **Warning** — crawler running continuously (wasteful); DynamicFrame used for complex aggregations (convert to DataFrame)
- 🟢 **Suggestion** — pushDownPredicate not applied (unnecessary data scanned); Glue Studio for visual debugging

## Exam Tips

- **DynamicFrame resolves schema inconsistencies automatically**; DataFrame requires a clean schema — use DynamicFrame for ingestion from heterogeneous sources
- **Job bookmarks = incremental processing** (only new/changed data processed); disable bookmarks for full refresh runs
- **Glue Data Catalog = Hive metastore compatible** — shared by Athena, EMR, and Redshift Spectrum automatically
- **Glue vs EMR**: Glue for serverless simple-to-moderate ETL; EMR for complex Spark/Hadoop jobs needing full cluster control or custom runtimes
- **Glue Streaming = micro-batch** from Kinesis/MSK — NOT true streaming like Kinesis Data Analytics (Flink)
- **pushDownPredicate** = filter at S3 partition level BEFORE loading into Glue job — major cost and performance optimization
- **ResolveChoice** handles type ambiguity (e.g., a field that is sometimes String, sometimes Int) — know the four options: cast, project, make_struct, make_array
- **Glue workflows triggers**: Scheduled / On-demand / Conditional (success/failure/completion of other jobs)
