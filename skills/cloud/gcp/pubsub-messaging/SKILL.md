---
name: pubsub-messaging
description: Use when designing Pub/Sub topics/subscriptions, choosing push vs pull, handling message ordering, dead letters, or integrating Pub/Sub with Dataflow/BigQuery. Covers GCP-PDE domain: Ingest and process data (~25-30%).
---

# Pub/Sub Messaging

## When to Use
- Designing event-driven or streaming ingestion on GCP
- Choosing between Pub/Sub and Pub/Sub Lite
- Troubleshooting message delivery, ordering, or acknowledgement issues
- Preparing for GCP Professional Data Engineer exam

## Core Jobs

### 1. Topic and Subscription Design
- One **topic** = one logical event stream (e.g., `orders-created`, `sensor-readings`)
- Multiple **subscriptions** = multiple independent consumers of the same topic
- Each subscription maintains its own offset — messages delivered to each independently
- Subscription **ack deadline** (default 10s, max 600s) — extend if processing takes longer

### 2. Pull vs Push Subscriptions
| Factor | Pull | Push |
|--------|------|------|
| Consumer | Subscriber polls for messages | Pub/Sub pushes to HTTPS endpoint |
| Control | Consumer controls rate | Pub/Sub controls delivery rate |
| Best for | Dataflow, batch consumers | Cloud Run, webhooks, Cloud Functions |
| Auth | Service account key/WIF | OIDC token in Authorization header |

### 3. Message Ordering
- By default, Pub/Sub does NOT guarantee ordering
- Enable **ordering keys** to guarantee ordered delivery within a key
- Ordering keys work only within a single region (cross-region = no ordering guarantee)
- Use case: ordered events per user_id, device_id, transaction_id

### 4. Dead Letter Topics
- Configure a **dead letter topic** on a subscription for undeliverable messages
- Messages moved to dead letter after max delivery attempts (5–100, configurable)
- Monitor dead letter topics with Cloud Monitoring alerts
- Always process dead letters (don't ignore them)

### 5. Pub/Sub Lite vs Pub/Sub
| Factor | Pub/Sub | Pub/Sub Lite |
|--------|---------|--------------|
| Management | Fully managed, global | Zone/region-specific, manual capacity |
| Ordering | Ordering keys | Partition-based ordering (like Kafka) |
| Cost | Per message/byte | Provisioned capacity (cheaper at scale) |
| Retention | 7 days | Configurable up to 31 days |
| Use case | Default choice | Cost-sensitive high-volume workloads |

### 6. Integration Patterns
- **Pub/Sub → Dataflow → BigQuery** — standard streaming analytics pipeline
- **Pub/Sub → Cloud Functions** — lightweight event processing (push subscription)
- **Pub/Sub → Cloud Storage** — use Dataflow or Pub/Sub export for archiving
- **Cloud Scheduler → Pub/Sub → Cloud Functions** — scheduled event trigger pattern

## Key Concepts
- **At-least-once delivery** — same message may be delivered multiple times → idempotent consumers
- **Exactly-once** — available with Dataflow (deduplication via message ID)
- **Message ID** — globally unique; use for deduplication
- **Seek** — replay messages from a timestamp or snapshot

## Checklist
- [ ] Consumers designed to be idempotent (handle duplicate messages)?
- [ ] Ack deadline set longer than max processing time?
- [ ] Dead letter topic configured and monitored?
- [ ] Ordering keys used only where strict ordering is required?
- [ ] Push subscription endpoint uses HTTPS with OIDC auth?
- [ ] Pub/Sub Lite considered for high-volume cost reduction?

## Output Format
- 🔴 **Critical** — no idempotency with at-least-once delivery (data duplication risk)
- 🟡 **Warning** — no dead letter topic, ack deadline too short for processing time
- 🟢 **Suggestion** — Pub/Sub Lite for high-volume cost savings, ordering keys opportunity

## Exam Tips
- Pub/Sub does NOT guarantee ordering by default → use ordering keys (single region only)
- At-least-once → always build idempotent consumers
- **Dataflow is the standard bridge** between Pub/Sub and BigQuery for streaming
- Push subscriptions → Cloud Run / Cloud Functions (serverless, event-driven)
- Dead letter topic = where undeliverable messages go after max_delivery_attempts
- Pub/Sub Lite = cheaper but zone-specific, partition-based (Kafka-like model)
