# Cloud Division Framework

Magic-powers Cloud Divisions provide role-specific agents and skills for cloud professionals,
aligned to official certification exam domains (GCP, AWS, Azure).

## Structure

```
agents/cloud/<provider>/<role>.md    # Agents
skills/cloud/<provider>/<skill>/     # Skills
```

## How to add a new cloud provider

1. Create `agents/cloud/<cloud>/` directory with 7 agent files
2. Create `skills/cloud/<cloud>/` with skill directories
3. Map each agent's skills to official cert exam domains (with % weights)
4. Add the provider to Step 1 of `commands/install-skills.md` under Cloud Divisions
5. Update `docs/OPTIONAL_SKILLS.md` with the new provider

## Standard 7 roles per provider

| Role | Model | Cert type |
|------|-------|-----------|
| data-engineer | sonnet | Data Engineering cert |
| cloud-developer | sonnet | Developer cert |
| network-engineer | sonnet | Networking cert |
| ml-engineer | sonnet | ML/AI cert |
| devops-engineer | sonnet | DevOps/Platform cert |
| security-engineer | sonnet | Security cert |
| cloud-architect / solutions-architect | opus | Architect cert |

## Agent frontmatter checklist

- [ ] `name`: `<cloud>-<role>` (kebab-case)
- [ ] `description`: includes exam name + code
- [ ] `model`: sonnet (all roles except architect → opus)
- [ ] `skills`: references `magic-powers:cloud/<cloud>/<skill>`
- [ ] Body: core services list, when-invoked steps, key trade-offs

## Skill sections checklist (required by validate-skills.sh)

- [ ] `## When to Use`
- [ ] `## Core Jobs` (map to exam domains with % weights)
- [ ] `## Key Concepts`
- [ ] `## Checklist`
- [ ] `## Exam Tips`
- [ ] `## Output Format` (🔴🟡🟢)
