---
name: data-quality
description: Use when validating data pipelines, writing data tests, or investigating data anomalies
---

# Data Quality

## When to Use
When ensuring that data flowing through pipelines is accurate, complete, timely, and consistent.

## Core Jobs

### 1. Define Quality Dimensions
- **Completeness**: No unexpected nulls. Key fields populated.
- **Accuracy**: Values match source of truth.
- **Consistency**: Same entity has same value across tables.
- **Timeliness**: Data arrives within SLA window.
- **Uniqueness**: No duplicate records where uniqueness is expected.

### 2. Write Data Tests
Using dbt tests or Great Expectations:
```yaml
# dbt example
models:
  - name: orders
    columns:
      - name: order_id
        tests: [unique, not_null]
      - name: status
        tests:
          - accepted_values:
              values: [pending, shipped, delivered, cancelled]
      - name: amount
        tests:
          - dbt_utils.expression_is_true:
              expression: ">= 0"
```

### 3. Set Up Monitoring
- Row count anomaly detection (±20% from 7-day avg = alert)
- Null rate monitoring per column
- Schema change detection
- Freshness checks (last updated > N hours = alert)

### 4. Investigate Anomalies
When a quality check fails:
1. Is it a pipeline failure or a source data issue?
2. What's the blast radius (which downstream consumers affected)?
3. Quarantine bad data before it propagates
4. Fix + backfill + verify

## Key Outputs
- Data quality test suite
- Quality monitoring dashboard
- Anomaly investigation runbook
- SLA definitions per dataset

## Anti-Patterns
- Testing in dev only, not prod
- Alerts with no owner (alert fatigue)
- Fixing data in place without understanding root cause
- No freshness checks — stale data silently used as current
