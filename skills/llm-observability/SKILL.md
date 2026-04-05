---
name: llm-observability
description: Use when monitoring AI systems in production - cost tracking, latency, token usage, error rates, quality drift, and LLMOps dashboards
---

# LLM Observability

## Overview

You can't manage what you can't see. LLM systems fail silently — quality degrades, costs spike, latency creeps up — all without errors in your logs.

## When to Use

- Deploying any LLM feature to production
- Investigating cost spikes or quality drops
- Setting up monitoring for AI systems
- Building LLMOps dashboards

## What to Track

### Must-Have Metrics

| Metric | Why | Alert When |
|--------|-----|------------|
| **Cost per query** | Budget control | >2x baseline |
| **Latency p50/p95** | User experience | p95 >5s |
| **Token usage** (input + output) | Cost driver | Sudden spike |
| **Error rate** | Reliability | >1% |
| **Quality score** | Output quality | Drops >10% |

### Nice-to-Have

| Metric | Why |
|--------|-----|
| Cache hit rate | Cost savings effectiveness |
| Fallback trigger rate | How often guardrails fire |
| Model version distribution | Track rollouts |
| User satisfaction (thumbs) | Ground truth quality |

## Logging Pattern

```json
{
  "trace_id": "abc-123",
  "timestamp": "2026-04-05T08:30:00Z",
  "model": "gpt-4o",
  "prompt_tokens": 1200,
  "completion_tokens": 350,
  "latency_ms": 2100,
  "cost_usd": 0.023,
  "quality_score": 0.92,
  "guardrail_triggered": false,
  "cached": false,
  "user_id": "user_456",
  "feature": "chat_support"
}
```

Log EVERY LLM call. Storage is cheap, debugging without logs is expensive.

## Cost Management

```
Daily cost = Σ (calls × avg_tokens × price_per_token)
```

**Cost reduction levers:**
1. **Prompt optimization** — shorter prompts, same quality (→ prompt-engineering)
2. **Model routing** — use cheaper model for simple tasks
3. **Caching** — cache identical/similar queries
4. **Batching** — batch API calls for 50% discount (where available)
5. **Rate limiting** — per-user limits to prevent abuse

## Tools

| Tool | Type | Best For |
|------|------|----------|
| LangSmith | Managed | LangChain apps, tracing |
| Helicone | Managed | Cost tracking, caching proxy |
| Braintrust | Managed | Eval + logging |
| Langfuse | OSS | Self-hosted, full tracing |
| OpenTelemetry + custom | DIY | Existing observability stack |

## Alerting Rules

```yaml
alerts:
  - name: cost_spike
    condition: daily_cost > 2x rolling_7d_avg
    action: slack_notify + auto_rate_limit

  - name: quality_drop
    condition: avg_quality_score < 0.80 over 1h
    action: page_oncall

  - name: latency_degradation
    condition: p95_latency > 5000ms over 15m
    action: slack_notify
```

## Integration

- **magic-powers:llm-evaluation** — quality scores feed into observability
- **magic-powers:ai-safety-guardrails** — track guardrail trigger rates
- **magic-powers:incident-response** — respond to AI system incidents
- **magic-powers:cost-aware-routing** — optimize based on cost data
