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
Use Dataform assertions to catch data quality issues:
- `assert_` prefix files run as data quality checks
- Returns rows that FAIL the assertion (empty result = passing)
- Integrate into CI/CD pipeline before promoting data to production

### 4. Schema Validation Patterns
- Validate schema on ingestion using Dataflow side outputs
- Reject malformed records to a dead-letter GCS bucket or Pub/Sub topic
- Use BigQuery table schema with REQUIRED mode for mandatory fields
- For JSON: validate against JSON Schema before writing

### 5. Data Freshness Monitoring
- Cloud Monitoring custom metrics for pipeline lag
- BigQuery scheduled queries to check MAX(created_at) vs current time
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
