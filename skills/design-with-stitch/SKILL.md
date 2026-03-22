---
name: design-with-stitch
description: Use when creating UI designs, mockups, or prototypes - integrates Google Stitch SDK for visual design generation
---

# Design with Stitch

## Overview

Use Google Stitch to generate visual designs and extract implementable HTML. Stitch creates mockups from text prompts — Claude Code can then read the HTML output and implement it.

**Key insight:** Claude Code can't see images, but CAN read HTML. Stitch generates both.

## Prerequisites

- Stitch SDK installed: `npm install @google/stitch-sdk`
- `STITCH_API_KEY` environment variable set
- Wrapper script at `scripts/stitch.mjs` (included in this plugin)

## The Design Flow

```
1. Brainstorm design requirements
2. Generate mockup with Stitch
3. Extract HTML from Stitch
4. Review and refine HTML
5. Implement in your framework
```

### Step 1: Generate a Screen

```bash
cd ~/.claude/scripts  # or plugin scripts dir
node stitch.mjs generate <project-id> "A dashboard with sidebar navigation, user stats cards, and a data table"
```

### Step 2: Get HTML Output

```bash
node stitch.mjs get-html <project-id> <screen-id>
```

This returns HTML that Claude Code can read and understand — layout, components, colors, typography.

### Step 3: Review and Iterate

```bash
# Edit existing screen
node stitch.mjs edit <project-id> <screen-id> "Make the sidebar collapsible and add dark mode toggle"

# Generate variants
node stitch.mjs variants <project-id> <screen-id> "Try different color schemes"
```

### Step 4: Implement

Use the HTML as reference to implement in your framework. The HTML shows:
- Component structure and hierarchy
- Color values and typography
- Layout and spacing
- Interactive elements

## Stitch SDK Commands

| Command | Description |
|---------|-------------|
| `list-projects` | List all Stitch projects |
| `list-screens <projectId>` | List screens in a project |
| `generate <projectId> "<prompt>"` | Generate new screen |
| `get-html <projectId> <screenId>` | Get HTML output |
| `edit <projectId> <screenId> "<prompt>"` | Edit existing screen |
| `variants <projectId> <screenId> "<prompt>"` | Generate design variants |

## Integration with UI UX Pro Max

If you have the UI UX Pro Max skill installed (project-level), combine:

1. **Stitch** → generates visual mockup
2. **UI UX Pro Max** → provides design system rules (colors, fonts, spacing)
3. **Implementation** → build with both references

```bash
# Get design system rules
python3 .claude/skills/ui-ux-pro-max/scripts/search.py palette modern
python3 .claude/skills/ui-ux-pro-max/scripts/search.py font clean

# Generate Stitch mockup following those rules
node stitch.mjs generate <project-id> "Dashboard using [palette] colors and [font] typography"
```

## Model Routing

This skill is best used with the **ui-designer agent** (Sonnet) which has Stitch integration and frontend design expertise.
