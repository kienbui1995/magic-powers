---
name: analyze-account-health
description: B2B account health assessment covering usage patterns, expansion risk, and growth opportunities. Uses mcp__Amplitude__get_users, mcp__Amplitude__query_amplitude_data.
---

# Analyze Account Health

## When to Use

- A customer success manager needs a data-driven health check before a QBR or renewal conversation
- An account shows signs of risk (decreased login frequency, support tickets, low feature adoption)
- A sales team wants to identify expansion opportunities within an existing account
- Triaging a list of accounts to determine which need proactive outreach
- Preparing for an upsell conversation and need to understand current usage depth

## Core Jobs

### Step 1: Account Identification
Find the account using `mcp__Amplitude__get_users` with identifiers provided by the requester:

- Account/company name
- Domain (e.g., @company.com)
- Account ID from your CRM
- Known user email addresses

Retrieve the full list of user profiles associated with this account. Note the total user count, when accounts were created, and any user properties that indicate role or plan tier.

If user profiles are sparse or the account is hard to identify, ask the requester for the organization ID or a specific admin email as an anchor.

### Step 2: Health Triage — Key Health Signals
Use `mcp__Amplitude__query_amplitude_data` to compute the core health signals. For each signal, assess: Green (healthy), Yellow (monitor), or Red (at risk).

**Health signal thresholds (adjust to your product's benchmarks):**

| Signal | Green | Yellow | Red |
|--------|-------|--------|-----|
| DAU/MAU ratio | >0.20 | 0.10-0.20 | <0.10 |
| Weekly active users / total licensed users | >60% | 30-60% | <30% |
| Feature breadth (features used in last 30d) | Top 50% of accounts | Middle 25% | Bottom 25% |
| Activity trend (last 30d vs prior 30d) | Up or stable | -10% to 0% | <-10% |
| Days since last active session (power users) | <3 | 3-7 | >7 |

Also check: any error events, export failures, or API error patterns that suggest technical friction.

### Step 3: User-Level Analysis
Go below account-level to understand who is active and who is dormant:

- **Champions**: users with the highest activity. These are the internal advocates — who are they, what roles/titles do they have, how often do they log in?
- **Dormant users**: licensed users who haven't logged in for 14+ days. What percentage of licensed seats are dormant?
- **New users**: have any new users joined recently? Are they activating?
- **Admin usage**: is the admin user active? Admin inactivity is a strong churn signal for B2B products.

For each champion, note: their activity level, which features they use most, and whether their usage is growing or declining.

### Step 4: Feature Usage Analysis
Understand which features drive stickiness vs which are underutilized:

**Sticky features**: features used frequently by champions. High usage of sticky features correlates with retention and expansion.

**Underutilized features**: features the account has access to but rarely uses. These represent:
- (a) Features that don't fit the account's use case (low priority to push)
- (b) Features with potential value the account hasn't discovered (high priority for customer success outreach)

Distinguish between the two by looking at whether similar accounts in the same segment heavily use these features. If yes, this account has an adoption gap worth addressing.

**Usage depth indicators**:
- Are they using advanced features (suggests sophistication, lower churn risk)?
- Are they at capacity limits (suggests expansion opportunity)?
- Are they integrating with other tools (high switching cost = lower churn risk)?

### Step 5: Expansion Indicators
Look for signals that suggest the account is ready for expansion:

- **Usage approaching limits**: seat count nearing plan limit, API call volume near quota, storage near cap
- **High-value feature adoption**: adoption of features associated with higher plan tiers
- **Department spread**: are users from multiple departments or teams? Cross-departmental usage is a strong expansion signal
- **Project/workspace growth**: is the number of active projects or workspaces growing over time?
- **Integration depth**: how many integrations are connected? More integrations = higher switching cost and more embedded use case

For each expansion signal, estimate the expansion opportunity: what plan upgrade or add-on is most appropriate?

## MCP Tools

- `mcp__Amplitude__get_users` — find user profiles associated with the account
- `mcp__Amplitude__query_amplitude_data` — compute usage metrics, DAU/MAU, feature adoption
- `mcp__Amplitude__get_session_replays` — review sessions of churning or struggling users (optional)
- `mcp__Amplitude__get_feedback_insights` — surface any feedback from this account's users
- `mcp__Amplitude__get_context` — get projectId and organization context (always first)

## Key Concepts

- **DAU/MAU ratio**: Daily active users divided by monthly active users. A higher ratio indicates more habitual usage. >0.20 is generally healthy; <0.10 suggests occasional-only use.
- **Seat utilization**: The percentage of licensed users who are actually active. Low seat utilization is a leading indicator of downsell risk at renewal.
- **Champion**: A power user who gets the most value from the product and likely advocates for it internally. Champion activity is a proxy for the account's overall health.
- **Stickiness features**: Features that, when adopted, are associated with significantly lower churn rates. Usually features that embed the product into workflows or integrate with other tools.
- **Adoption gap**: A feature the account has access to but doesn't use, when similar accounts heavily use it. Represents a customer success opportunity.
- **Expansion signal**: A quantitative indicator that the account is ready to buy more (more seats, higher plan, add-ons). Usage approaching limits is the strongest expansion signal.
- **Health score**: A single composite metric (Green/Yellow/Red or 0-100) that summarizes the overall account health for triage and prioritization.

## Output Format

The output is structured for a customer success or account management audience — practical and action-oriented.

Structure:
1. **Health score** (prominent, at the top): Green / Yellow / Red with a 1-sentence rationale.
2. **Account summary** (3-4 sentences): account name, size (licensed seats), active seats, account age, plan tier.
3. **Key health signals** (table): DAU/MAU, seat utilization, feature breadth, activity trend — each with Green/Yellow/Red status.
4. **Champion profiles** (bullet list): top 2-3 users, their activity level, roles if known.
5. **Top 3 risks** (numbered): specific, quantified risks with recommended action for each.
6. **Top 3 growth signals** (numbered): specific expansion indicators with recommended conversation starter or action.
7. **Recommended next step** (1 sentence): the most important action the CSM or AE should take in the next 5 business days.
