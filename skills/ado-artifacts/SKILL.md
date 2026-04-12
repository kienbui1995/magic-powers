---
name: ado-artifacts
description: Use when managing Azure Artifacts — feed creation and permissions, upstream sources, retention policies, package promotion across views, and connecting build pipelines to artifact feeds.
---

# ADO Artifacts Feed Management

## When to Use
- Creating artifact feeds for npm, NuGet, Maven, Python, or Universal packages
- Configuring upstream sources (npm, PyPI, Maven Central, NuGet.org)
- Setting feed permissions and visibility
- Implementing retention policies to control storage costs
- Promoting packages between views (prerelease → release)

## Core Jobs

### 1. Feed Creation & Configuration
```bash
# Publish a Universal Package to a feed
az artifacts universal publish \
  --organization https://dev.azure.com/MyOrg \
  --project MyProject \
  --scope project \
  --feed MyFeed \
  --name my-package \
  --version 1.0.0 \
  --path ./dist
```

**Feed scope:**
- **Project-scoped** — isolated to project, better access control
- **Organization-scoped** — shared across all projects (use for shared libraries)

**Views:** `@local` (all versions) → `@prerelease` (tested) → `@release` (production-ready). Promote packages between views as quality gates.

### 2. Upstream Sources
Configure via UI: Feed → Settings → Upstream sources → Add upstream

**Common upstreams:**
| Package type | Upstream | Use |
|-------------|---------|-----|
| npm | npmjs.com | Public npm packages |
| NuGet | NuGet Gallery | Public .NET packages |
| PyPI | pypi.org | Public Python packages |
| Maven | Maven Central | Public Java packages |

**Key benefit:** Developers use ONE feed URL, packages from upstream auto-cached. Enables audit and governance of public package versions.

### 3. Permissions
Feed permissions levels:
- **Owner** — full control (feed settings, delete)
- **Contributor** — publish packages
- **Collaborator** — save packages from upstream
- **Reader** — install packages only

```
Best practice:
  Build service account  →  Contributor (publish from CI)
  Developers             →  Collaborator or Reader
  Admins only            →  Owner
```

### 4. Retention Policies
Configure: Feed → Settings → Retention policies
- Set max versions per package (e.g., 10 latest)
- Auto-delete older versions
- Does NOT delete packages in `@release` view (protected)

### 5. Connect Pipeline to Feed
```yaml
# azure-pipelines.yml
- task: NuGetAuthenticate@1
- task: NuGetCommand@2
  inputs:
    command: restore
    feedsToUse: select
    vstsFeed: 'MyProject/MyFeed'
```

## Key Concepts
- **Feed** — package repository; project or org scoped
- **View** — subset of feed packages at a quality level (@local, @prerelease, @release)
- **Upstream source** — proxy to public registry; caches packages for audit and reliability
- **Promotion** — moving a package to a higher quality view (prerelease → release)
- **Retention policy** — auto-cleanup of old package versions

## Checklist
- [ ] Project-scoped feeds for team isolation, org-scoped for shared libraries?
- [ ] Upstream sources configured (developers use only feed URL, not direct public registry)?
- [ ] Build service has Contributor, developers have Reader/Collaborator?
- [ ] Retention policy set to prevent storage bloat?
- [ ] Release view protected from auto-deletion?

## Key Outputs
- Feeds created with correct scope and permissions
- Upstream sources configured for all package types used
- Retention policies preventing unbounded storage growth
- Pipeline authentication to feeds configured

## Output Format
- 🔴 **Critical** — no upstream sources (developers using public registries directly — supply chain risk), build service has Owner role
- 🟡 **Warning** — no retention policy (storage costs grow unboundedly), org-scoped feed when project isolation needed
- 🟢 **Suggestion** — use views for quality gates (prerelease/release), automate package promotion in release pipeline

## Anti-Patterns
- Developers configuring .npmrc/.nuget to pull from public registries directly (bypasses feed, supply chain risk)
- No retention policy on feeds with frequent publishing (GB of storage wasted)
- Single feed for all package types and teams (poor governance)

## Integration
- `ado-pipelines-ops` — pipeline service connections used to authenticate to feeds
- `ado-security-policies` — feed permissions align with project security model
- `ado-api-cli` — automate package publishing and promotion
