---
name: design-with-pencil
description: Use when creating UI designs with Pencil — the MCP-native canvas that lives in your repo. Requires Pencil extension installed in your IDE.
---

# Design with Pencil

Pencil is an agent-driven MCP canvas that lets you design on an infinite canvas and generate pixel-perfect code — directly inside your IDE, with `.pen` files stored in your repo.

## Prerequisites

1. **Install Pencil extension** in your IDE:
   - VS Code: search "Pencil" in Extensions (`highagency.pencildev`)
   - Cursor: search "Pencil" in Extensions
   - Or download the desktop app from [pencil.dev](https://pencil.dev)

2. **Ensure Claude Code is logged in** — Pencil's AI features require it

3. **Verify MCP connection**:
   - In Cursor: Settings → Tools & MCP → check Pencil appears
   - In Codex: run `/mcp` to see Pencil in the list

## Workflow

### 1. Create a design file
```bash
# Create a .pen file in your project
touch designs/my-component.pen
# Open it — Pencil canvas opens automatically
```

### 2. Design on canvas
Describe what you want in the Pencil prompt box:
- "Design a dashboard with sidebar navigation and data cards"
- "Design a mobile app login screen, minimalist style"
- "Design a landing page for a SaaS product, dark theme"

Or import from Figma: copy elements → paste directly into Pencil canvas.

### 3. Iterate with AI
From the Pencil canvas, prompt changes directly:
- "Change to light mode"
- "Make the headline larger, Swiss layout"
- "Explore a totally different direction"
- "Use a sidenav instead"

### 4. Generate code from design
Ask Claude Code to read the canvas and generate code:
```
Read my Pencil canvas in designs/my-component.pen and generate
a React component matching the design pixel-perfectly.
Use Tailwind CSS and shadcn/ui components.
```

Claude Code reads the `.pen` file via MCP and generates production-ready code.

### 5. Sync design ↔ code
Pencil is bi-directional — when code changes, ask Claude Code to update the canvas:
```
Update the canvas in designs/my-component.pen to reflect
the changes I made to components/Dashboard.tsx
```

## Key prompts for Pencil

**New screen from scratch:**
```
Design a web app for [purpose]. Use [style] style.
```

**Iterate on existing:**
```
Look at the selected design. [Change]. Create a new design for it.
```

**Explore directions:**
```
Look at the selected design. Explore a totally different design direction.
```

**Brand consistency:**
```
Look at the selected design. Apply our design system from /design-tokens.
```

## When to use Pencil vs Stitch

| | Pencil | Stitch |
|---|---|---|
| **Interface** | Canvas in IDE | API call |
| **Files** | `.pen` in repo | Generated HTML |
| **Direction** | Canvas ↔ Code (bi-directional) | Text → HTML |
| **Best for** | Full product design, living in repo | Quick UI generation via API |
| **Setup** | Extension install required | `STITCH_API_KEY` required |

Use **Pencil** when you want designs to live in the repo with Git versioning.
Use **Stitch** when you want quick API-generated HTML without IDE setup.
