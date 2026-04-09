---
name: what-would-lenny-do
description: Applies Lenny Rachitsky's product wisdom to your specific situation by searching his newsletter archive. Uses mcp__Amplitude__search.
---

# What Would Lenny Do?

## When to Use

- You are facing a product decision and want a framework-grounded perspective
- You need to benchmark your metrics against industry standards Lenny has published
- A growth, retention, or monetization problem needs a structured mental model
- You want to know what successful companies have done in similar situations
- Preparing for a product review and want to cite credible external frameworks
- You're stuck on pricing, activation, or retention strategy and want expert perspective

## Core Jobs

### Phase 1: Clarify the Product Question or Situation
Before searching, crystallize the question. Vague questions produce vague answers.

Turn the user's situation into a specific, answerable question:
- Not: "our retention isn't great"
- Yes: "Our D30 retention is 18% for B2C mobile. What does Lenny say about good D30 benchmarks for consumer apps, and what levers have worked?"

Consider which Lenny topic areas are most relevant:
- **Growth**: acquisition channels, growth loops, viral coefficients, referral programs
- **Retention**: habit loops, D1/D7/D30 benchmarks by category, onboarding optimization
- **Metrics**: what good looks like by product category (consumer vs B2B, marketplace vs SaaS)
- **Activation**: aha moment design, time-to-value, activation rate benchmarks
- **Pricing**: pricing models, packaging, freemium vs free trial decisions
- **Strategy**: sequencing markets, picking battles, when to say no
- **Team**: PM career development, cross-functional dynamics, stakeholder management

### Phase 2: Search Lenny's Archive for Relevant Content
Use `mcp__Amplitude__search` with multiple search terms to find relevant Lenny newsletter content. Search broadly across different framings of the same question:

- Try the core concept: "retention", "D30 retention", "consumer retention benchmarks"
- Try the problem framing: "users churning", "low engagement", "habit formation"
- Try the solution space: "onboarding", "activation", "habit loop", "engagement loops"
- Try company examples: Duolingo, Slack, Notion, Figma, Linear — Lenny often uses specific examples

Run 2-3 different searches to maximize coverage. Look for newsletter articles, podcast summaries, and framework posts.

### Phase 3: Synthesize Relevant Frameworks and Mental Models
From the search results, extract:

- **Benchmarks**: specific numbers Lenny has published for the relevant category (e.g., "good D30 for social apps is 25%+")
- **Frameworks**: named mental models Lenny uses (e.g., "the three-step activation framework," "the retention curve")
- **Company examples**: what specific companies did in similar situations and what happened
- **Counterintuitive advice**: the non-obvious recommendations Lenny is known for

Prioritize concrete, specific guidance over general principles. Lenny's value is in specificity.

### Phase 4: Apply to the Specific Context
Map the generic framework to the user's specific situation:

- "Lenny's benchmark for this category is X. Your current metric is Y. That means you are Z% below/above the benchmark."
- "The framework suggests doing A, B, C in sequence. In your situation, you are at step B, so the next priority is C."
- "Company X faced a similar situation and did [specific action]. The outcome was [specific result]. Your situation differs in [key way], which means [adjustment]."

Do not just summarize Lenny — apply the frameworks to the actual numbers and context the user has shared.

### Phase 5: Provide Concrete Recommendation
Conclude with a specific, actionable recommendation in Lenny's voice:

Format: **"Here's what Lenny would say:"**

Then provide:
1. The most relevant benchmark or framework from the archive
2. The specific recommendation for the user's situation
3. The first concrete action to take this week
4. One thing Lenny would warn against (what not to do)

Cite the specific Lenny content (article title or podcast episode) that grounds the recommendation.

## MCP Tools

- `mcp__Amplitude__search` — search Lenny's newsletter and podcast archive for relevant content
- `mcp__Amplitude__get_context` — get project context if combining with Amplitude data analysis

## Key Concepts

- **Lenny Rachitsky**: Former Airbnb PM and growth lead; author of the Lenny's Newsletter, one of the most-read product newsletters. Known for benchmarks, frameworks, and practical PM advice.
- **Benchmark**: An industry standard for what "good" looks like for a specific metric in a specific product category. Benchmarks vary significantly by category (B2B vs B2C, marketplace vs SaaS, consumer vs enterprise).
- **Mental model**: A framework for thinking about a class of problems (e.g., "jobs to be done," "activation moment," "North Star framework").
- **Activation moment**: The first moment a new user experiences the core value of the product — often the most important event to optimize.
- **Engagement loop**: A cyclical pattern of behavior that brings users back to the product repeatedly (notification → open → action → reward → notification).
- **Retention curve**: The graph of what % of users from a cohort are still active over time. A flattening curve is the goal.

## Output Format

The output starts with a one-paragraph framing of the question and which area of Lenny's thinking is most relevant.

Then: **"Here's what Lenny would say:"** followed by the synthesized recommendation. This section is written in first-person Lenny voice where appropriate — direct, specific, benchmark-grounded.

End with:
- The specific Lenny content cited (article name or episode)
- One concrete action to take this week
- One warning (what not to do)

Length: 300-500 words. Specific and actionable, not a summary of everything Lenny has ever said about the topic.
