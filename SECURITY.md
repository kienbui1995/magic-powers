# Security Policy

## Security Audit

All skills, agents, and integrations in Magic Powers are automatically scanned for security issues identified by the [Snyk ToxicSkills study](https://snyk.io/blog/toxic-skills/) (2026), which found 13.4% of community skills contain critical vulnerabilities.

### What We Scan (14 checks)

#### Critical (blocks release)

| # | Check | Description |
|---|-------|-------------|
| 1 | Hardcoded secrets | API keys, tokens, passwords embedded in files |
| 2 | Dangerous shell commands | `rm -rf /`, `sudo`, `chmod 777`, pipe-to-bash |
| 3 | Prompt injection | "Ignore previous instructions" and similar patterns |
| 4 | Env variable exfiltration | Dumping `process.env`, `os.environ`, `printenv` to external targets |
| 5 | Write to sensitive paths | Modifying `~/.bashrc`, `/etc/crontab`, `/etc/sudoers`, etc. |
| 6 | Crypto wallet/private key | Wallet files, seed phrases, private key hex strings |

#### Warning (review required)

| # | Check | Description |
|---|-------|-------------|
| 7 | Broad file access | Access to `~/.ssh`, `~/.aws`, `~/.kube`, `/etc/passwd` |
| 8 | Data exfiltration | POST requests to external URLs |
| 9 | Eval/exec calls | Dynamic code execution patterns |
| 10 | Encoded payloads | Large base64 blobs that could hide malicious content |
| 11 | Malicious package install | `npm install` / `pip install` from URL/git (not registry) |
| 12 | Network recon | `nmap`, `netcat`, port scanning tools |
| 13 | Obfuscated strings | Hex/unicode escape sequences hiding payloads |
| 14 | Overly permissive instructions | "No restrictions", "bypass safety", jailbreak enablers |

### Scan Scope

| Directory | Files | What |
|-----------|-------|------|
| `skills/` | `SKILL.md` | All workflow skills |
| `agents/` | `*.md` | All agent definitions |
| `integrations/` | `*.md`, `*.mdc` | Cursor, Copilot, Aider, Windsurf, etc. |
| `hooks/` | `*` | Session hooks and scripts |
| `commands/` | `*.md` | Slash commands |

### Running Locally

```bash
bash scripts/security-audit.sh
```

### CI/CD

Security audit runs automatically on:
- Every push to `main` that modifies content files
- Every pull request
- Weekly scheduled scan (Monday 00:00 UTC)

## Reporting Vulnerabilities

If you find a security issue, please email security@pmai.space instead of opening a public issue.
