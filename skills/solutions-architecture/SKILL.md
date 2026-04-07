---
name: solutions-architecture
description: Use when designing pre-sales architectures, creating technical proposals, or helping customers integrate your platform
---

# Solutions Architecture

## When to Use
When working with prospects or customers to design how your platform fits into their technical environment — pre-sales, implementation planning, or technical advisory.

## Core Jobs

### 1. Discovery Call Architecture Intake
Questions to ask before designing anything:
- Current stack (languages, cloud, databases, auth systems)
- Scale requirements (current and projected users/transactions)
- Data sensitivity (PII? PHI? compliance requirements?)
- Integration requirements (what systems must connect?)
- Team capability (who will implement and maintain?)
- Timeline and phasing

### 2. Design the Architecture
Produce a reference architecture diagram:
- Data flow (where does data come from, go to, get processed?)
- Integration points (APIs, webhooks, SDKs, ETL)
- Security boundary (what's in their infra vs yours)
- Network topology (VPC peering, private link, or public API?)
- Scalability approach (how does it grow with them?)

### 3. Technical Proposal
Document:
- Proposed architecture with diagram
- Implementation phases (Phase 1: core integration, Phase 2: advanced features)
- Effort estimate (T-shirt: S/M/L per phase, not days)
- Open questions and risks
- Success criteria

### 4. Handle Objections
Common technical objections:
- "We can build this ourselves" → TCO analysis, time-to-market
- "We have security concerns" → security architecture review, compliance docs
- "It won't scale" → reference customers at similar scale, benchmark data
- "Integration is too complex" → PoC offer, professional services

## Key Outputs
- Architecture diagram
- Technical proposal document
- Integration guide
- Risk and open questions log

## Anti-Patterns
- Designing without understanding their constraints
- One-size-fits-all architecture for all customers
- Proposal with no phasing (overwhelming scope)
- Not addressing security and compliance upfront for regulated industries
