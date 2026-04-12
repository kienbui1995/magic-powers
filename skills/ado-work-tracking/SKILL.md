---
name: ado-work-tracking
description: Use when configuring Azure DevOps work tracking — boards setup, backlog configuration, sprint management, work item type customization, process templates, queries, and team area/iteration paths.
---

# ADO Work Tracking Configuration

## When to Use
- Setting up boards for a new team or project
- Configuring area paths and iteration paths (sprint schedule)
- Customizing work item types and workflows
- Creating shared queries for reporting
- Migrating between process templates

## Core Jobs

### 1. Area Paths & Team Configuration
```bash
# Create area path
az boards area project create \
  --name "Platform/Infrastructure" \
  --project MyProject

# Assign area to team
az boards area team add \
  --team "Platform Team" \
  --path "\MyProject\Platform\Infrastructure" \
  --include-sub-areas true \
  --project MyProject
```

**Structure:** Project → Areas → Team areas → Each team sees their subset of the board

### 2. Iteration Paths (Sprints)
```bash
# Create iteration (sprint)
az boards iteration project create \
  --name "Sprint 1" \
  --start-date 2026-04-14 \
  --finish-date 2026-04-25 \
  --path "\MyProject\2026" \
  --project MyProject

# Assign to team
az boards iteration team add \
  --team "Platform Team" \
  --id $ITERATION_ID \
  --project MyProject
```

### 3. Work Item Management
```bash
# Create work item
az boards work-item create \
  --title "Implement OAuth2 login" \
  --type "User Story" \
  --assigned-to user@company.com \
  --project MyProject \
  --fields "Microsoft.VSTS.Common.Priority=1" "System.Tags=auth;security"

# Update work item
az boards work-item update --id 1234 --state "Active" --assigned-to dev@company.com

# Query work items (WIQL)
az boards query --wiql "SELECT [Id],[Title],[State] FROM WorkItems WHERE [System.TeamProject] = 'MyProject' AND [State] <> 'Closed' ORDER BY [Priority]"
```

### 4. Process Template Customization (Inherited Process)
- Go to: Org Settings → Boards → Process → select template → customize
- Add custom fields: work item type → Layout → add field
- Add custom state: work item type → States → New state
- Cannot customize hosted XML processes (Agile/Scrum/CMMI) directly — must migrate to Inherited Process first

### 5. Shared Queries
```bash
# List queries
az boards query list --project MyProject --path "Shared Queries" --output table
```

Common useful queries:
- **Active bugs by priority**: `[Type] = 'Bug' AND [State] <> 'Closed' ORDER BY [Priority]`
- **Unassigned work**: `[Assigned To] = '' AND [State] = 'Active'`
- **Sprint work**: `[Iteration Path] = @CurrentIteration AND [Team Project] = @Project`

## Key Concepts
- **Area path** — hierarchical categorization (product area, team, component)
- **Iteration path** — time-boxed sprint schedule; teams subscribe to a subset
- **Process template** — defines work item types (User Story vs PBI vs Issue)
- **Inherited process** — customizable version of Agile/Scrum; create from base then customize
- **WIQL** — Work Item Query Language; SQL-like for querying work items

## Checklist
- [ ] Area paths created and assigned to teams (each team owns their area)?
- [ ] Iteration paths (sprints) created with start/end dates?
- [ ] Teams subscribed to their iteration paths?
- [ ] Inherited process used (not locked XML process) if customization needed?
- [ ] Shared queries created for common reports?

## Key Outputs
- Area paths organized by team/component with team assignments
- Sprint schedule created for next 3-6 months
- Custom work item fields for org-specific tracking needs
- Shared queries for sprint reporting and backlog health

## Output Format
- 🔴 **Critical** — all teams sharing same area path (no isolation), no iteration paths (no sprint planning possible)
- 🟡 **Warning** — customizing base Agile/Scrum process (use Inherited instead), no shared queries for reporting
- 🟢 **Suggestion** — create area hierarchy matching org structure, automate sprint creation with CLI

## Anti-Patterns
- One area path for all teams (board becomes unmanageable at scale)
- Customizing base process template instead of creating Inherited Process
- Not setting iteration dates (sprints without dates don't enable velocity tracking)

## Integration
- `ado-organization` — project and team creation before work tracking setup
- `ado-api-cli` — bulk work item creation, query automation, sprint management
