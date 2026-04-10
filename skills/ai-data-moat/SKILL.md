---
name: ai-data-moat
description: Use when building defensibility into an AI product — designing data collection strategies that compound over time, domain-specific dataset building, proprietary data as competitive moat vs base models, and when data beats prompt engineering.
---

# AI Data Moat

## When to Use

- "What stops ChatGPT from just doing what we do?" — need a real answer
- Building on top of LLM APIs and worried about commoditization
- Designing data collection into product from day 1
- Deciding between RAG, fine-tuning, or prompt engineering approaches
- AI product defensibility assessment

## Core Jobs

### 1. Why 80% of AI Wrappers Will Die

The commoditization timeline:
```
Year 1 (2024): "We built X using GPT-4" — works, early movers win
Year 2 (2025): GPT-4 gets cheaper, Gemini/Claude match quality, copycats launch
Year 3 (2026): Base models add X as a native feature, wrapper products die

The survivors: products that built something base models CAN'T easily replicate
```

**The only durable moats for AI products:**
1. **Proprietary data** — training/fine-tuning data nobody else has
2. **Workflow integration** — so deeply embedded that switching costs are high
3. **Customer trust** — long-term relationship + personalization = irreplaceable context
4. **Network effects** — more users = better product (data network effects)

### 2. Data Collection Strategy by Product Type

**For B2B tools (highest moat potential):**
```python
# Every user interaction is training data — collect systematically
def log_ai_interaction(user_id, input, ai_output, user_action):
    training_db.insert({
        "user_id": user_id,
        "input": input,
        "ai_output": ai_output,
        "user_accepted": user_action == "accept",
        "user_edited": user_action == "edit",
        "final_output": get_final_output(),  # what user actually used
        "timestamp": now(),
        "metadata": get_user_context()  # role, company, industry
    })

# This becomes:
# 1. Fine-tuning dataset (accepted outputs = positive examples)
# 2. Preference data for RLHF (edited outputs show what good looks like)
# 3. Domain-specific benchmarks (what quality means in YOUR domain)
```

**For consumer tools (network effect potential):**
```
Collective intelligence strategy:
- Aggregate anonymized patterns across all users
- "Users who did X also found Y useful"
- "This type of content gets 3x more engagement on [platform]"
- Individual AI learns from collective knowledge without exposing individual data
```

### 3. When to Fine-Tune vs RAG vs Prompt Engineering

```
Decision matrix:

Prompt engineering (default — try first):
  Use when: You have <1000 examples, behavior can be described in text
  Cost: $0 (just tokens)
  Maintenance: Update prompt when behavior drifts
  Time to implement: Hours

RAG (for knowledge problems):
  Use when: Need to inject domain-specific knowledge at runtime
  Use when: Knowledge changes frequently (can't retrain)
  Cost: Embedding API + vector DB (~$50-200/month)
  Best for: Document Q&A, knowledge bases, up-to-date data
  Time to implement: 1-2 days

Fine-tuning (for style/behavior problems):
  Use when: You have >1000 high-quality examples
  Use when: Style/format consistency matters more than knowledge
  Use when: Need faster/cheaper inference (smaller model, same quality)
  Cost: $500-2000 for training run, cheaper per-token after
  Best for: Consistent output format, domain-specific tone, specialized tasks
  Time to implement: 1-2 weeks (data prep is 80% of work)

Hybrid (RAG + fine-tuned model):
  Use when: Need both knowledge and behavior consistency
  Most powerful but most complex
```

### 4. Building Domain-Specific Dataset (The Moat Construction)

Systematic data collection for competitive advantage:

```python
class DomainDatasetBuilder:
    """Build proprietary dataset through product usage"""

    def __init__(self, domain: str):
        self.domain = domain  # "legal", "finance", "marketing", etc.
        self.dataset = []

    def capture_positive_example(self, input, output, quality_score):
        """Capture when user accepts/keeps AI output"""
        if quality_score >= 4:  # user rated highly
            self.dataset.append({
                "type": "positive",
                "input": input,
                "output": output,  # what user actually used
                "domain": self.domain,
                "quality": quality_score
            })

    def capture_preference_pair(self, input, preferred_output, rejected_output):
        """When user edits AI output, you have a preference pair"""
        self.dataset.append({
            "type": "preference",
            "input": input,
            "preferred": preferred_output,  # user's version
            "rejected": rejected_output,    # AI's original version
            "domain": self.domain
        })

    def dataset_readiness(self):
        positives = len([d for d in self.dataset if d["type"] == "positive"])
        preferences = len([d for d in self.dataset if d["type"] == "preference"])
        print(f"Fine-tuning ready: {positives >= 1000} ({positives}/1000 positives)")
        print(f"RLHF ready: {preferences >= 500} ({preferences}/500 preferences)")
```

### 5. Data Network Effects

The most powerful moat — more users = better product:

```
Data network effect types:

Individual learning:
  Each user's data improves their own experience
  "The more you use it, the smarter it gets for you"
  Example: Gmail Smart Compose learns your writing style

Collective learning:
  All users' data improves everyone's experience
  "More users = better for everyone"
  Example: Waze (more drivers = better traffic prediction)

For AI products, aim for BOTH:
  Individual: Remember my preferences, my context, my past work
  Collective: Anonymized patterns make recommendations better for all
```

## Key Concepts

- **Data moat** — proprietary dataset that competitors can't replicate; primary defensibility
- **Preference pair** — (prompt, preferred output, rejected output) used for RLHF/fine-tuning
- **Data network effect** — product improves as more users contribute data
- **Fine-tuning** — training a base model on domain-specific examples to improve style/format
- **RAG** — injecting external knowledge at inference time; doesn't change model weights
- **Commoditization timeline** — API-wrapper products die when base models add native support

## Checklist

- [ ] Defensibility assessment: moat score ≥5 (data/workflow/trust/niche)?
- [ ] Every user interaction logging for potential training data (with consent)?
- [ ] Positive examples captured (high-quality accepted outputs)?
- [ ] Preference pairs captured (before/after when user edits AI output)?
- [ ] Fine-tuning vs RAG vs prompting decision made explicitly (based on data volume)?
- [ ] Data collection consent and privacy policy covers AI training use?
- [ ] Network effect designed: how does more users = better product?

## Key Outputs

- Moat assessment: where data advantage can be built (and timeline)
- Data collection schema: what to log, consent model, retention policy
- Dataset readiness tracker: progress toward fine-tuning threshold (1000+ examples)
- Technology decision: prompt / RAG / fine-tune recommendation with rationale

## Output Format

- 🔴 **Critical** — no data collection (every interaction lost), thin wrapper with no moat plan, competing on general capability with base models (unwinnable)
- 🟡 **Warning** — collecting data but not structuring for training use, moat score <5, no network effect designed into product
- 🟢 **Suggestion** — add thumbs up/down to every AI output (cheap data collection), collect preference pairs when users edit, design individual learning that compounds

## Anti-Patterns

- "We'll add data strategy later" (day 1 data is most valuable — users who leave take their data)
- Collecting data without consent (GDPR violation + trust destroyer)
- Building data moat in wrong area (data nobody needs → worthless fine-tuned model)
- Skipping prompt engineering → immediately jumping to fine-tuning (expensive, often unnecessary)
- No feedback mechanism (can't improve without knowing what good looks like)

## Integration

- Use with `rag-architecture` for building the knowledge layer on top of proprietary data
- Use with `ai-product-retention` (data personalization = retention mechanism)
- Use with `ai-product-positioning` (data moat = core of differentiation story)
- Agent: `@solo-ai-builder` assesses data moat before committing to product direction
