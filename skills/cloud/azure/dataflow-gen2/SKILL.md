---
name: dataflow-gen2
description: Use when building no-code/low-code data transformations in Microsoft Fabric with Dataflow Gen2, configuring Power Query transformations, setting up incremental refresh, or studying for DP-700 (Microsoft Fabric Data Engineer Associate).
---

# Dataflow Gen2

## When to Use
- Building data transformations without writing PySpark code in Microsoft Fabric
- Connecting to 150+ data sources using Power Query's no-code interface
- Setting up incremental refresh to load only new or changed data
- Loading transformed data to Lakehouse tables, Warehouse, or Azure SQL
- Deciding between Dataflow Gen2 and Spark Notebooks for a transformation task
- Preparing for Microsoft Fabric Data Engineer Associate (DP-700) exam

## Core Jobs

### 1. Dataflow Gen2 Architecture
- **Dataflow Gen2** = Power Query Online interface with staging layer in Microsoft Fabric
- 150+ data source connectors: files (CSV, Excel, JSON, Parquet), databases (SQL Server, Snowflake, Oracle), cloud services (SharePoint, Salesforce, REST APIs)
- Transformation engine: M language (Power Query formula language); visually authored
- Staging layer: intermediate OneLake storage during transformation (reduces source load)
- Final output written to configured **data destinations**

### 2. Staging Layer
- Staging = temporary OneLake storage where intermediate results land during transformations
- Automatically enabled by default; can be disabled per query
- Benefits: reduces repeated calls to source systems; enables parallel transformation steps
- Staging storage: always OneLake (cannot change to external storage)
- Important: staging is temporary; only the final data destination persists

### 3. Data Destinations
| Destination | Use Case |
|-------------|----------|
| **Fabric Lakehouse** (table) | Most common; Delta table in Lakehouse `Tables/` |
| **Fabric Warehouse** (table) | SQL-first teams; T-SQL accessible |
| **Azure SQL Database** | Hybrid scenarios; push to existing SQL workloads |
| **Fabric KQL Database** | Real-time analytics (Eventhouse) |

- One Dataflow Gen2 can have **multiple data destinations** (one per query)
- Destination mode: **Append** (add rows), **Replace** (overwrite), **Merge** (upsert on key)

### 4. Incremental Refresh
- Only loads new or changed data since the last refresh (avoids full re-scan)
- Requirements:
  1. Source must have a reliable datetime column (e.g., `ModifiedDate`, `EventTimestamp`)
  2. Define **RangeStart** and **RangeEnd** parameters (datetime type) in Power Query
  3. Filter source query by: `Table.SelectRows(Source, each [ModifiedDate] >= RangeStart and [ModifiedDate] < RangeEnd)`
- Fabric manages the date window automatically on each refresh cycle
- Not supported for all connectors (check source compatibility)

### 5. Dataflow Gen2 vs Notebooks Decision
| Criteria | Dataflow Gen2 | Spark Notebook |
|----------|---------------|----------------|
| User skill | Business analyst, no-code | Data engineer, PySpark |
| Transformation complexity | Low-medium (Power Query M) | High (arbitrary Python/Spark) |
| Scale | Medium datasets | Very large datasets (TB+) |
| Scheduling | Built-in refresh schedule | Manual or Pipeline trigger |
| ML/AI logic | Not supported | Full Python ecosystem |
| Best for | ETL from business systems | Large-scale data engineering |

Decision rule: Choose **Dataflow Gen2** for straightforward ETL from standard connectors; use **Notebooks** for complex transformations, ML, or very large data volumes.

### 6. Scheduling and Pipeline Integration
- Standalone schedule: configure refresh frequency (hourly, daily, weekly) in Fabric workspace
- **Fabric Pipeline integration**: add Dataflow Gen2 as a **Dataflow activity** in Pipeline
- Pipeline enables: sequential execution with other activities (Copy Data, Notebook), conditional logic, parameterization
- Dataflow activity in Pipeline can pass parameters to override connector settings

## Key Concepts
- **Power Query** — visual data transformation engine; M language under the hood
- **Staging** — intermediate OneLake storage during transformation; reduces source load
- **Data destination** — final output target (Lakehouse table, Warehouse, SQL); persists after refresh
- **RangeStart / RangeEnd** — required datetime parameters for incremental refresh
- **Dataflow Gen1** — Power BI-only Dataflow; no staging, fewer destinations; legacy, do not confuse with Gen2
- **M language** — Power Query formula language; functional, lazy-evaluated; authored visually

## Checklist
- [ ] Dataflow Gen2 (not Gen1) selected when working in Microsoft Fabric?
- [ ] Staging enabled (default) to reduce repeated calls to source systems?
- [ ] Data destination configured for each output query (Lakehouse table, etc.)?
- [ ] Incremental refresh set up with RangeStart/RangeEnd parameters for large sources?
- [ ] Source connector supports the required authentication method (OAuth, key, managed identity)?
- [ ] Dataflow Gen2 activity added to Fabric Pipeline when orchestration is needed?
- [ ] Notebook used instead when transformation requires PySpark or Python libraries?

## Output Format
- 🔴 **Critical** — using Dataflow Gen1 (Power BI Dataflows) expecting Fabric destinations
- 🔴 **Critical** — incremental refresh missing RangeStart/RangeEnd parameters (full refresh will run)
- 🟡 **Warning** — Dataflow Gen2 used for TB-scale data where Spark Notebook would perform better
- 🟡 **Warning** — no staging configured; source system queried multiple times per refresh
- 🟢 **Suggestion** — embed Dataflow Gen2 in Fabric Pipeline for orchestrated, conditional execution

## Exam Tips
- **Dataflow Gen2 ≠ Dataflow Gen1** — Gen2 has staging layer, more destinations (Lakehouse, Warehouse), and is Fabric-native; Gen1 is Power BI-only with fewer capabilities
- **Staging must be OneLake** — cannot configure external storage for staging; reduces load on source during transformation
- **Incremental refresh requires RangeStart and RangeEnd parameters** — must be datetime type; Power Query filters source by this range automatically on each run
- **Dataflow Gen2 supports multiple data destinations** — one per query in the same Dataflow; each can go to a different Lakehouse or table
- **For complex PySpark transformations, use Notebooks** — Dataflow Gen2 is Power Query (M), not Python/Spark
- **Dataflow Gen2 as activity in Fabric Pipelines** — enables orchestration with Copy Data, Notebook, and other pipeline activities; trigger on schedule or event
