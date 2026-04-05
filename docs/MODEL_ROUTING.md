# Model Routing Guide

Magic Powers includes skill-based model routing (Opus/Sonnet/Haiku). For **actual API-level cost savings**, combine with Claude Code Router or OpenRouter.

## Option 1: Claude Code Router (CCR)

CCR is an open-source proxy that routes Claude Code requests to cheaper models.

### Setup

```bash
# Install
git clone https://github.com/musistudio/claude-code-router
cd claude-code-router
npm install

# Configure (.env)
OPENROUTER_API_KEY=sk-or-...
DEFAULT_MODEL=anthropic/claude-sonnet-4
SMALL_MODEL=google/gemini-2.5-flash
```

### Start

```bash
npm start
# Proxy runs on http://localhost:4000

# Point Claude Code to it
export ANTHROPIC_BASE_URL=http://localhost:4000
claude
```

### Routing Rules

| Task | Model | Cost vs Opus |
|------|-------|-------------|
| Architecture, complex design | Claude Sonnet 4 | ~80% cheaper |
| Implementation, debugging | Gemini 2.5 Flash | ~95% cheaper |
| Code review, formatting | Gemini 2.5 Flash | ~95% cheaper |

## Option 2: OpenRouter Direct

No proxy needed — use OpenRouter as the API provider.

### Setup

```bash
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=sk-or-...
claude
```

### Model Selection

Access 400+ models through one API key. Best cost-effective alternatives:

| Use Case | Model | Input $/M tokens |
|----------|-------|-------------------|
| Complex reasoning | `anthropic/claude-sonnet-4` | $3.00 |
| General coding | `google/gemini-2.5-flash` | $0.15 |
| Fast tasks | `google/gemini-2.5-flash` | $0.15 |
| Budget mode | `deepseek/deepseek-chat-v3` | $0.27 |

## Combined with Magic Powers

Magic Powers' `cost-aware-routing` skill tells agents which model tier to use. Combined with CCR/OpenRouter, you get:

1. **Skill-level routing** — Magic Powers picks the right agent (Opus/Sonnet/Haiku tier)
2. **API-level routing** — CCR/OpenRouter routes to the cheapest capable model

**Result: 80-95% cost reduction vs default Claude Opus.**

## Quick Start

```bash
# 1. Get OpenRouter key from https://openrouter.ai
# 2. Set environment
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=sk-or-your-key

# 3. Use Claude Code with Magic Powers as normal
claude
```

That's it. All Magic Powers skills and agents work unchanged.
