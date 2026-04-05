---
name: ai-safety-guardrails
description: Use when adding safety layers to AI features - output validation, hallucination detection, content filtering, PII redaction, input sanitization
---

# AI Safety & Guardrails

## Overview

LLMs will confidently produce harmful, incorrect, or leaked content if you don't add guardrails. Every AI feature needs input validation, output validation, and fallback behavior.

## When to Use

- Shipping any user-facing AI feature
- Handling sensitive data (PII, financial, medical)
- Building AI features for regulated industries
- After finding hallucination or safety issues in production

## Guardrail Layers

```
User Input → Input Guard → LLM → Output Guard → User
                ↓                      ↓
           Block/sanitize         Validate/filter
```

### 1. Input Guards

| Guard | What | Implementation |
|-------|------|----------------|
| Prompt injection detection | Block "ignore instructions" attacks | Classifier or regex filter |
| Input length limit | Prevent context stuffing | Max token count |
| PII detection | Redact before sending to LLM | Regex + NER model |
| Topic filtering | Block off-topic requests | Classifier |

### 2. Output Guards

| Guard | What | Implementation |
|-------|------|----------------|
| Hallucination check | Verify claims against source | Cross-reference with retrieved docs |
| PII leak detection | Catch leaked personal data | Regex scan on output |
| Format validation | Ensure JSON/structured output | Schema validation |
| Toxicity filter | Block harmful content | Classifier (Perspective API, etc.) |
| Confidence threshold | Reject low-confidence answers | "I don't know" fallback |

### 3. Fallback Behavior

```
IF output fails any guard:
  → Don't show raw LLM output
  → Return safe fallback: "I'm not sure about that. Let me connect you with support."
  → Log the failure for review
```

## Hallucination Mitigation

1. **Ground in data** — RAG with "answer only from context" instruction
2. **Ask for citations** — "Quote the source for each claim"
3. **Self-consistency** — Run 3x, keep only consistent answers
4. **Confidence scoring** — LLM rates its own confidence, filter low scores
5. **Human review** — Flag uncertain outputs for human verification

## PII Handling

```
Before LLM:  "John Smith (john@email.com) ordered..."
Redacted:    "[NAME] ([EMAIL]) ordered..."
After LLM:   Re-inject PII only if needed in response
```

- Never send raw PII to third-party LLM APIs unless contractually allowed
- Log redacted versions only
- Use Microsoft Presidio or AWS Comprehend for detection

## Checklist

- [ ] Input length limits enforced
- [ ] Prompt injection detection active
- [ ] Output format validated (JSON schema, etc.)
- [ ] PII redacted before LLM call (if using third-party API)
- [ ] Hallucination check for factual claims
- [ ] Toxicity filter on user-facing output
- [ ] Fallback response for guard failures
- [ ] All guard failures logged for review

## Integration

- **magic-powers:prompt-engineering** — build safety into prompts
- **magic-powers:llm-evaluation** — measure guardrail effectiveness
- **magic-powers:security-review** — audit AI security posture
- **magic-powers:llm-observability** — monitor guard trigger rates
