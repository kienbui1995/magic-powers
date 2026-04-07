---
name: performance-testing
description: Use when load testing APIs, profiling bottlenecks, or validating performance SLAs before release
---

# Performance Testing

## When to Use
When you need to validate that a system can handle expected load, find bottlenecks before users do, or establish performance baselines.

## Core Jobs

### 1. Define Performance Requirements
Before testing, specify:
- **Throughput target**: X requests/sec at peak
- **Latency target**: P95 < Nms, P99 < Nms
- **Error rate target**: < X% under load
- **Duration**: how long must it sustain this load?

Without these, you don't know if your test passed.

### 2. Write Load Test Scripts
k6 example:
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 50 },   // ramp up to 50 users
    { duration: '5m', target: 50 },   // stay at 50
    { duration: '2m', target: 100 },  // ramp to 100
    { duration: '5m', target: 100 },  // stay at 100
    { duration: '2m', target: 0 },    // ramp down
  ],
};

export default function () {
  const res = http.get('https://api.example.com/users');
  check(res, { 'status was 200': (r) => r.status === 200 });
  sleep(1);
}
```

### 3. Run and Observe
During the test, watch:
- Latency trend (is it flat or climbing?)
- Error rate
- CPU and memory on the server
- Database connection pool utilization
- Queue depths (if async)

The throughput "knee" = where latency starts degrading rapidly. Don't target above this.

### 4. Profile and Fix Bottlenecks
When tests fail:
- Use APM (Datadog, New Relic) to find slow traces
- Database: check slow query log, explain plan, missing indexes
- CPU: profile with py-spy, pprof, or async-profiler (JVM)
- Memory: heap dump analysis

## Key Outputs
- Load test script (version controlled)
- Performance requirements document
- Test results report (percentile breakdown)
- Bottleneck analysis and fixes

## Anti-Patterns
- Testing without defined pass/fail criteria
- Testing average load only (not peak or spike)
- No profiling when tests fail — "we need more servers" is rarely the fix
- Running performance tests against production
