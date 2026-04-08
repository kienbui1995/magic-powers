---
name: lambda-serverless
description: Use when building Lambda functions, designing serverless architectures, configuring event sources, managing concurrency and cold starts, or setting up Lambda@Edge. Covers AWS DVA-C02 and SAP-C02 serverless domains.
---

# AWS Lambda Serverless

## When to Use
- Building event-driven functions with AWS Lambda
- Designing serverless architectures on AWS
- Configuring event source mappings (SQS, DynamoDB Streams, Kinesis)
- Managing Lambda concurrency, cold starts, and provisioned concurrency
- Deploying Lambda@Edge or CloudFront Functions for edge computing
- Preparing for AWS DVA-C02 or SAP-C02 exams

## Core Jobs

### 1. Lambda Triggers (Event Sources)

| Source | Invocation | Concurrency | Ordering |
|--------|-----------|-------------|---------|
| **API Gateway / ALB** | Synchronous (push) | Per-request | N/A |
| **S3** | Asynchronous (push) | Per-event | Not guaranteed |
| **SNS** | Asynchronous (push) | Per-message | Not guaranteed |
| **EventBridge** | Asynchronous (push) | Per-event | Not guaranteed |
| **SQS** | Polling (event source mapping) | Batch-based | FIFO within queue |
| **DynamoDB Streams** | Polling (event source mapping) | Per-shard | Ordered per shard |
| **Kinesis Data Streams** | Polling (event source mapping) | Per-shard | Ordered per shard |
| **Cognito** | Synchronous (trigger type specific) | Per-event | N/A |
| **Step Functions** | Synchronous or async | Per-execution | N/A |

**Push model** (API GW, S3, SNS): AWS service invokes Lambda directly.
**Pull model / Event source mapping** (SQS, Kinesis, DynamoDB Streams): Lambda polls the source.

### 2. Concurrency Management

| Type | Description | Use Case |
|------|-------------|---------|
| **Unreserved concurrency** | Shared pool across all functions | Default; functions share account limit |
| **Reserved concurrency** | Guaranteed + maximum cap | Ensure function always has capacity; prevent throttling other functions |
| **Provisioned concurrency** | Pre-initialized execution environments | Eliminate cold starts for latency-sensitive functions |

**Account limit**: 1,000 concurrent executions per region by default (can request increase).
**Reserved concurrency = 0**: effectively disables the function (throttles all invocations).

**Concurrency calculation**: `concurrency = (requests/second) × (average function duration in seconds)`
Example: 500 req/s × 0.2s average = 100 concurrent executions needed.

### 3. Cold Starts

**Cold start occurs when**:
- No warm execution environment available
- Function not invoked for several minutes (environment recycled)
- Burst traffic exceeds warm environments

**Cold start duration by runtime** (approximate):
- Java, .NET, Kotlin: 500ms–2s (JVM initialization)
- Python, Node.js, Go, Ruby: 50–200ms (lighter runtimes)
- Custom container: varies (container pull adds overhead)

**Cold start mitigations**:
1. **Provisioned concurrency** — pre-initialize environments; eliminates cold starts (costs money continuously)
2. **Smaller deployment package** — less code to load; faster init
3. **Minimize imports/initialization code** — move work outside handler to module-level (runs once)
4. **SnapStart (Java)** — snapshot initialized environment; restore on cold start (sub-100ms for Java)
5. **Keep warm (not recommended)** — scheduled pings every 5 minutes; not reliable and wasteful

### 4. Event Source Mapping Configuration

**SQS + Lambda**:
- Batch size: 1–10,000 messages
- Batch window: 0–300 seconds (wait to fill batch before invocation)
- Visibility timeout: must be > Lambda function timeout × 6 (to prevent duplicate processing during retries)
- On failure: DLQ on SQS queue or Lambda destination (failure destination)
- `ReportBatchItemFailures`: Lambda reports specific failed messages → only failed items retried (not whole batch)

**Kinesis / DynamoDB Streams + Lambda**:
- Shard iterator = one Lambda invocation per active shard
- `BisectBatchOnFunctionError`: split batch and retry halves to isolate bad records
- `DestinationConfig.OnFailure`: send failed records to SQS or SNS
- `MaximumRetryAttempts` and `MaximumRecordAgeInSeconds`: limit retries to prevent infinite loops
- `ParallelizationFactor`: 1–10 concurrent invocations per shard (increase throughput)

### 5. Lambda Layers

- Package shared libraries and dependencies separately from function code
- Up to 5 layers per function
- Max unzipped size: 250MB (function + all layers combined)
- Layers can be shared across accounts (layer-based sharing for internal libraries)
- Common uses: AWS SDK extensions, pandas/numpy (large ML libraries), custom runtimes
- **Not for secrets**: use Secrets Manager or Parameter Store; not environment variables or layers

### 6. Lambda@Edge and CloudFront Functions

| Feature | Lambda@Edge | CloudFront Functions |
|---------|------------|---------------------|
| Runtime | Node.js, Python | JavaScript (ES5) |
| Max execution time | 5s (viewer), 30s (origin) | 1ms |
| Max memory | 128MB–10GB | 2MB |
| Location | 400+ edge locations | 400+ edge locations |
| Trigger points | Viewer request/response, Origin request/response | Viewer request/response only |
| Cost | Per request + duration | Per request only (cheaper) |
| State | Stateless | Stateless |
| Deployment region | Must deploy in us-east-1 | Global via CloudFront |

**CloudFront Functions** = simple transformations (URL rewrite, header manipulation, redirect).
**Lambda@Edge** = complex logic (auth, A/B testing, geo-routing, dynamic origin selection).

### 7. Lambda Destinations

- Alternative to try/catch inside Lambda for async invocations
- Configure on-success and on-failure destinations:
  - SQS queue, SNS topic, EventBridge bus, another Lambda function
- Provides full invocation record (input + output/error) to destination
- More flexible than DLQ (which only sends failed event payload)

## Key Concepts

- **Execution environment** — isolated container with function code, runtime, layers, and env vars; reused for warm invocations
- **Handler** — entry point function Lambda invokes (`module.handler` for Node.js, `module.handler` for Python)
- **Execution role** — IAM role Lambda assumes; defines what AWS services the function can call
- **Resource-based policy** — policy on the Lambda function itself; controls who can invoke it (other accounts, services)
- **Lambda function URL** — built-in HTTPS endpoint for Lambda without API Gateway; supports IAM or no auth
- **Lambda extensions** — lightweight processes running alongside Lambda function (observability agents, secrets caching)
- **SnapStart** — Java 11+ feature: snapshot initialized state of execution environment for sub-100ms cold starts
- **Ephemeral storage /tmp** — 512MB to 10GB per execution environment; NOT shared between invocations

## Checklist

- [ ] SQS visibility timeout set to > Lambda timeout × 6 (prevent duplicate processing)?
- [ ] Reserved concurrency set to prevent one function from consuming all account concurrency?
- [ ] Provisioned concurrency configured for latency-sensitive APIs?
- [ ] Initialization code (clients, connections) outside handler function (module-level)?
- [ ] ReportBatchItemFailures enabled for SQS event source (partial batch success)?
- [ ] Lambda destinations configured for async invocations (on-success and on-failure)?
- [ ] Layers used for shared dependencies (not duplicated across functions)?
- [ ] Lambda execution role follows least-privilege principle?

## Output Format

- 🔴 **Critical** — SQS visibility timeout < Lambda timeout (guarantees duplicate processing); Lambda function consuming full account concurrency (starving other functions); no error handling on async invocations (silent failures)
- 🟡 **Warning** — Cold starts affecting user-facing API (provisioned concurrency not configured); no DLQ/destination for async function failures; large deployment package (slow cold starts)
- 🟢 **Suggestion** — Lambda SnapStart for Java functions; Lambda function URL instead of API Gateway for simple use cases; layers for shared dependencies

## Exam Tips

- **SQS + Lambda**: batch size up to 10,000; visibility timeout must be > Lambda timeout (to avoid duplicate processing during retries)
- **Provisioned concurrency** = eliminates cold starts; costs money even when idle (pre-initialized environments running 24/7)
- **Lambda execution role** = what Lambda CAN do (outbound AWS API calls); **resource policy** = who CAN invoke Lambda (inbound)
- **Max execution timeout = 15 minutes**; for longer tasks use Step Functions + Fargate or ECS tasks
- **Lambda@Edge** = deployed in us-east-1 ONLY but runs globally at CloudFront edge; **CloudFront Functions** = cheaper, sub-millisecond, simpler
- **Layers = shared dependencies** (SDK, pandas); NOT for secrets — use Secrets Manager or Parameter Store instead
- **BisectBatchOnFunctionError** (Kinesis/DynamoDB Streams): splits failing batch in half to isolate bad records, reducing reprocessing
- **ReportBatchItemFailures** (SQS): return failed message IDs — only those specific messages are retried, not the whole batch
