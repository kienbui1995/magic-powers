---
name: azure-functions
description: Use when building serverless event-driven applications with Azure Functions, designing Durable Functions orchestration workflows, choosing hosting plans, or studying for Azure AI Cloud Developer Associate (AI-200/AZ-204).
---

# Azure Functions

## When to Use
- Building serverless, event-driven compute on Azure
- Designing Durable Functions for stateful orchestration workflows
- Choosing between Consumption, Premium, and Dedicated hosting plans
- Implementing input/output bindings to reduce boilerplate SDK code
- Connecting Functions to Service Bus, Event Grid, Cosmos DB, or Blob Storage
- Preparing for Azure AI Cloud Developer Associate (AI-200/AZ-204) exam

## Core Jobs

### 1. Triggers
| Trigger | Description |
|---------|-------------|
| **HTTP** | REST endpoint; function-level or host-level key auth |
| **Timer** | CRON expression schedule (runs in UTC by default) |
| **Blob Storage** | New/modified blob in container |
| **Queue Storage** | New message in Azure Queue Storage |
| **Service Bus** | Message from Service Bus queue or topic |
| **Event Hubs** | Event batch from Event Hub consumer group |
| **Event Grid** | Event Grid event (cloud events or Event Grid schema) |
| **Cosmos DB** | Change feed trigger on Cosmos DB container |

- One function = one trigger; multiple triggers require separate functions

### 2. Hosting Plans
| Plan | Cold Start | Scale | VNet | Best For |
|------|-----------|-------|------|---------|
| **Consumption** | Yes | 0 → 200 instances auto | No | Bursty, intermittent workloads |
| **Flex Consumption** | Minimal | 0 → custom auto | Yes | Serverless + VNet requirement |
| **Premium (EP)** | No (pre-warmed) | Min 1, auto scale | Yes | No cold start + VNet + longer timeout |
| **Dedicated (App Service)** | No | Manual or auto | Yes | Predictable always-on workloads |

- **Cold start** = first request after scale-to-zero spin-up delay (100ms–2s typically)
- **Premium plan** = pre-warmed instances eliminate cold starts; needed for VNet integration + Consumption
- **Consumption plan timeout** = 5 minutes default, 10 minutes max; Premium = 30 minutes default, unlimited

### 3. Durable Functions
Stateful function orchestration patterns:
| Pattern | Description |
|---------|-------------|
| **Function chaining** | Sequential calls: F1 → F2 → F3; output of one is input to next |
| **Fan-out/fan-in** | Parallel execution of multiple activity functions; wait for all |
| **Async HTTP API** | Long-running operation; return 202 + status URL immediately |
| **Monitor** | Polling loop that checks external status and waits until complete |
| **Human interaction** | Wait for external event (approval); timeout with escalation |

- **Orchestrator function** = deterministic; no I/O, random, DateTime.Now directly; use activity functions for these
- **Activity function** = does actual work; called by orchestrator; can retry on failure
- **Entity function** = stateful actors; manage state with operations

### 4. Input and Output Bindings
- Bindings = declarative connections to Azure services; reduce SDK boilerplate
- Input binding: read data when function executes (e.g., read Blob, read Cosmos document)
- Output binding: write data after function executes (e.g., write to Queue, write to Table)
- Example (C# attribute): `[BlobInput("container/{filename}")] string blobContent`
- Example (Python decorator): `@app.blob_input(arg_name="blob", path="container/{filename}")`
- Supported: Blob, Queue, Table, Service Bus, Event Hub, Cosmos DB, SignalR, SendGrid, Twilio

### 5. Managed Identity Authentication
- **System-assigned Managed Identity**: identity tied to Function App lifecycle; deleted with app
- **User-assigned Managed Identity**: standalone identity; reusable across multiple resources
- `DefaultAzureCredential` (Azure SDK): tries Managed Identity, Visual Studio, Azure CLI in sequence
- Assign RBAC role to Function's Managed Identity on target resource (e.g., `Storage Blob Data Reader`)
- Never store connection strings or secrets in code; use Key Vault references in App Settings

### 6. Function Keys and Auth
| Auth Level | Scope | Use Case |
|------------|-------|---------|
| **Anonymous** | No key required | Public endpoints (webhooks with own auth) |
| **Function** | Per-function key | Caller has function-specific key |
| **Host** | All functions in app | Caller has master key for all functions |
| **Admin** | Management operations | Admin key has full host-level access |

- HTTP trigger default: function-level auth
- For machine-to-machine auth in Azure: prefer Managed Identity over function keys

## Key Concepts
- **Consumption plan** — true serverless; scales to zero; cold starts; pay-per-execution
- **Premium plan** — pre-warmed instances; no cold start; VNet integration; higher baseline cost
- **Durable orchestrator** — must be deterministic; no direct I/O; calls activity functions for side effects
- **DefaultAzureCredential** — SDK credential chain; uses Managed Identity in production automatically
- **Binding** — declarative trigger/input/output connection; avoids SDK plumbing code
- **Timer trigger CRON** — UTC by default; format: `{second} {minute} {hour} {day} {month} {weekday}`

## Checklist
- [ ] Hosting plan chosen based on cold start tolerance, VNet need, and workload pattern?
- [ ] Managed Identity used instead of connection strings for Azure service authentication?
- [ ] Durable orchestrator functions kept deterministic (no DateTime.Now, random, direct I/O)?
- [ ] Output bindings used to reduce boilerplate for writing to Queue/Blob/Cosmos?
- [ ] Function timeout configured appropriately for hosting plan (Consumption max = 10 min)?
- [ ] Key Vault references used for secrets in App Settings (not hardcoded values)?
- [ ] Retry policy configured for transient failure scenarios (Service Bus, Cosmos)?

## Output Format
- 🔴 **Critical** — DateTime.Now or random number generator directly in Durable orchestrator (breaks replay determinism)
- 🔴 **Critical** — connection strings hardcoded in function code or app settings (use Key Vault references)
- 🟡 **Warning** — Consumption plan used when VNet integration is required (use Premium or Flex Consumption)
- 🟡 **Warning** — function timeout exceeded without Premium plan (Consumption max = 10 min)
- 🟢 **Suggestion** — use DefaultAzureCredential with user-assigned Managed Identity for cross-resource auth

## Exam Tips
- **Consumption plan = true serverless; scale to zero; cold starts** — Premium plan = pre-warmed, no cold start, VNet integration
- **Durable orchestrator = deterministic** — never put I/O, DateTime.Now, or random directly in orchestrator; delegate to activity functions
- **Bindings reduce boilerplate** — output binding writes to Queue/Blob without SDK calls; declared in function.json or decorators
- **Timer trigger = CRON expression in UTC** — format: `0 0 * * * *` = every hour; `0 */5 * * * *` = every 5 minutes
- **Managed Identity = no credentials in code** — assign RBAC role to Function's Managed Identity; use DefaultAzureCredential in SDK
- **Function keys: function vs host vs admin** — function key = per-function; host key = all functions; admin key = management operations (protect carefully)
