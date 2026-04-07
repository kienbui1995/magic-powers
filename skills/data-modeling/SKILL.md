---
name: data-modeling
description: Use when designing analytics schemas, choosing between star schema and OBT, or modeling entities for a data warehouse
---

# Data Modeling

## When to Use
When designing schemas for analytics workloads — data warehouses, marts, or reporting layers.

## Core Jobs

### 1. Choose the Modeling Approach
**Star Schema** (Kimball):
- Fact tables (events/transactions) + dimension tables (entities)
- Best for: complex reporting, many joins, well-understood domains
- Tools: Snowflake, BigQuery, Redshift

**One Big Table (OBT)**:
- Pre-joined wide table with all dimensions
- Best for: simple BI tools, small teams, fast queries
- Trade-off: storage cost, harder to maintain

**Data Vault**:
- Hubs, Links, Satellites — for auditability and historical tracking
- Best for: regulated industries, complex source systems

### 2. Design Fact Tables
- Grain: what does one row represent? (one order, one page view, one transaction)
- Measures: numeric facts (amount, duration, count)
- Foreign keys: links to dimension tables
- Date key: always include, enables time-series analysis

### 3. Design Dimension Tables
- Slowly Changing Dimensions (SCD): how do you handle changes?
  - Type 1: overwrite (no history)
  - Type 2: new row per change (full history)
  - Type 3: add column (limited history)
- Surrogate keys: integer PKs, not natural keys

### 4. Layer the Models
```
Raw (source copy) → Staging (cleaned) → Intermediate → Marts (business logic)
```
Don't put business logic in raw or staging layers.

## Key Outputs
- ERD / schema diagram
- Fact and dimension table definitions
- SCD strategy per entity
- dbt model layer structure

## Anti-Patterns
- Business logic in the BI tool
- No grain definition on fact tables
- Using natural keys as join keys (breaks on source changes)
- Modeling for current queries only — schema should support future questions
