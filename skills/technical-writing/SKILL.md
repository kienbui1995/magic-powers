---
name: technical-writing
description: Use when writing documentation, READMEs, API docs, changelogs, ADRs, or user guides — ensures clarity, structure, and project consistency
---

# Technical Writing

## When to Use
When creating or updating any documentation: README, API docs, architecture decision records, changelogs, user guides, onboarding docs.

## Process

1. **Read context** — scan existing docs, code, and conventions
2. **Identify audience** — developers, end users, or ops?
3. **Choose format** — README, ADR, API reference, tutorial, changelog
4. **Write draft** — structure first, content second
5. **Verify examples** — all code snippets must be runnable

## Documentation Formats

### README
- Project name + one-line description
- Install / quickstart (copy-pasteable)
- Usage examples
- Configuration reference
- Contributing link

### API Reference
- Endpoint, method, path
- Request: headers, params, body (with types)
- Response: status codes, body schema, examples
- Error codes and meanings

### ADR (Architecture Decision Record)
- **Status**: Proposed / Accepted / Deprecated
- **Context**: What problem are we solving?
- **Decision**: What did we choose?
- **Consequences**: Trade-offs, risks, follow-ups

### Changelog (Keep a Changelog)
- `Added` / `Changed` / `Deprecated` / `Removed` / `Fixed` / `Security`
- Most recent version first
- Link to diff between versions

## Rules
- Match existing project tone and terminology
- Prefer examples over explanations
- Keep sentences under 25 words
- Use active voice
- One idea per paragraph
- Use tables for structured data, lists for sequences
