---
name: fabric-lakehouse
description: Use when designing Microsoft Fabric Lakehouse architecture, working with Delta tables, OneLake storage, Spark notebooks, or studying for DP-700 (Microsoft Fabric Data Engineer Associate). Covers Fabric architecture, Delta Lake, OneLake shortcuts, and medallion patterns.
---

# Fabric Lakehouse

## When to Use
- Designing a Lakehouse in Microsoft Fabric for analytics workloads
- Working with Delta tables, time travel, or schema enforcement
- Planning OneLake shortcuts to external data sources (ADLS Gen2, S3, GCS)
- Deciding between Lakehouse and Warehouse for a use case
- Preparing for Microsoft Fabric Data Engineer Associate (DP-700) exam

## Core Jobs

### 1. Fabric Architecture Overview
- **Lakehouse** = OneLake storage + Delta table format + SQL analytics endpoint + Spark runtime
- All Fabric items (Lakehouse, Warehouse, Eventhouse, Semantic Model) share **OneLake** as single storage
- OneLake = Azure Data Lake Storage Gen2 compatible; one logical lake per Fabric tenant
- Lakehouse exposes two interfaces: **Spark** (read/write Delta) and **SQL analytics endpoint** (read-only T-SQL)

### 2. Lakehouse vs Warehouse Decision
| Capability | Lakehouse | Warehouse |
|------------|-----------|-----------|
| Storage format | Delta (Parquet + transaction log) | Proprietary columnar |
| Query interface | SQL analytics endpoint (read-only) + Spark | Dedicated SQL (read/write T-SQL) |
| Write via SQL | No (Spark or Dataflow only) | Yes (INSERT, UPDATE, DELETE) |
| Spark support | Yes (PySpark, Scala, R) | No |
| Best for | Data engineering, ML prep, exploration | BI reporting, T-SQL-heavy analytics |

Decision rule: Choose **Lakehouse** when you need Spark + open Delta format; choose **Warehouse** when your team is SQL-first and needs T-SQL DML.

### 3. Delta Lake Format and ACID Transactions
- All Lakehouse managed tables are **Delta format** (Parquet files + `_delta_log/`)
- ACID transactions: atomic commits prevent partial writes; concurrent reads/writes safe
- **Time travel**: query historical snapshots using:
  - `SELECT * FROM table VERSION AS OF 10` — by version number
  - `SELECT * FROM table TIMESTAMP AS OF '2024-01-15'` — by timestamp
- Schema enforcement: Delta rejects writes that don't match the declared schema
- Schema evolution: `mergeSchema` option allows adding new columns

### 4. OneLake Shortcuts
- **Shortcuts** = logical pointers to external data; no data copy into OneLake
- Supported sources: ADLS Gen2, Amazon S3, GCS, OneLake (cross-workspace)
- Data stays at the source; access latency depends on source location and network
- Shortcuts appear as folders in Lakehouse; queryable via SQL analytics endpoint and Spark
- Use shortcuts when data must remain in source system for compliance or ownership reasons

### 5. Spark Notebooks in Lakehouse
- Default language: PySpark (also supports Scala, R, Spark SQL)
- Read Delta table: `spark.read.format("delta").load("abfss://...")`
- Write Delta table: `df.write.format("delta").mode("overwrite").save("Tables/mytable")`
- Shortcut: `spark.read.load("Files/shortcut-folder/")` — treats shortcuts as local paths
- ML feature prep: use Spark for large-scale feature engineering before model training

### 6. Medallion Architecture in Fabric
| Layer | Lakehouse | Content |
|-------|-----------|---------|
| **Bronze** | Raw Lakehouse | Ingested as-is; no transformations; full fidelity |
| **Silver** | Cleaned Lakehouse | Validated, deduplicated, typed data |
| **Gold** | Curated Lakehouse | Aggregated, business-ready for BI and reporting |

- Each layer can be a separate Lakehouse or schema within one Lakehouse
- Silver and Gold tables exposed via SQL analytics endpoint to Power BI (Direct Lake mode)

## Key Concepts
- **OneLake** — single logical Azure Data Lake per Fabric tenant; all items read/write here
- **Delta Lake** — open-source storage layer; ACID, time travel, schema enforcement on Parquet
- **SQL analytics endpoint** — auto-generated, read-only SQL interface over Lakehouse Delta tables
- **Direct Lake mode** — Power BI reads Delta tables directly from OneLake (no import, no DirectQuery overhead)
- **Shortcut** — virtual link to external storage; zero data copy; Fabric-native access
- **Managed table** — Delta table in `Tables/` section; registered in Lakehouse metastore
- **Unmanaged file** — raw file in `Files/` section; not a Delta table; no SQL access

## Checklist
- [ ] Lakehouse chosen over Warehouse when Spark or open Delta format is required?
- [ ] Medallion architecture (Bronze/Silver/Gold) layers defined for data quality progression?
- [ ] Delta tables in `Tables/` section (not `Files/`) for SQL analytics endpoint access?
- [ ] OneLake shortcuts used for external data instead of copying data in?
- [ ] Time travel retention configured (default 7 days; extend for audit requirements)?
- [ ] SQL analytics endpoint connected to Power BI using Direct Lake mode?
- [ ] Schema enforcement enabled; mergeSchema only when intentional evolution needed?

## Output Format
- 🔴 **Critical** — writing data to `Files/` section expecting SQL access (Files are not Delta tables)
- 🔴 **Critical** — using Lakehouse SQL analytics endpoint for write operations (it is read-only)
- 🟡 **Warning** — copying data into OneLake when a shortcut could avoid duplication
- 🟡 **Warning** — no medallion layering; raw data directly served to Power BI
- 🟢 **Suggestion** — enable Direct Lake mode on Gold layer semantic model for best BI performance

## Exam Tips
- **Lakehouse SQL analytics endpoint = auto-generated, read-only** — cannot INSERT/UPDATE via SQL endpoint; writes must go through Spark, Dataflow Gen2, or Pipelines
- **Shortcuts = no data copy** — data stays at source; latency depends on source; no egress costs within same region
- **Delta time travel** — `VERSION AS OF` for version number, `TIMESTAMP AS OF` for date; default 7-day retention
- **Lakehouse tables vs Files** — `Tables/` = Delta format, SQL-queryable; `Files/` = raw files, Spark-only
- **OneLake = one copy shared across Fabric** — Lakehouse, Warehouse, and Semantic Model all reference the same OneLake storage; no duplication
- **Medallion architecture in Fabric** — Bronze → Silver → Gold; each layer a separate Lakehouse or schema; Gold exposed to Power BI via Direct Lake
