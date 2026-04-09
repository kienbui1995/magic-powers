# Amplitude Division Framework

Magic-powers Amplitude Division provides role-specific agents and skills for product analytics,
experimentation, instrumentation, UX research, and AI monitoring using the Amplitude MCP server.

## Requirements

Amplitude MCP server must be configured. Add to `.claude/settings.json`:

```json
{
  "mcpServers": {
    "Amplitude": {
      "command": "npx",
      "args": ["-y", "@amplitude/mcp@latest"],
      "env": { "AMPLITUDE_API_KEY": "your-key", "AMPLITUDE_SECRET_KEY": "your-secret" }
    }
  }
}
```

Or use the Amplitude MCP OAuth endpoint: `https://mcp.amplitude.com/mcp`

## 5 Agents

| Agent | Role | Key Skills |
|-------|------|-----------|
| amplitude-analyst | PM / General Analyst | Charts, dashboards, briefings |
| amplitude-experimenter | Growth / Experimentation | A/B tests, opportunities, journeys |
| amplitude-engineer | Data Engineer / Dev | Instrumentation, event taxonomy |
| amplitude-ux-researcher | UX / Support | Session replay, error diagnosis |
| amplitude-ai-monitor | AI/LLM Analytics | AI agent quality, topics, sessions |

## Install

`/install-skills` → Category 13: Amplitude Division
