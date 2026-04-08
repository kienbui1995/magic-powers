---
name: eventstreams
description: Use when building real-time streaming pipelines in Microsoft Fabric with Eventstreams, connecting Event Hubs or IoT Hub sources, processing streams with windowed aggregations, or routing to Eventhouse/Lakehouse destinations. Covers DP-700 real-time intelligence domain.
---

# Eventstreams

## When to Use
- Ingesting real-time event data into Microsoft Fabric from Event Hubs, IoT Hub, or Kafka
- Building streaming pipelines with in-flight transformations (filter, aggregate, window)
- Routing streaming data to Eventhouse (KQL database) for real-time analytics
- Routing streaming data to Lakehouse for near-real-time Delta streaming
- Deciding between Eventstreams and Event Hubs for a streaming use case
- Preparing for Microsoft Fabric Data Engineer Associate (DP-700) exam

## Core Jobs

### 1. Eventstream Architecture
- **Eventstream** = Fabric-native no-code streaming service; visual canvas authoring
- Data flow: Source → (optional Transformations) → Destinations
- Eventstream runs continuously; no separate job to start/stop
- Fully managed; no Spark Structured Streaming setup required

### 2. Event Sources
| Source | Description |
|--------|-------------|
| **Azure Event Hubs** | Most common; connect existing event hub namespace |
| **Azure IoT Hub** | Device telemetry from IoT scenarios |
| **Apache Kafka** | Kafka-compatible endpoint; use consumer group |
| **Sample data** | Built-in sample streams (e.g., Bicycles, Taxis) for testing |
| **Custom App** | Use Fabric SDK or Event Hubs SDK to publish events |
| **Azure SQL DB (CDC)** | Change data capture stream from SQL Server |
| **PostgreSQL (CDC)** | Change data capture stream from PostgreSQL |

- Custom App source: connect using Event Hubs-compatible endpoint and SAS key or Managed Identity

### 3. Stream Destinations
| Destination | Latency | Best for |
|-------------|---------|---------|
| **Eventhouse (KQL Database)** | Milliseconds | Real-time dashboards, KQL queries, alerts |
| **Lakehouse (Delta table)** | Seconds to minutes | Near-real-time; Delta streaming into medallion |
| **Reflex** | Near real-time | Event-driven alerts and automated actions |
| **Derived stream** | — | Fan-out to multiple downstream transformations |

- **Eventhouse path**: lowest latency; query with KQL; best for operational dashboards
- **Lakehouse path**: higher latency (Delta micro-batch); best for analytical workloads that also need Spark

### 4. Stream Transformations
Transformations applied in-flight before data reaches destination:
| Transformation | Description |
|----------------|-------------|
| **Filter** | Include/exclude events based on field conditions |
| **Manage fields** | Add, remove, rename, or change types of fields |
| **Aggregate** | Sum, Count, Min, Max, Avg over time window |
| **Group by** | Group aggregations by field values |
| **Union** | Merge multiple streams into one |
| **Expand** | Flatten nested JSON arrays |

- **Time windows for aggregation**:
  - **Tumbling** — fixed, non-overlapping (e.g., 1-minute buckets)
  - **Sliding** — overlapping windows (e.g., last 5 minutes, updated every 1 minute)
  - **Session** — dynamic window based on activity gaps

### 5. Eventhouse (KQL) Basics
- **Eventhouse** = KQL database optimized for real-time, time-series data in Fabric
- Auto-ingest from Eventstream: data lands in KQL table continuously
- Query with KQL (Kusto Query Language):
  ```kql
  // Count events per minute
  Events
  | where Timestamp > ago(1h)
  | summarize count() by bin(Timestamp, 1m)
  | render timechart

  // Filter and project
  Events
  | where EventType == "click"
  | project UserId, Timestamp, Page
  ```
- KQL tables also queryable with T-SQL (limited subset)
- Real-time dashboards in Fabric connect directly to Eventhouse

### 6. Eventstreams vs Event Hubs
| Aspect | Eventstreams | Azure Event Hubs |
|--------|-------------|-----------------|
| Scope | Fabric-native streaming pipeline | Standalone messaging service |
| Transformation | Built-in (no-code) | Requires Stream Analytics or Spark |
| Destinations | Fabric-native (Lakehouse, Eventhouse) | Any Azure service |
| Best for | Fabric-first analytics | Cross-service event distribution |

- Use Eventstreams when your destination is Fabric (Lakehouse or Eventhouse)
- Use Event Hubs directly when distributing events to multiple non-Fabric consumers

## Key Concepts
- **Eventhouse** — KQL database in Fabric; optimized for real-time time-series; auto-ingest from Eventstreams
- **KQL (Kusto Query Language)** — query language for Eventhouse; `| where`, `| summarize`, `| project`, `| render`
- **Tumbling window** — fixed non-overlapping time intervals for aggregation
- **CDC (Change Data Capture)** — stream database row changes (INSERT/UPDATE/DELETE) as events
- **Derived stream** — create multiple downstream branches from one source stream
- **Custom App source** — use Event Hubs-compatible SDK to push events to Eventstream

## Checklist
- [ ] Eventhouse (KQL) chosen for millisecond-latency real-time queries?
- [ ] Lakehouse chosen when near-real-time is acceptable and Spark access needed later?
- [ ] In-flight transformations (filter, aggregate) configured before destination to reduce write volume?
- [ ] Time window type (tumbling/sliding/session) chosen based on aggregation requirement?
- [ ] Consumer group configured for Event Hubs/Kafka source (avoid sharing with other consumers)?
- [ ] Sample data source used for testing before connecting production Event Hub?
- [ ] Reflex configured for event-driven alerts on anomalous streaming data?

## Output Format
- 🔴 **Critical** — routing high-frequency events directly to Lakehouse without aggregation (may cause write bottleneck)
- 🟡 **Warning** — using Lakehouse destination when millisecond latency is required (use Eventhouse instead)
- 🟡 **Warning** — no consumer group specified for Kafka/Event Hubs source (may conflict with other consumers)
- 🟢 **Suggestion** — add filter transformation to reduce event volume before Eventhouse ingestion

## Exam Tips
- **Eventhouse = KQL database** — queryable with KQL (Kusto Query Language); also supports limited T-SQL
- **Eventstream → Eventhouse = real-time analytics path** — lowest latency (milliseconds); best for operational dashboards
- **Eventstream → Lakehouse = near-real-time** — Delta streaming; slightly higher latency; use when Spark access needed
- **KQL `summarize count() by bin(Timestamp, 1m)`** — standard pattern for 1-minute aggregation on time-series data
- **Custom App source = Event Hubs-compatible endpoint** — use Fabric SDK or Event Hubs SDK; send events using SAS or Managed Identity
- **Eventstream transformations happen in-flight** — no separate Spark Structured Streaming job needed; transformations run inside Eventstream before data hits destination
