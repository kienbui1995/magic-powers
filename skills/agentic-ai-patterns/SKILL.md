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

## Graph-Based Agents (LangGraph)

Beyond simple loops, production agents use directed graphs for complex branching logic:

```python
from langgraph.graph import StateGraph, END

def should_continue(state):
    if state["tool_calls"]: return "tools"
    if state["needs_human"]: return "human_review"
    return END

graph = StateGraph(AgentState)
graph.add_node("llm", call_llm)
graph.add_node("tools", execute_tools)
graph.add_node("human_review", request_approval)
graph.add_conditional_edges("llm", should_continue)
graph.add_edge("tools", "llm")  # loop back after tool execution
```

**Key patterns:**
- **Parallel tool execution** — fan-out to multiple tools simultaneously, merge results
- **Conditional branching** — route based on output content, confidence, or tool results
- **Subgraph composition** — nest agent graphs for modularity
- **Persistence** — LangGraph's checkpointing enables pause/resume across sessions

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

## Memory Architecture

Agents need different memory types for different purposes:

| Type | Storage | Lifetime | Use case |
|------|---------|---------|---------|
| **In-context** | Token window | Current session | Active task state, recent tool results |
| **Session** | DB (Redis/Postgres) | One conversation | User preferences, conversation history |
| **Long-term** | Vector DB | Persistent | User facts, past decisions, learned patterns |
| **Episodic** | DB + embeddings | Persistent | Past task completions, examples |

**Context window management:**
```python
# Summarize old messages to prevent overflow
def compress_history(messages, max_tokens=4000):
    if count_tokens(messages) < max_tokens:
        return messages
    # Keep system + last 5 messages, summarize the rest
    summary = llm.summarize(messages[1:-5])
    return [messages[0], HumanMessage(f"[Summary: {summary}]")] + messages[-5:]
```

**When to use external memory:**
- Conversation > 20 turns → summarize and store
- User mentions facts that apply beyond this session → upsert to long-term store
- Agent needs to "remember" past tasks → episodic store with semantic search

## Human-in-the-Loop

Design confidence-based escalation rather than binary human/autonomous:

```python
def route_by_confidence(result, confidence_threshold=0.85):
    if result.confidence >= confidence_threshold:
        return "auto_proceed"
    elif result.confidence >= 0.6:
        return "notify_and_proceed"  # log but continue
    else:
        return "require_approval"    # block and wait

# Approval checkpoint in LangGraph
def human_approval_node(state):
    # Pause execution, notify human, wait for response
    send_notification(state["pending_action"])
    approval = wait_for_human_input(timeout=3600)  # 1 hour timeout
    return {"approved": approval, "human_feedback": approval.comment}
```

**When to require human approval:**
- Irreversible actions (delete, send, purchase, deploy)
- Low confidence + high stakes
- Novel situation not seen in training
- User explicitly requested oversight
- Regulatory requirement (financial, medical)

**Graceful timeout:** If no response within timeout → escalate or abort safely, never proceed on assumption.

## Anti-Patterns

| Pattern | Fix |
|---------|-----|
| No max iterations | Always set a loop limit |
| Agent calls itself recursively | Detect cycles, break loop |
| Too many tools (>15) | Group into categories, use router |
| No logging | Log every thought/action/observation |
| Trusting agent output blindly | Validate before executing side effects |

## Cost-Aware Agent Design

Agent costs compound: each step adds tokens. Design for efficiency:

**Token budgets:**
```python
class CostAwareAgent:
    def __init__(self, max_tokens_per_task=50000):
        self.token_budget = max_tokens_per_task
        self.tokens_used = 0
    
    def should_continue(self, step_estimate):
        if self.tokens_used + step_estimate > self.token_budget * 0.9:
            return "summarize_and_stop"  # graceful degradation
        return "continue"
```

**Tool selection strategy:**
- Cheap tools first (search before synthesize)
- Cache tool results for duplicate calls in same session
- Use smaller model for tool selection, larger for final synthesis
- Parallel tools when independent (fan-out saves latency and doesn't add cost)

**Per-task cost tracking:**
```python
# Log cost per agent task for accountability
log_task_cost(task_id, input_tokens, output_tokens, tool_calls, total_usd)
```

## Integration

- **magic-powers:prompt-engineering** — design agent system prompts
- **magic-powers:llm-evaluation** — evaluate agent task completion
- **magic-powers:ai-safety-guardrails** — guard agent actions
- **magic-powers:llm-observability** — monitor agent runs
