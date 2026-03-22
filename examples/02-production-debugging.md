# Example: Debugging a Production Issue

A real scenario using the debugger and SRE agents together.

## Scenario

Users report 500 errors on the `/api/orders` endpoint. Error rate spiked 30 minutes ago.

## 1. Triage with SRE (Sonnet)

```
You: @sre We're seeing 500s on /api/orders. Started ~30 min ago.
     No deploys in the last 2 hours. What should we check?
```

SRE suggests: check logs, recent DB migrations, external service health, resource usage.

## 2. Deep Dive with Debugger (Sonnet)

```
You: @debugger The error logs show "connection pool exhausted" from the
     database layer. Here's the stack trace: [paste trace]
```

Debugger follows `systematic-debugging` skill:
1. Reproduce → check connection pool config
2. Hypothesize → leaked connections from long-running queries
3. Isolate → find the query that holds connections
4. Fix → add connection timeout + fix the leaking query

## 3. Verify Fix with Reviewer (Haiku)

```
You: @code-reviewer Review this connection pool fix before I deploy.
```

Quick sanity check on Haiku — costs almost nothing.

## 4. Post-Mortem with Technical Writer (Haiku)

```
You: @technical-writer Write a post-mortem for this incident.
     Root cause: connection pool exhaustion from unoptimized query.
     Impact: 30 min of 500 errors on /api/orders.
     Fix: added connection timeout, optimized query.
```

Total cost: ~$0.25 (vs ~$1.00 all-Opus).

> **Note:** Cost figures are estimates based on Anthropic API pricing as of early 2025. Actual costs vary by input/output length. See [Anthropic pricing](https://www.anthropic.com/pricing) for current rates.
