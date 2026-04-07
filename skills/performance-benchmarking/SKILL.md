---
name: performance-benchmarking
description: Use when establishing performance baselines, comparing before/after changes, or validating performance SLAs
---

# Performance Benchmarking

## When to Use
When you need to measure system performance objectively — before/after a change, or to validate a performance requirement.

## Core Jobs

### 1. Define What to Measure
Pick metrics that matter to users:
- **Latency**: P50, P95, P99 response time (not average)
- **Throughput**: requests per second at target latency
- **Error rate**: % of requests failing under load
- **Resource cost**: CPU/memory per request

Avoid: average latency (hides outliers), total requests (not meaningful without time).

### 2. Design the Benchmark
- **Workload**: representative mix of operations (not just happy path)
- **Concurrency**: test at 1x, 2x, 5x, 10x expected traffic
- **Duration**: at least 5 minutes to reach steady state (longer = better)
- **Warmup**: first 60 seconds discarded (JIT, connection pooling, caches)
- **Isolation**: run on dedicated hardware (not shared with other workloads)

### 3. Run the Benchmark
Tools:
- HTTP: wrk, k6, Locust, Apache Bench (ab)
- Database: pgbench, sysbench
- Custom: write a script that mimics real traffic patterns

```bash
# k6 example
k6 run --vus 100 --duration 5m benchmark.js
```

### 4. Interpret Results
- Check percentile distribution (P99 vs P50 spread — large gap = outliers)
- Look for throughput knee: where does latency start degrading?
- Compare before/after: use same hardware, same data size, same warmup
- Document exact conditions so results are reproducible

## Key Outputs
- Benchmark script (reusable, version controlled)
- Baseline results (before change)
- Comparison report (before vs after)
- Performance regression CI check

## Anti-Patterns
- Benchmarking average latency
- Running benchmarks on shared/noisy hardware
- No warmup period (cold JVM, cold cache)
- Comparing benchmarks run under different conditions
