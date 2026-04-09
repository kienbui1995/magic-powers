---
name: prompt-engineering
description: Use when designing, testing, or versioning LLM prompts - covers few-shot, chain-of-thought, structured output, prompt templates, and systematic testing
---

# Prompt Engineering

## Overview

Prompts are code. Version them, test them, review them. A 10-minute prompt improvement often beats a 10-hour code change.

## When to Use

- Designing prompts for LLM features
- Debugging inconsistent AI outputs
- Optimizing prompt cost (fewer tokens, same quality)
- Setting up prompt versioning and testing

## Prompt Design Framework

```
1. Define the task clearly (what, not how)
2. Add constraints (format, length, tone)
3. Provide examples (few-shot)
4. Add reasoning instructions (chain-of-thought)
5. Test with edge cases
6. Measure and iterate
```

## Core Techniques

### System Prompt Structure
```
Role: Who the AI is
Context: What it knows
Task: What to do
Constraints: What NOT to do
Output format: How to respond
```

## Tool Use Prompts

Agents call tools based on how they're described. Tool description quality is as important as the prompt itself:

```python
# ❌ Vague tool description — agent may call incorrectly or not at all
tools = [{
    "name": "search",
    "description": "Search for information"
}]

# ✅ Precise tool description — clear when to use, what to expect back
tools = [{
    "name": "web_search",
    "description": "Search the web for current information. Use when the user asks about recent events, current prices, or information that may have changed. Returns: list of {title, url, snippet}. Do NOT use for historical facts or mathematical calculations.",
    "parameters": {
        "query": {"type": "string", "description": "Search query. Be specific and concise. Max 100 chars."}
    }
}]
```

**Tool description best practices:**
- State exactly WHEN to use the tool (and when NOT to)
- Describe the return format so agent can parse it
- Use exclusive descriptions — no two tools should sound interchangeable
- Add examples for ambiguous tools: `"Example: query='Apple stock price today'"`

**Parallel tool calls (when supported):**
```python
# System prompt instruction for parallel tool use
system = """When multiple independent pieces of information are needed, 
call tools in parallel rather than sequentially. For example, if asked to 
compare two companies, retrieve both company profiles simultaneously."""
```

### Few-Shot (show, don't tell)
```
Extract entities from text.

Input: "John bought 3 apples at Walmart"
Output: {"person": "John", "quantity": 3, "item": "apples", "store": "Walmart"}

Input: "Sarah ordered 2 coffees from Starbucks"
Output: {"person": "Sarah", "quantity": 2, "item": "coffees", "store": "Starbucks"}

Input: {user_input}
Output:
```

### Chain-of-Thought
```
Think step by step:
1. First, identify...
2. Then, evaluate...
3. Finally, decide...
```

## Extended Thinking & Reasoning Models

For complex reasoning tasks (math, logic, multi-step planning), use extended thinking:

```python
# Claude extended thinking
response = client.messages.create(
    model="claude-opus-4-5",
    max_tokens=16000,
    thinking={"type": "enabled", "budget_tokens": 10000},
    messages=[{"role": "user", "content": "Analyze this complex architecture..."}]
)
# Access thinking: response.content[0].thinking
# Access answer: response.content[1].text
```

**When to use extended thinking:**
- Multi-step math or logic problems
- Complex architectural decisions with many trade-offs
- Tasks requiring deep planning before execution
- Problems where chain-of-thought alone is insufficient

**Prompting reasoning models differently:**
- Keep system prompts concise (reasoning models add their own structure)
- Avoid telling the model HOW to think — just describe WHAT to solve
- Don't pre-structure the reasoning with "Step 1: ... Step 2: ..."
- Do specify output format for the final answer (not for intermediate reasoning)

**Cost note:** Extended thinking uses budget_tokens that count toward total tokens. Set budget based on task complexity — 2000 tokens for medium, 10000 for complex.

### Structured Output
```
Respond in JSON matching this schema:
{"answer": string, "confidence": number 0-1, "reasoning": string}
```

## Prompt Versioning

```
prompts/
├── classify-intent/
│   ├── v1.md          # Original
│   ├── v2.md          # Added few-shot examples
│   ├── v3.md          # Reduced tokens by 40%
│   └── eval-results.json
```

- Store prompts as files, not inline strings
- Version with git, tag releases
- Track eval scores per version
- A/B test in production before full rollout

## Testing Prompts

| Test Type | What | When |
|-----------|------|------|
| **Golden set** | 20-50 curated input/output pairs | Every prompt change |
| **Edge cases** | Empty input, adversarial, multilingual | Before production |
| **Regression** | Previous failures that were fixed | CI pipeline |
| **Cost check** | Token count per call | Every version |

## Multi-Turn & RAG Context Prompts

**Multi-turn conversation management:**
```python
# Prune history to stay within context limits
def build_messages(history, user_input, max_tokens=6000):
    system = [{"role": "system", "content": SYSTEM_PROMPT}]
    
    # Always include: system + recent 10 messages + current input
    recent = history[-10:] if len(history) > 10 else history
    
    # If still over budget, summarize older messages
    all_messages = system + recent + [{"role": "user", "content": user_input}]
    if count_tokens(all_messages) > max_tokens:
        summary = summarize_history(history[:-10])
        all_messages = system + [
            {"role": "assistant", "content": f"[Previous context: {summary}]"}
        ] + recent + [{"role": "user", "content": user_input}]
    
    return all_messages
```

**RAG context formatting in prompts:**
```
# Order retrieved context for best use of attention
system = """Answer based on the provided context. If the context doesn't 
contain the answer, say so — don't guess.

Context (most relevant first):
{retrieved_chunks}

If citing information, reference the source: [Source: {source_name}]"""
```

**RAG prompt best practices:**
- Put context BEFORE the question (not after) — models attend better to earlier content
- Mark context boundaries clearly (`<context>...</context>` or labeled sections)
- Explicitly instruct: "Only use information from the context above"
- Include source attribution instructions for trust/transparency

## Anti-Patterns

| Pattern | Fix |
|---------|-----|
| Prompt in code as string literal | Extract to versioned file |
| "Be helpful and accurate" | Specific instructions with examples |
| No testing | Golden set + regression suite |
| Mega-prompt (2000+ tokens) | Split into focused sub-prompts |
| Prompt works on GPT-4 only | Test across models you might switch to |

## Integration

- **magic-powers:llm-evaluation** — measure prompt quality systematically
- **magic-powers:ai-safety-guardrails** — add safety constraints to prompts
- **magic-powers:cost-aware-routing** — optimize prompt token cost
