---
name: cloud-storage
description: Use when designing Cloud Storage buckets, choosing storage classes, setting lifecycle rules, controlling access, or using GCS as a data lake. Covers GCP-PDE domain: Store the data (~15-20%).
---

# Cloud Storage

## When to Use
- Designing data lake or file storage on GCP
- Setting up lifecycle management to control costs
- Configuring access control for sensitive data
- Preparing for GCP Professional Data Engineer exam

## Core Jobs

### 1. Storage Class Selection
| Class | Use case | Min storage | Retrieval cost |
|-------|---------|-------------|----------------|
| **Standard** | Frequently accessed (hot data) | None | None |
| **Nearline** | Accessed < once/month | 30 days | Yes |
| **Coldline** | Accessed < once/quarter | 90 days | Yes (higher) |
| **Archive** | Accessed < once/year | 365 days | Yes (highest) |

### 2. Lifecycle Rules
- `SetStorageClass` — move to cheaper class after N days
- `Delete` — remove objects after N days or after N versions
- Typical pattern: Standard → Nearline (30d) → Coldline (90d) → Archive (365d) → Delete (730d)
- Rules apply at bucket level; objects evaluated daily

### 3. Access Control
- **Uniform bucket-level access** — all access via IAM only (recommended, disables ACLs)
- **Fine-grained** — legacy; allows per-object ACLs (avoid for new buckets)
- Always use **uniform bucket-level access** for new buckets
- **Signed URLs** — temporary access (15 min to 7 days) without GCP credentials
- **Signed Policy Documents** — control what can be uploaded via HTML forms

### 4. Object Versioning
- Enable to protect against accidental deletes/overwrites
- Each overwrite creates a new version; previous becomes noncurrent
- Use lifecycle rule to delete noncurrent versions after N days (control cost)

### 5. Retention Policies
- **Retention policy** — objects cannot be deleted or replaced until retention period expires
- **Object locks** — WORM (write once, read many) compliance
- Use for regulatory compliance, audit logs

### 6. Data Transfer
| Tool | Best for |
|------|---------|
| `gsutil` / gcloud CLI | Ad-hoc transfers, scripting |
| Storage Transfer Service | Large-scale from S3/Azure/HTTP/on-prem |
| Transfer Appliance | Petabyte-scale offline transfer |
| BigQuery Data Transfer Service | SaaS source → BigQuery (not GCS) |

## Key Concepts
- **Requester Pays** — requesters pay for egress and operations (useful for public datasets)
- **CMEK** — Customer-Managed Encryption Keys via Cloud KMS (regulatory requirement)
- **VPC Service Controls** — restrict GCS access to within a VPC perimeter
- **Object change notifications** — Pub/Sub notifications on object create/delete/update

## Checklist
- [ ] Uniform bucket-level access enabled?
- [ ] Lifecycle rules set to transition cold data to cheaper classes?
- [ ] Object versioning enabled for critical buckets?
- [ ] Pub/Sub notifications configured for event-driven pipelines?
- [ ] Signed URLs used for temporary access (not service account keys shared)?
- [ ] CMEK applied if regulatory requirement exists?

## Output Format
- 🔴 **Critical** — fine-grained ACLs on new bucket (security risk), no versioning on critical data
- 🟡 **Warning** — no lifecycle rules (cost accumulates), public bucket without intention
- 🟢 **Suggestion** — nearline/coldline transition for infrequently accessed data

## Exam Tips
- **Signed URLs** = temporary access without GCP account (not service account keys!)
- Nearline/Coldline/Archive have minimum storage durations — deleting early still charges
- `SetStorageClass` lifecycle → use for cost optimization; `Delete` → use for cleanup
- Storage Transfer Service = move data FROM S3/Azure/on-prem TO GCS
- Requester Pays = data owner doesn't pay egress; useful for public scientific datasets
- CMEK ≠ Google-managed encryption; CMEK = customer controls the key lifecycle in Cloud KMS
