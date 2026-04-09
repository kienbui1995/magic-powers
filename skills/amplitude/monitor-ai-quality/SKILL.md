---
name: monitor-ai-quality
description: Proactive health monitoring of AI/LLM features covering quality, cost, performance, and error metrics. Uses mcp__Amplitude__query_amplitude_data, mcp__Amplitude__get_charts, mcp__Amplitude__get_agent_results.
---

# Monitor AI Quality

## When to Use

- Daily or weekly health check of AI/LLM features in production
- After deploying a prompt change — did quality improve or degrade?
- After an LLM provider outage — is quality back to normal?
- When user satisfaction on AI features is trending down
- When AI compute costs are higher than expected
- Building a monitoring dashboard for an AI product
- Before a major product launch that relies on AI features

## Core Jobs

### Dimension 1: Quality Metrics

Quality measures whether the AI is actually helping users succeed.

**Key quality metrics:**

**User satisfaction score:**
```
mcp__Amplitude__query_amplitude_data:
  event: ai_feedback_submitted
  time_range: last 7 days
  metric: avg(satisfaction_rating)
  breakdown: by day
  group_by: [topic_category, feature_name]
```

Track: average rating trend, rating distribution (not just average — a 3.5 average could mean half love it and half hate it).

**Resolution rate:**
```
Sessions where user completed intended action after AI interaction
/ Total AI sessions

Proxy: sessions without escalation AND with positive completion event
```

**Escalation rate:**
```
Sessions where user requested human support
/ Total AI sessions
```

Alert threshold: escalation rate > 15% → investigate which topics are failing.

**Topic coverage score:**
```
Well-covered topics (success rate >75%) / Total topic clusters
```

**Quality thresholds:**
```
GREEN:   satisfaction >75%, escalation <10%, resolution >65%
YELLOW:  satisfaction 60-75%, escalation 10-15%, resolution 50-65%
RED:     satisfaction <60%, escalation >15%, resolution <50%
```

### Dimension 2: Cost Metrics

Cost measures LLM spend efficiency — same quality for less money, or knowing when cost per session spikes.

**Tokens per session:**
```
mcp__Amplitude__query_amplitude_data:
  event: ai_session_ended
  metric: avg(total_tokens), p95(total_tokens)
  time_range: last 7 days
  breakdown: by day, by topic_category
```

High token sessions by topic reveal where the AI is verbose or where users ask many follow-ups.

**Cost per successful resolution:**
```
Cost per session = total_tokens × model_price_per_token
Cost per resolution = cost per session / resolution rate
```

This is the efficiency metric — it penalizes both high token usage AND low resolution rate.

**High-cost session identification:**
```
mcp__Amplitude__query_amplitude_data:
  event: ai_session_ended
  filter: total_tokens > p95(total_tokens)
  group_by: topic_category, user_segment
```

High-cost outliers often reveal: long multi-turn conversations that failed, users who abuse the AI for off-topic queries, or specific topics that require lengthy explanations.

**Cost thresholds:**
```
GREEN:   cost/resolution stable or decreasing WoW
YELLOW:  cost/resolution increased >20% WoW
RED:     cost/resolution increased >50% WoW, or specific topic showing 3x cost
```

### Dimension 3: Performance Metrics

Performance measures whether the AI is fast enough that users don't give up waiting.

**Response latency:**
```
mcp__Amplitude__query_amplitude_data:
  event: ai_response_received
  metric: p50(response_latency_ms), p95(response_latency_ms)
  time_range: last 24h
  breakdown: by hour
```

**Timeout rate:**
```
Sessions where AI response took > threshold (typically 30s)
/ Total AI sessions
```

**Retry rate:**
```
Sessions where user resent the same message (often due to timeout/error)
/ Total AI sessions
```

**Performance thresholds:**
```
GREEN:   p50 <2s, p95 <8s, timeout rate <1%
YELLOW:  p50 2-5s, p95 8-20s, timeout rate 1-3%
RED:     p50 >5s, p95 >20s, timeout rate >3%
```

**Provider latency correlation**: If latency spikes, check if it correlates with LLM provider status (OpenAI, Anthropic, Gemini). Use `mcp__Amplitude__get_charts` for pre-built latency charts.

### Dimension 4: Error Metrics

Error metrics capture AI-specific failures beyond generic application errors.

**Hallucination signals** (proxy metrics — direct detection requires human review):
```
User correction events (user says "that's wrong" or "that doesn't exist")
User rephrasing count >3 in one session (AI couldn't understand)
Sessions with negative rating AND short duration (quick failure)
```

**Refusal rate:**
```
mcp__Amplitude__query_amplitude_data:
  event: ai_response_generated
  filter: response_type = "refusal"  (if your AI logs this)
  metric: count / total_responses
```

High refusal rate on valid user queries = over-restrictive system prompt.

**Tool failure rate** (for AI agents with tool use):
```
Tool call failures / Total tool calls
```

**Error thresholds:**
```
GREEN:   refusal rate <5% on valid queries, tool failure <2%
YELLOW:  refusal rate 5-10%, tool failure 2-5%
RED:     refusal rate >10%, tool failure >5%
```

### Monitoring Cadence

**Daily check (10 minutes):**
- Quality: satisfaction + escalation rate (last 24h vs. yesterday)
- Errors: refusal rate + tool failures (last 24h)
- Performance: p95 latency (last 24h)

**Weekly review (30 minutes):**
- Cost: tokens/session trend, cost/resolution trend
- Quality: topic coverage analysis, low-rated session sampling
- Performance: WoW latency trends

**After every deploy (30 minutes):**
- Compare all 4 dimensions: last 2h vs. same time last week
- Flag any metric that changed >10%

Use `mcp__Amplitude__get_agent_results` to retrieve any automated AI analysis results that may have already flagged issues.

## MCP Tools

- `mcp__Amplitude__query_amplitude_data` — query all four dimension metrics (quality, cost, performance, errors) with time-period comparisons and breakdowns
- `mcp__Amplitude__get_charts` — retrieve pre-built AI monitoring dashboards and charts; check for existing quality/cost/performance baseline charts
- `mcp__Amplitude__get_agent_results` — retrieve results from Amplitude's AI analysis agents that may have already flagged quality or anomaly issues

## Key Concepts

- **Resolution rate**: The percentage of AI sessions where the user successfully accomplished their goal — the most important quality metric
- **Cost per resolution**: Total LLM spend divided by successful resolutions — the efficiency metric that combines cost and quality
- **Escalation rate**: Percentage of AI sessions that required human intervention — the quality floor (must stay below threshold)
- **Hallucination signal**: Indirect evidence that the AI provided incorrect information (user corrections, multiple rephrases, quick negative rating) — hard to measure directly
- **Refusal rate**: Percentage of valid user queries that the AI declines to answer — high rate indicates over-restrictive system prompt

## Output Format

```
## AI Quality Health Check — <date>
Feature: <AI feature name>
Check period: last 24h (daily) or last 7 days (weekly)

### Health Scorecard

| Dimension | Metric | Value | Threshold | Status | WoW Change |
|-----------|--------|-------|-----------|--------|-----------|
| Quality | Satisfaction | 71% | >75% | 🟡 YELLOW | -4% |
| Quality | Escalation rate | 12% | <10% | 🟡 YELLOW | +2% |
| Quality | Resolution rate | 61% | >65% | 🟡 YELLOW | -3% |
| Cost | Tokens/session | 1,847 | <2,000 | 🟢 GREEN | +8% |
| Cost | Cost/resolution | $0.042 | <$0.05 | 🟢 GREEN | +11% |
| Performance | p50 latency | 1.8s | <2s | 🟢 GREEN | +5% |
| Performance | p95 latency | 6.2s | <8s | 🟢 GREEN | +9% |
| Errors | Refusal rate | 4% | <5% | 🟢 GREEN | -1% |
| Errors | Tool failures | 1.2% | <2% | 🟢 GREEN | +0.2% |

**Overall Status: YELLOW** (3 quality metrics below threshold)

### Top 3 Concerns

1. [Quality] Satisfaction declining (-4% WoW) — correlates with launch of new Data & Reporting topic
   → Investigate: sample 10 low-rated sessions in Data & Reporting category
   → Recommended: add report export guide to AI knowledge base

2. [Quality] Escalation rate increasing (+2% WoW) — above threshold
   → Investigate: which topics trigger escalation? use analyze-ai-topics skill
   → Recommended: add routing rule for Troubleshooting topic

3. [Cost] Cost/resolution up 11% WoW — approaching threshold
   → Investigate: token count increase in which topic cluster?
   → Recommended: shorten system prompt section on General Questions

### What's Healthy
- Performance: all latency metrics well within threshold
- Errors: refusal and tool failure rates stable and acceptable
```
