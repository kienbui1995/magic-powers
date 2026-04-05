---
name: agentic-ai-patterns
description: Use when designing AI agents - tool use, multi-agent orchestration, state management, planning loops, error recovery, and agent evaluation
---

# Agentic AI Patterns

## Overview

An agent is an LLM in a loop: observe → think → act → observe. The hard part isn't the LLM — it's the loop control, error recovery, and knowing when to stop.

## When to Use

- Building AI agents that take actions (not just chat)
- Designing tool-use patterns
- Orchestrating multiple agents
- Debugging agent loops that get stuck or go off-track

## Agent Architecture

```
User Goal → Planner → [Tool Call → Observe → Decide]* → Final Answer
```

### Core Components

| Component | Purpose |
|-----------|---------|
| **Planner** | Break goal into steps |
| **Executor** | Run tools, API calls |
| **Observer** | Parse tool results |
| **Decider** | Continue, retry, or stop |
| **Memory** | Track state across steps |

## Patterns

### 1. ReAct (Reasoning + Acting)
```
Thought: I need to find the user's order status
Action: query_database(user_id=123, table="orders")
Observation: [{"id": 456, "status": "shipped"}]
Thought: Found it. The order is shipped.
Answer: Your order #456 has been shipped.
```

### 2. Plan-and-Execute
```
Plan: 1) Search docs  2) Extract relevant info  3) Summarize
Execute step 1: search("refund policy") → [doc1, doc2]
Execute step 2: extract(doc1) → "30-day refund window..."
Execute step 3: summarize → "You have 30 days to request a refund."
```

### 3. Multi-Agent (specialist delegation)
```
Router Agent → classify intent
  ├── Research Agent → search + summarize
  ├── Code Agent → write + test code
  └── Data Agent → query + analyze data
```

## Tool Design Rules

1. **Clear names** — `search_documents` not `tool_1`
2. **Typed parameters** — JSON schema for every tool
3. **Bounded output** — truncate large results, paginate
4. **Error messages** — return actionable errors, not stack traces
5. **Idempotent** — safe to retry on failure

## Error Recovery

| Failure | Recovery |
|---------|----------|
| Tool returns error | Retry once, then report to user |
| Agent loops >10 steps | Force stop, summarize progress |
| Off-topic drift | Check goal alignment every 3 steps |
| Hallucinated tool call | Validate tool name exists before calling |
| Timeout | Set max execution time, graceful exit |

## State Management

```python
state = {
    "goal": "Find cheapest flight to Tokyo",
    "steps_completed": ["searched flights", "compared prices"],
    "current_step": "booking confirmation",
    "attempts": 2,
    "max_attempts": 5,
    "context": {...}
}
```

- Persist state for long-running agents
- Log every step for debugging
- Set hard limits: max steps, max time, max cost

## Anti-Patterns

| Pattern | Fix |
|---------|-----|
| No max iterations | Always set a loop limit |
| Agent calls itself recursively | Detect cycles, break loop |
| Too many tools (>15) | Group into categories, use router |
| No logging | Log every thought/action/observation |
| Trusting agent output blindly | Validate before executing side effects |

## Integration

- **magic-powers:prompt-engineering** — design agent system prompts
- **magic-powers:llm-evaluation** — evaluate agent task completion
- **magic-powers:ai-safety-guardrails** — guard agent actions
- **magic-powers:llm-observability** — monitor agent runs
