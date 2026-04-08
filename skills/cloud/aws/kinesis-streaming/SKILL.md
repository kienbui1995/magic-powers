---
name: kinesis-streaming
description: Use when designing real-time streaming architectures with Amazon Kinesis, choosing between Kinesis services, managing shards, or comparing Kinesis vs MSK. Covers AWS DEA-C01 and DVA-C02 streaming domains.
---

# Amazon Kinesis Streaming

## When to Use
- Designing real-time data ingestion pipelines on AWS
- Choosing between Kinesis Data Streams, Firehose, Data Analytics, or MSK
- Managing shard capacity and throughput calculations
- Debugging hot shards, consumer lag, or delivery failures
- Implementing event-driven architectures with Lambda and Kinesis
- Preparing for AWS DEA-C01 or DVA-C02 exams (streaming ingestion domain)

## Core Jobs

### 1. Kinesis Service Selection

| Service | Latency | Use Case | Consumer Code | Scaling |
|---------|---------|----------|---------------|---------|
| **Data Streams** | Milliseconds | Custom real-time consumers, replay | Required (KCL, Lambda, SDK) | Manual shard split/merge |
| **Firehose** | 60s–900s buffer | Load to S3/Redshift/OpenSearch/Splunk | Not required (managed) | Automatic |
| **Data Analytics (MSA)** | Seconds | Real-time SQL or Apache Flink analytics | SQL or Flink app | Managed |
| **Video Streams** | Variable | Video ingestion for ML/Rekognition | Kinesis Video SDK | Managed |

**Selection rule**:
- Need custom consumers with millisecond latency → **Data Streams**
- Need to load data to S3/Redshift without writing consumer code → **Firehose**
- Need real-time SQL analytics or Flink → **Data Analytics (MSA)**
- Existing Kafka ecosystem or Kafka-compatible clients → **MSK**

### 2. Shard Capacity (Kinesis Data Streams)

- **1 shard = 1 MB/s ingestion (writes) + 2 MB/s egress (reads)**
- **Write limits**: 1,000 records/second per shard; max 1MB per PUT
- **Read limits**: 5 GetRecords calls/second per shard; 2MB/s total egress
- **Calculate shards needed**: `max(incoming_MB/s / 1, peak_records/s / 1000)` rounded up

Example: 5 MB/s ingestion, 800 records/s → need 5 shards (bounded by throughput not record count)

Operations:
- **Split shard** — increase capacity (add shards)
- **Merge shards** — reduce capacity (remove shards)
- On-Demand mode: auto-scales based on traffic (2x peak in last 30 days); no manual shard management

### 3. Consumer Types

| Consumer | Read Throughput | Latency | Best For |
|----------|-----------------|---------|---------|
| **Standard (GetRecords)** | 2MB/s shared across ALL consumers | ~200ms | Single consumer or low-throughput |
| **Enhanced Fan-Out (EFO)** | 2MB/s DEDICATED per consumer | ~70ms (push-based) | Multiple parallel consumers |

- Enhanced Fan-Out uses SubscribeToShard API (HTTP/2 push); dedicated bandwidth per consumer
- KCL (Kinesis Client Library) v2 automatically uses EFO when configured
- Lambda as consumer: uses EFO by default when added as event source mapping

### 4. Firehose Configuration

- **Buffer size**: 1MB–128MB; trigger delivery when buffer fills
- **Buffer interval**: 60s–900s; trigger delivery when time expires (whichever comes first)
- **Transformations**: Invoke Lambda function to transform records before delivery
- **Data format conversion**: Parquet/ORC conversion (using Glue Data Catalog schema) before S3 delivery
- **Compression**: GZIP, Snappy, ZIP on S3 delivery
- **Error handling**: failed records to separate S3 prefix (not lost)
- **Direct PUT vs Kinesis Data Streams source**: Firehose can ingest directly or consume from a Data Stream

### 5. Kinesis vs MSK (Kafka) Decision

| Factor | Kinesis Data Streams | MSK (Managed Kafka) |
|--------|---------------------|---------------------|
| Management | Fully managed; no broker config | Managed brokers; still configure topics, partitions |
| Ecosystem | AWS-native only | Kafka ecosystem (Kafka Connect, Kafka Streams, MirrorMaker) |
| Retention | Up to 365 days (default 24h) | Configurable per topic (no hard limit) |
| Consumer groups | Shard-based (KCL) | Kafka consumer groups (native) |
| Pricing | Per shard-hour + PUT units | Per broker-hour + storage |
| Migration | None | Easy for existing Kafka workloads |

**Rule**: Default to Kinesis for new AWS-native workloads. Choose MSK when migrating from Kafka or needing Kafka Connect/Kafka Streams.

### 6. Partition Key Strategy

- **Partition key** determines which shard a record goes to (MD5 hash of key → shard range)
- High cardinality keys (user_id, session_id) = even distribution
- Low cardinality (region, status) = hot shards
- **Hot shard fix**: Add random suffix to partition key (`user_id + random(0,N)`) for write sharding
- Ordering: all records with the same partition key go to the same shard → ordered within that shard

## Key Concepts

- **Shard** — unit of throughput in Kinesis Data Streams (1MB/s in, 2MB/s out)
- **Partition key** — string that determines shard assignment via MD5 hash
- **Sequence number** — unique identifier for each record within a shard; monotonically increasing
- **Iterator** — cursor position for reading from a shard (TRIM_HORIZON, LATEST, AT_SEQUENCE_NUMBER, AFTER_SEQUENCE_NUMBER, AT_TIMESTAMP)
- **KCL (Kinesis Client Library)** — high-level consumer library; handles shard leases, checkpointing, and EFO
- **Checkpointing** — KCL records last processed sequence number in DynamoDB table (one row per shard)
- **Enhanced Fan-Out** — dedicated 2MB/s push-based delivery per registered consumer
- **PutRecord vs PutRecords** — single record vs batch (up to 500 records or 5MB); PutRecords is more efficient

## Checklist

- [ ] Shard count calculated for peak throughput (ingestion rate and record rate)?
- [ ] Enhanced Fan-Out configured when multiple consumers need full 2MB/s throughput?
- [ ] Partition key has high cardinality to avoid hot shards?
- [ ] On-Demand mode considered for unpredictable traffic patterns?
- [ ] Firehose buffer interval and size tuned for acceptable latency?
- [ ] Lambda + Kinesis: batch window and batch size configured; bisect-on-error enabled?
- [ ] Retention period set appropriately for replay requirements (default 24h may not be enough)?
- [ ] KCL checkpointing DynamoDB table provisioned or on-demand capacity?

## Output Format

- 🔴 **Critical** — hot shard detected (one partition key receiving all writes); throughput exceeded (ProvisionedThroughputExceededException)
- 🟡 **Warning** — Standard consumer with multiple downstream consumers (EFO not used); retention at 24h default with replay requirement
- 🟢 **Suggestion** — On-Demand mode for variable workload; Firehose format conversion (Parquet) for cost savings on S3

## Exam Tips

- **Firehose = no consumer code needed**; Data Streams = must write consumer code (KCL, Lambda, or SDK)
- **Enhanced Fan-Out = dedicated 2MB/s per consumer** — use when multiple consumers each need full throughput
- **Hot shard** = many partition keys mapping to same shard → fix by using high-cardinality keys or random suffix
- **Retention**: Data Streams default 24h (up to 365 days, paid); Firehose buffers temporarily then delivers (not stored long-term)
- **Kinesis + Lambda**: SQS event source = at-least-once; Kinesis event source = ordered, retry on failure until expiry or max attempts
- **Ordering guaranteed within a shard** — use the same partition key for all records that must be ordered relative to each other
- **On-Demand vs Provisioned**: On-Demand auto-scales but costs ~2x more than right-sized provisioned shards
- **IteratorType TRIM_HORIZON** = read from oldest available record; LATEST = only new records after consumer starts
