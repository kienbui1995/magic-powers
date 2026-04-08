---
name: lake-formation-governance
description: Use when implementing fine-grained access control for S3 data lakes, setting up column-level or row-level security, sharing data across accounts, or governing the Glue Data Catalog with Lake Formation. Covers AWS DEA-C01 data governance domain.
---

# AWS Lake Formation Governance

## When to Use
- Implementing fine-grained access control (table, column, row-level) for a data lake
- Replacing coarse-grained S3 bucket policies with Lake Formation permissions
- Sharing Glue Data Catalog resources across AWS accounts
- Setting up data lake blueprints for automated ingestion
- Governing who can access what data in Athena, Redshift Spectrum, or Glue jobs
- Preparing for AWS Certified Data Engineer Associate (DEA-C01) exam

## Core Jobs

### 1. Lake Formation vs S3 Bucket Policies

| Capability | Lake Formation | S3 Bucket Policies |
|-----------|---------------|-------------------|
| Granularity | Table, column, row | Bucket, prefix, object |
| Column-level security | Yes (grant specific columns) | No |
| Row-level filtering | Yes (filter expressions) | No |
| Data Catalog integration | Native (Glue Data Catalog) | Not applicable |
| Cross-account sharing | Via RAM (no data copying) | Bucket policy trust + IAM |
| Tag-based access | LF-Tags (attribute-based) | S3 object tags (limited) |

**Rule**: Use S3 bucket policies for coarse access control (which buckets/prefixes are accessible). Use Lake Formation for fine-grained control over which tables, columns, and rows a principal can see.

**Both are required**: Lake Formation is an additional governance layer OVER IAM and S3. A principal needs both IAM permissions AND Lake Formation permissions to access data.

### 2. Permissions Model

**Permission hierarchy**:
```
Database → Tables → Columns → Row filters
```

**Lake Formation permission types**:
- `CREATE_DATABASE`, `CREATE_TABLE` — DDL operations
- `SELECT`, `INSERT`, `DELETE`, `DROP`, `ALTER` — DML operations
- `DESCRIBE` — view metadata only (no data access)
- `SUPER` — all permissions (admin)

**Grantable permissions**: principals with `GRANT OPTION` can grant their permissions to others (delegation).

**Permission inheritance**: granting on a database with `GrantOption` propagates to future tables created in that database.

### 3. Column-Level Security

- Grant access to specific columns only in a table
- Excluded columns are invisible to the grantee (not returned in query results)
- Example: grant analyst access to `customer_orders` table but EXCLUDE `ssn`, `credit_card` columns
- Configured via Lake Formation console or API: specify included or excluded columns per grant

```
Grant SELECT on table customer_orders
  to role analyst_role
  Columns: [order_id, order_date, amount, status]  -- exclude PII
```

### 4. Row-Level Security (Data Filters)

- **Data filters** = filter expressions applied to table rows at query time
- Define filter once, apply to multiple grants
- Filter expression example: `region = 'us-east-1' AND status = 'active'`
- Use cases:
  - Multi-tenant data lake (each team sees only their tenant's data)
  - Regional data access (EU team sees only EU records)
  - Sensitivity-based filtering (analysts see non-PII rows only)

**Create data filter**:
```
Filter name: us_only_orders
Table: orders
Row filter expression: region = 'US'
Column exclusions: [customer_ssn, payment_info]
```

Apply by granting this filter to specific IAM roles or Lake Formation principals.

### 5. Cross-Account Data Sharing

- Share Glue Data Catalog databases and tables with other AWS accounts via **AWS RAM (Resource Access Manager)**
- Recipient account: accepts RAM share → sees shared database in their Data Catalog
- No data is copied — recipient queries data in the originating account's S3 (via Glue/Athena/Redshift Spectrum)
- Lake Formation permissions still apply (originator controls what the recipient can see)
- Cross-region sharing: share across regions (same or different accounts)

**Steps**:
1. Register S3 data lake location in Lake Formation (originator account)
2. Grant Lake Formation permissions to target account principal
3. Create RAM resource share with Catalog databases/tables
4. Target account accepts RAM share and creates Lake Formation permissions for their principals

### 6. Blueprints and Automated Ingestion

- **Lake Formation blueprints** — pre-built templates to automate data ingestion to the data lake
- Available blueprints: Database snapshot, Incremental database, CloudTrail logs, CloudFront logs
- Creates Glue workflows automatically (crawlers + jobs) from blueprint configuration
- Target: S3 location registered with Lake Formation (governance applied automatically)
- Schedule: one-time or periodic (cron-based)

### 7. Governed Tables (ACID)

- **Governed Tables** = Lake Formation native table format with ACID transaction support
- Supports concurrent reads/writes with consistent snapshots
- **Automatic compaction**: Lake Formation compacts small files in background (S3 optimization)
- **Row-level transactions**: INSERT, DELETE with full ACID guarantees
- Enable via Lake Formation console when creating table; stored in S3 with transaction log

## Key Concepts

- **Data lake administrator** — IAM user/role with Lake Formation admin privileges; can grant/revoke all permissions
- **LF-Tags (Lake Formation tags)** — attribute-based access control (ABAC); tag resources and grant access by tag values; scales better than explicit grants for large catalogs
- **Registered S3 location** — S3 path registered with Lake Formation; Lake Formation manages access (IAM passthrough disabled); unregistered paths use IAM only
- **IAM passthrough mode** — for Athena queries on non-registered S3 locations; Lake Formation not involved
- **Governed Tables** — ACID transactional tables in Lake Formation (vs standard Glue catalog tables)
- **Data Catalog encryption** — encrypt Glue Data Catalog metadata at rest using KMS
- **CloudTrail integration** — all Lake Formation API calls logged; audit who accessed what data

## Checklist

- [ ] S3 data lake locations registered with Lake Formation (enables fine-grained control)?
- [ ] IAM passthrough disabled for registered locations (Lake Formation fully manages access)?
- [ ] Column-level grants configured to exclude PII/sensitive columns from non-privileged roles?
- [ ] Row-level data filters defined for multi-tenant or regional access requirements?
- [ ] LF-Tags used for large catalogs (scales better than explicit grants)?
- [ ] Cross-account sharing via RAM (not data copying)?
- [ ] Data lake administrator role limited to specific IAM principals?
- [ ] CloudTrail logging enabled for Lake Formation API calls (audit)?

## Output Format

- 🔴 **Critical** — Lake Formation registered locations with IAM passthrough still enabled (defeats Lake Formation governance); no column exclusions on tables with PII fields
- 🟡 **Warning** — explicit grants used at scale without LF-Tags (hard to manage); cross-account sharing done by copying data (inefficient) instead of RAM share
- 🟢 **Suggestion** — Governed Tables for concurrent ETL workloads; blueprints for automated ingestion from RDS/on-prem databases; LF-Tags for scalable ABAC

## Exam Tips

- **Lake Formation = governance layer OVER Glue Data Catalog and S3**; it does NOT move or copy data
- **Column-level security** = grant access to SPECIFIC columns; row-level = grant rows matching filter expression; both configurable per principal
- **Lake Formation permissions + IAM BOTH required** — Lake Formation is an ADDITIONAL layer; having IAM S3 access is not enough if location is registered
- **Registered S3 locations** = Lake Formation manages access control; unregistered locations = IAM and S3 bucket policies only
- **Cross-account sharing via RAM** = share Catalog resources (databases, tables) without copying data; recipient queries data in source account's S3
- **Governed Tables** = ACID transactions and automatic compaction in Lake Formation (similar to Delta Lake/Iceberg transactional tables)
- **LF-Tags (ABAC)** = scalable permissions for large catalogs; tag-based grants auto-apply to new resources with matching tags
- **Data lake administrators** can see all Data Catalog resources by default; limit this role to minimum necessary principals
