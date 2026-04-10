---
name: claude-mcp-setup
description: Use when connecting Claude Code to external services via MCP (Model Context Protocol) — configuring MCP servers for databases, APIs, file systems, and custom tools, and designing effective tool descriptions for Claude.
---

# Claude MCP Setup

## Overview

MCP (Model Context Protocol) lets Claude Code call external tools: query your database, create GitHub issues, search Slack, call APIs. Without MCP, Claude can only work with files and bash commands. With MCP, Claude becomes a full participant in your entire toolchain — querying live data to debug, creating issues, looking up docs.

## When to Use

- Want Claude to directly query your database during development
- Need Claude to access external APIs (Stripe, GitHub, Slack) as tools
- Building custom MCP tools for your specific workflow
- Connecting Claude to Amplitude, Sentry, or other SaaS tools
- Setting up Claude Code for a new project with external dependencies

## Core Jobs

### 1. MCP Server Configuration (.claude/settings.json)

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://localhost/mydb"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"]
    }
  }
}
```

**Scope:** Project-level (`.claude/settings.json`) or global (`~/.claude/settings.json`). Project-level preferred for team consistency. Never hardcode secrets — use `${ENV_VAR}` syntax.

### 2. Popular MCP Servers

```
Database:
  @modelcontextprotocol/server-postgres    — Query PostgreSQL directly
  @modelcontextprotocol/server-sqlite      — Query SQLite files

Development:
  @modelcontextprotocol/server-github      — Issues, PRs, repos
  @modelcontextprotocol/server-git         — Git history, blame
  @modelcontextprotocol/server-filesystem  — File system access

Analytics:
  @amplitude/mcp                           — Amplitude analytics
  (see Amplitude Division in magic-powers)

Productivity:
  @modelcontextprotocol/server-slack       — Slack messages, channels
  mcp-server-linear                        — Linear issues
```

### 3. Designing Tool Descriptions for Claude

The most important thing about MCP: tool descriptions determine when Claude uses them.

```typescript
// Bad tool description — Claude won't know when to call this
{
  name: "query_db",
  description: "Queries the database",
  inputSchema: { query: { type: "string" } }
}

// Good tool description — Claude knows exactly when and how to use
{
  name: "query_user_data",
  description: "Query the PostgreSQL database for user information, analytics, or debugging. Use when: checking what data exists for a user, debugging production issues, verifying data integrity. Returns: JSON with query results. Max 100 rows. Timeout: 10s.",
  inputSchema: {
    query: {
      type: "string",
      description: "SQL SELECT query only. No INSERT/UPDATE/DELETE. Tables: users, subscriptions, events, audit_log."
    }
  }
}
```

Good descriptions answer: when to call this tool, what it returns, what constraints apply (read-only, row limits, timeouts), and what tables/endpoints are available.

### 4. Security Considerations for MCP

```
Read-only access:     Grant Claude SELECT-only DB permissions for dev databases
Scoped access:        Limit filesystem MCP to project directory only
No production creds:  Use dev/staging credentials in local MCP config
Audit logging:        Log all MCP tool calls for security review
Secret management:    Use environment variables, never hardcode in settings.json
```

## Key Concepts

- **MCP (Model Context Protocol)** — standard for connecting AI to external tools; Anthropic-invented, industry-adopted
- **MCP server** — process that exposes tools Claude can call (DB queries, API calls, file operations)
- **Tool description** — text that tells Claude when and how to use a tool; the most important configuration
- **Project vs global MCP** — project-level for team tools; global for personal productivity tools

## Checklist

- [ ] MCP servers configured for all external services Claude needs to access?
- [ ] Tool descriptions explain WHEN to use (not just what they do)?
- [ ] Read-only credentials used where possible?
- [ ] MCP config in `.claude/settings.json` committed to repo (minus secrets)?
- [ ] Secrets in environment variables (not hardcoded in settings.json)?

## Key Outputs

- `.claude/settings.json`: MCP server configuration
- Tool capability summary in CLAUDE.md: what Claude can access and how

## Output Format

- 🔴 **Critical** — production credentials in MCP config, write access to DB when read-only suffices, secrets hardcoded in committed settings.json
- 🟡 **Warning** — poor tool descriptions (Claude doesn't know when to call), no MCP for commonly-needed external data (team queries DB manually that Claude could query)
- 🟢 **Suggestion** — add GitHub MCP for PR/issue context, add DB MCP for debugging queries, scope filesystem MCP to project root only

## Anti-Patterns

- Production database credentials in development MCP config
- Generic tool descriptions ("queries the database") — Claude won't know when to use them
- Global MCP for project-specific tools (creates confusion across unrelated projects)
- No MCP for services that are constantly needed during development (forces manual lookup)

## Integration

- Use with `claude-hooks` (hooks can validate/audit MCP tool calls via PreToolUse)
- Use with `claude-project-settings` (MCP configured in same settings.json)
- See Amplitude Division skills for Amplitude-specific MCP usage patterns
