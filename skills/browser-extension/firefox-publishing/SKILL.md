---
name: firefox-publishing
description: Publish Firefox browser extensions to Mozilla Add-ons (AMO) — packaging, review process, source code submission, and Firefox-specific requirements.
---

# Firefox Add-ons (AMO) Publishing

## When to Use
- Submitting an extension to addons.mozilla.org (AMO)
- Understanding Firefox's source code review requirements
- Handling Firefox-specific manifest requirements
- Managing AMO reviews and responses

## Core Jobs

### 1. Firefox-Specific Manifest Requirements
```json
{
  "manifest_version": 3,
  "browser_specific_settings": {
    "gecko": {
      "id": "myextension@mydomain.com",
      "strict_min_version": "109.0"
    }
  }
}
```
- `gecko.id` is REQUIRED for AMO submission (use email format or UUID)
- `strict_min_version` sets minimum Firefox version

### 2. AMO Submission Process
1. Create account at addons.mozilla.org
2. Submit extension zip via [Submit a New Add-on](https://addons.mozilla.org/developers/addon/submit/distribution)
3. Choose distribution: Listed (public AMO) or Unlisted (self-hosted)
4. Submit source code zip (required if using minification/bundling)
5. Automated review → manual review (1-7 days)

### 3. Source Code Submission
Firefox requires source code if extension uses build tools (Webpack, Vite, Rollup, etc.):
```bash
# Submit source code separately
# Include: package.json, source files, build instructions
# Exclude: node_modules (provide npm install instructions in README)
zip -r source.zip src/ package.json package-lock.json README.md
```
Include a `SOURCE_CODE_NOTES.md`:
```markdown
## Build Instructions
1. npm install
2. npm run build
3. Load dist/ as unpacked extension
```

### 4. Firefox Review Focus Areas
Reviewers check:
- No obfuscated code (must submit readable source)
- Permissions match actual usage
- No remote code execution
- Privacy practices match privacy policy
- No deceptive behavior

### 5. AMO vs Self-Hosted
| | AMO Listed | AMO Unlisted | Self-hosted |
|-|-----------|-------------|------------|
| Discovery | Public search | No | No |
| Review | Required | Signed only | Manual signing |
| Updates | AMO managed | Self-managed | Self-managed |
| Use case | Public extension | Internal tools | Enterprise |

## Key Concepts
- **Gecko ID** — required unique identifier for Firefox extensions (email format recommended)
- **AMO signing** — Firefox requires all extensions to be signed by Mozilla
- **Source code review** — mandatory if using bundlers/minifiers
- **Unlisted** — signed by Mozilla but not publicly discoverable (good for internal tools)

## Checklist
- [ ] `browser_specific_settings.gecko.id` set in manifest?
- [ ] Source code zip prepared (if using build tools)?
- [ ] `SOURCE_CODE_NOTES.md` with build instructions?
- [ ] No code obfuscation?
- [ ] Privacy policy matches permissions requested?
- [ ] Tested specifically in Firefox (not just Chrome)?

## Output Format
- 🔴 **Critical** — missing Gecko ID (AMO rejection), obfuscated code without source, no build instructions
- 🟡 **Warning** — no source code zip for bundled extension, permissions broader than usage
- 🟢 **Suggestion** — unlisted distribution for internal/enterprise tools

## Common Pitfalls
- Submitting without Gecko ID → immediate rejection
- Bundled/minified code without source → review failure (Mozilla cannot verify behavior)
- Missing build instructions in source submission → reviewer cannot build → rejection
- Testing only in Chrome → Firefox-specific API differences cause runtime errors
