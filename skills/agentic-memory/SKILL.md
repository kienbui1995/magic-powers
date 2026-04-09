---
name: agentic-memory
description: Use when designing memory systems for AI agents — tiered memory architecture (in-context, session, long-term, episodic), context window management, memory compression, and retrieval strategies for persistent agent state.
---

# Agentic Memory

## Overview

Agents forget everything between sessions by default. Building memory into agents requires deliberate architecture: choosing what to store, where, for how long, and how to retrieve it efficiently without polluting the context window.

## When to Use

- Building an agent that needs to remember across sessions
- Agent context window filling up in long conversations
- Designing multi-session user personalization for agents
- Agent needs to recall past decisions, completed tasks, or user preferences
- Building memory for multi-agent systems where agents share state

## Core Jobs

### 1. Memory Tier Architecture

Four tiers, each with different storage, latency, and persistence:

| Tier | Storage | Latency | Lifetime | Use case |
|------|---------|---------|---------|---------|
| **In-context** | Token window (4K-200K) | 0ms | Current session | Active task state, recent tool results, current conversation |
| **Session** | Redis / Postgres | 1-10ms | One conversation | Conversation history, user preferences in session, task progress |
| **Long-term** | Vector DB + key-value | 10-100ms | Persistent | User facts, learned patterns, past decisions |
| **Episodic** | DB + vector embeddings | 50-200ms | Persistent | Past task completions, examples, learned workflows |

```python
class TieredMemory:
    def __init__(self):
        self.in_context = []          # current messages
        self.session = SessionStore() # Redis
        self.long_term = VectorDB()   # Pinecone/Weaviate/pgvector
        self.episodic = EpisodicDB()  # past task completions

    def recall(self, query: str, tiers=["session", "long_term"]) -> list[Memory]:
        results = []
        if "session" in tiers:
            results.extend(self.session.get_relevant(query))
        if "long_term" in tiers:
            results.extend(self.long_term.search(query, top_k=5))
        if "episodic" in tiers:
            results.extend(self.episodic.find_similar_tasks(query, top_k=3))
        return deduplicate(results, key="content")
```

Retrieve memory **before** the agent starts working — not mid-task. Front-loading relevant memory prevents mid-loop context changes.

### 2. Context Window Management

The most common practical problem — context fills up in long conversations:

```python
def manage_context_window(messages: list, max_tokens: int = 6000) -> list:
    """Keep context within limits using priority-based pruning"""

    # Always keep: system prompt + last 5 messages + current user message
    must_keep = [messages[0]] + messages[-6:]
    middle = messages[1:-6]

    current_tokens = count_tokens(must_keep)

    if current_tokens < max_tokens:
        # Add middle messages until we approach limit
        for msg in reversed(middle):
            msg_tokens = count_tokens([msg])
            if current_tokens + msg_tokens < max_tokens * 0.85:
                must_keep.insert(1, msg)
                current_tokens += msg_tokens
    else:
        # Compress: summarize the middle section
        if middle:
            summary = summarize(middle)
            must_keep.insert(1, {
                "role": "system",
                "content": f"[Summary of earlier conversation: {summary}]"
            })

    return must_keep
```

**Strategies by situation:**
- Short conversations (<20 turns): keep everything, no pruning needed
- Medium (20-50 turns): sliding window — keep last N turns
- Long (50+ turns): summarize old + keep recent
- Very long (100+ turns): hierarchical summary (summary of summaries)

### 3. Long-Term Memory: What to Store

Not everything should be remembered. Use selective storage:

```python
def should_store_long_term(content: str, agent_output: str) -> bool:
    """Store only information that's useful across sessions"""
    store_triggers = [
        "user mentioned their name",
        "user stated a strong preference",
        "user corrected the agent",
        "user shared context about their role/company",
        "important decision was made",
        "user expressed frustration with agent behavior",
    ]
    # Use LLM to classify
    return llm_classify(content, store_triggers)

def store_user_fact(fact: str, user_id: str, confidence: float):
    long_term_db.upsert({
        "user_id": user_id,
        "fact": fact,
        "embedding": embed(fact),
        "confidence": confidence,
        "source": "agent_extraction",
        "created_at": now(),
        "last_accessed": now()
    })
```

**Memory decay:** Old, unaccessed memories should decay in confidence. Facts accessed frequently = higher confidence. Implement a cron job that reduces confidence by a small delta each week and prunes below a threshold (e.g., confidence < 0.2).

### 4. Episodic Memory: Past Tasks

Agents improve by referencing how similar tasks were completed:

```python
def store_completed_task(task_id, input, steps_taken, outcome, quality_score):
    episodic_db.insert({
        "task_id": task_id,
        "input_embedding": embed(input),
        "input_summary": summarize(input),
        "steps": steps_taken,
        "outcome": outcome,
        "quality_score": quality_score,
        "duration_seconds": elapsed,
        "tools_used": [s.tool for s in steps_taken],
    })

def recall_similar_tasks(current_input: str, top_k: int = 3) -> list[Episode]:
    query_embedding = embed(current_input)
    similar = episodic_db.search(query_embedding, top_k=top_k)
    # Use these as few-shot examples in the agent's context
    return similar
```

Only store completed tasks with quality_score above a threshold (e.g., > 0.7). Storing low-quality episodes teaches the agent bad patterns.

### 5. Memory for Multi-Agent Systems

When multiple agents share memory:

```python
class SharedAgentMemory:
    """Thread-safe shared memory for multi-agent systems"""

    def write(self, agent_id: str, key: str, value: Any, scope: str = "shared"):
        """scope: 'agent' (private) or 'shared' (all agents can read)"""
        memory_store.set(
            key=f"{scope}:{key}",
            value=value,
            metadata={"written_by": agent_id, "timestamp": now()}
        )

    def read(self, agent_id: str, key: str) -> Any:
        # Agents can always read shared scope
        # Can only read agent scope if agent_id matches
        return memory_store.get(f"shared:{key}") or \
               memory_store.get(f"{agent_id}:{key}")
```

**Multi-agent memory patterns:**
- **Blackboard**: shared workspace all agents read/write — simple but needs optimistic locking to prevent race conditions
- **Message passing**: agents communicate via explicit messages, not shared state — preferred for reliability
- **Hierarchical**: orchestrator owns memory, shares summaries with workers — good for privacy between agents

## Key Concepts

- **Context window** — tokens currently visible to the model; finite; expensive to fill
- **Sliding window** — keep only last N turns in context; simple but loses early context
- **Summarization** — compress old context into dense summary; loses detail, saves tokens
- **Episodic memory** — memories of specific past events (tasks completed, decisions made)
- **Semantic memory** — facts and knowledge (user preferences, domain knowledge)
- **Memory decay** — old unused memories lose confidence over time; prevents stale facts accumulating
- **Selective storage** — not every message is worth storing long-term; classify before storing
- **Mem0 / Letta** — production-ready frameworks for agent memory management

## Checklist

- [ ] In-context messages managed to stay within token budget?
- [ ] Summarization strategy defined for conversations >20 turns?
- [ ] Long-term memory stores only actionable facts (not everything)?
- [ ] Episodic memory recording completed tasks for few-shot retrieval?
- [ ] Memory retrieval happens before agent starts working (not mid-task)?
- [ ] Multi-agent systems use explicit shared memory with defined scope (not ad-hoc)?
- [ ] Memory decay implemented (old facts reduce in confidence over time)?
- [ ] GDPR compliance: user can request full memory deletion?
- [ ] Low-quality episodes excluded from episodic store?

## Key Outputs

- Memory architecture diagram: which tier, what's stored, how long, retrieval method
- Context management strategy: window size, pruning policy, summarization trigger threshold
- Storage schema for each tier: fields, indexes, retention policy, decay schedule

## Output Format

- 🔴 **Critical** — no context management (agent crashes on long conversations), storing every message verbatim long-term (expensive, noisy retrieval), no memory across sessions when the use case explicitly requires continuity
- 🟡 **Warning** — only in-context memory (restarts completely fresh each conversation), no summarization strategy for long conversations, multi-agent agents sharing memory without defined scope or synchronization
- 🟢 **Suggestion** — implement episodic memory for few-shot learning from past task completions, use Mem0/Letta for production-ready memory management rather than building from scratch

## Anti-Patterns

- **Storing every message verbatim long-term** — expensive, retrieval becomes noisy, important facts buried under chatter
- **No memory across sessions when users expect continuity** — breaks user experience, agent feels dumb and forgetful
- **Loading all long-term memories into context on every request** — context pollution; retrieve only what's relevant to the current query
- **Multi-agent systems reading/writing same key without synchronization** — race conditions cause inconsistent state
- **Never expiring memories** — stale facts accumulate and contradict new information (e.g., agent remembers old job title)
- **Summarizing too aggressively** — losing important details from early in a conversation that become relevant later
- **Storing low-quality episodic memories** — agent learns bad patterns from failed or mediocre task completions

## Integration

- Use with `agentic-ai-patterns` for understanding where memory fits in the observe-think-act agent loop
- Use with `rag-architecture` for vector search patterns in long-term memory retrieval
- Use with `llm-observability` to track memory hit rates, context window utilization, and retrieval latency
- Use with `agentic-security` — retrieved memories are external data and should be treated as untrusted if user-supplied
- Agent: `@ai-engineer` uses this when designing stateful agent systems
