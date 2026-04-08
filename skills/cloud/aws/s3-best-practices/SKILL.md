---
name: s3-best-practices
description: Use when designing S3 data lakes, selecting storage classes, configuring lifecycle policies, implementing access control and encryption, or optimizing S3 performance. Covers AWS DEA-C01 and SAP-C02 storage domains.
---

# Amazon S3 Best Practices

## When to Use
- Designing an S3 data lake or object storage architecture
- Choosing the right storage class based on access patterns and cost
- Configuring lifecycle policies for automated storage class transitions
- Implementing encryption, access control, and data protection
- Optimizing S3 performance for high-throughput workloads
- Preparing for AWS DEA-C01, DVA-C02, or SAP-C02 exams

## Core Jobs

### 1. Storage Class Selection

| Storage Class | Use Case | Min Duration | Retrieval | Monthly Cost |
|--------------|----------|-------------|-----------|-------------|
| **Standard** | Frequently accessed data | None | Instant | Highest |
| **Intelligent-Tiering** | Unknown or changing access patterns | None | Instant (frequent/infrequent tier) | Monitoring fee + tier pricing |
| **Standard-IA** | Infrequent access, rapid retrieval needed | 30 days | Instant | Lower + retrieval fee |
| **One Zone-IA** | Infrequent, non-critical, single AZ | 30 days | Instant | Lower than Standard-IA |
| **Glacier Instant Retrieval** | Archive, quarterly access | 90 days | Milliseconds | Very low |
| **Glacier Flexible Retrieval** | Archive, rare access, hours acceptable | 90 days | Minutes–hours | Lower |
| **Glacier Deep Archive** | Long-term archive, yearly access | 180 days | 12–48 hours | Lowest |

**Decision flow**:
1. Access frequency unknown → **Intelligent-Tiering** (automated transitions)
2. Access < monthly, retrieval < seconds needed → **Glacier Instant Retrieval**
3. Access < quarterly, hours OK → **Glacier Flexible Retrieval**
4. Compliance archive, yearly, cheapest → **Glacier Deep Archive**
5. Single-AZ OK (can regenerate data) → **One Zone-IA** for cost savings

### 2. Lifecycle Policies

- Automate transitions between storage classes and object expiration
- Transition rules: based on object age (days since creation or last access)
- Expiration rules: delete objects or delete old versions after N days

Common pattern for data lake:
```
Day 0 → Standard (hot data)
Day 30 → Standard-IA (warm archive)
Day 90 → Glacier Instant Retrieval (cold archive)
Day 365 → Glacier Deep Archive (long-term)
Day 2555 → Expire (delete)
```

- Apply by prefix (folder path) or object tag
- Minimum 30-day residency in Standard-IA/One Zone-IA before transitioning
- Lifecycle applies to current versions AND previous versions (versioned bucket)

### 3. Access Control

| Mechanism | Scope | Recommended Use |
|-----------|-------|----------------|
| **Bucket policies** | Bucket/prefix level; JSON | Primary access control for cross-account and public access |
| **IAM policies** | Attached to users/roles | Same-account access control |
| **ACLs** | Object or bucket level | Legacy; avoid for new workloads |
| **Access Points** | Named endpoints with own policies | Large shared datasets with different access patterns |

**Best practice**:
- Enable **Block Public Access** at account level (prevents accidental public exposure)
- Use bucket policies + IAM roles; avoid ACLs
- Use **S3 Access Points** for large data lakes with multiple teams/applications
- **Cross-account access**: bucket policy trusting the other account's IAM principal

### 4. Encryption Options

| Method | Key Management | Use Case |
|--------|----------------|---------|
| **SSE-S3** | AWS manages everything; S3-native key | Default, no compliance requirements |
| **SSE-KMS** | Customer managed key in KMS; CloudTrail audit trail | Compliance, need key rotation control |
| **SSE-C** | Customer provides key with each request | Customer retains full key control (rare) |
| **CSE (Client-Side)** | Encrypt before uploading to S3 | Maximum control; encrypt before leaving app |
| **DSSE-KMS** | Dual-layer SSE with KMS | Very high compliance requirements (ITAR, etc.) |

**SSE-KMS details**:
- Each S3 PUT/GET calls KMS API → higher latency + KMS request costs
- KMS key rotation: automatic (annual) or manual; old data re-encrypted automatically
- KMS request limits: 5,500–30,000 requests/second (varies by region); S3 Bucket Key reduces calls

**S3 Bucket Keys**: Reduce SSE-KMS costs by generating a short-lived bucket-level key (reduces per-object KMS API calls by ~99%).

### 5. Replication

| Type | Acronym | Use Case |
|------|---------|---------|
| **Cross-Region Replication** | CRR | Disaster recovery, compliance (data residency), latency |
| **Same-Region Replication** | SRR | Log aggregation, test/prod sync, data sovereignty |

- Replication requires versioning enabled on both source and destination buckets
- Existing objects NOT replicated automatically (use S3 Batch Operations for one-time sync)
- Replication does NOT replicate delete markers by default (can enable)
- **Replication Time Control (RTC)**: 99.99% of objects replicated within 15 minutes (SLA-backed)

### 6. Performance Optimization

- **Prefix parallelism**: S3 scales to 3,500 PUT/COPY/POST/DELETE and 5,500 GET/HEAD requests per second per prefix
- More prefixes = more parallelism (e.g., use `year/month/day/hour/` partitioning to spread load)
- **Multipart upload**: required for objects > 5GB, recommended for > 100MB; parallel part uploads
- **Transfer Acceleration**: routes uploads through CloudFront edge locations → faster cross-region uploads
- **S3 Select / Glacier Select**: retrieve subset of data using SQL (only scan what you need)
- **Byte-range fetches**: GET specific byte ranges in parallel for large file downloads

## Key Concepts

- **Object versioning** — keep all versions of an object; protect against accidental deletion/overwrite
- **MFA Delete** — require MFA to permanently delete versioned objects or disable versioning (extra protection)
- **Block Public Access** — account-level or bucket-level setting overriding all bucket/object ACLs
- **Requester Pays** — requester (not bucket owner) pays for data transfer and requests; used for public datasets
- **Event Notifications** — trigger SNS/SQS/Lambda on S3 events (PutObject, DeleteObject, etc.)
- **S3 Object Lock** — WORM (Write Once Read Many) for compliance; Governance mode (privileged delete) vs Compliance mode (no delete until retention)
- **S3 Batch Operations** — run operations (copy, tag, restore, invoke Lambda) on billions of objects at once
- **Presigned URL** — time-limited URL granting temporary access to private objects (for sharing without credentials)

## Checklist

- [ ] Block Public Access enabled at account level?
- [ ] Bucket versioning enabled for critical data?
- [ ] Lifecycle policy configured for storage class transitions and expiration?
- [ ] SSE-KMS with S3 Bucket Key for KMS cost reduction?
- [ ] Multipart upload used for objects > 100MB?
- [ ] CRR configured for DR requirements (target in different region)?
- [ ] S3 prefixes designed for parallel access patterns (data lake partitioning)?
- [ ] S3 Access Points configured for shared data lake with multiple consumers?

## Output Format

- 🔴 **Critical** — Block Public Access disabled with no compensating bucket policy; no versioning on critical mutable data; SSE disabled on regulated data
- 🟡 **Warning** — No lifecycle policy (data accumulating in Standard indefinitely); ACLs used instead of bucket policies; multipart upload not cleaning up failed parts (incomplete multipart lifecycle rule missing)
- 🟢 **Suggestion** — Intelligent-Tiering for unknown access patterns; S3 Select to reduce data transfer costs; Transfer Acceleration for cross-region uploads

## Exam Tips

- **S3 Standard-IA has minimum 30-day storage charge** — if data is deleted before 30 days, still charged for 30 days; retrieval fee per GB
- **Glacier Deep Archive = cheapest storage; 12–48h retrieval time** — use only for data accessed once a year or less
- **SSE-KMS = audit trail in CloudTrail** (every GET/PUT logs KMS key usage); SSE-S3 = simpler, no per-request KMS API calls, no audit trail
- **Requester Pays** = requester pays transfer costs; anonymous access not allowed (must authenticate)
- **S3 Event Notifications → SNS/SQS/Lambda** for event-driven pipelines; EventBridge for more complex filtering and routing
- **Block Public Access** = account-level or bucket-level; always enable for data lakes (even if bucket policies seem correct)
- **Replication requires versioning** on both buckets; existing objects not copied automatically
- **S3 Bucket Keys** reduce SSE-KMS API costs by ~99% — enable by default for KMS-encrypted buckets
