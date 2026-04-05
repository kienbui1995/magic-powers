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
