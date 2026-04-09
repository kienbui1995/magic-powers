---
name: manifest-v3
description: Design and configure Manifest V3 browser extensions — service workers, permissions, declarative rules, and migration from MV2.
---

# Manifest V3

## When to Use
- Starting a new browser extension project
- Migrating an existing MV2 extension to MV3
- Configuring permissions, background service workers, or declarative net request rules
- Debugging "service worker terminated" issues

## Core Jobs

### 1. Manifest Structure
Required fields:
```json
{
  "manifest_version": 3,
  "name": "My Extension",
  "version": "1.0.0",
  "description": "...",
  "permissions": [],
  "host_permissions": [],
  "background": {
    "service_worker": "background.js",
    "type": "module"
  },
  "action": {
    "default_popup": "popup.html",
    "default_icon": "icons/icon48.png"
  },
  "icons": { "16": "icons/icon16.png", "48": "icons/icon48.png", "128": "icons/icon128.png" },
  "content_scripts": [],
  "web_accessible_resources": []
}
```

### 2. Permissions Design
- Declare ONLY what you need (Chrome Web Store rejects over-permissioned extensions)
- `permissions` = extension APIs (storage, tabs, contextMenus, alarms, notifications)
- `host_permissions` = website access (`*://*.example.com/*` or `<all_urls>`)
- Use `optional_permissions` for features users might not need
- Dangerous permissions requiring justification: `<all_urls>`, `webNavigation`, `history`, `bookmarks`

### 3. Service Worker (MV3 Background)
Key differences from MV2 background pages:
- Service worker TERMINATES when idle (no persistent state in memory)
- Use `chrome.storage` (not global variables) to persist data
- Register event listeners at top level (not inside callbacks)
- Keep-alive pattern for long-running tasks: `chrome.alarms` API

```javascript
// ✅ Correct — top-level listener
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  // handle message
  return true; // keep channel open for async response
});

// ❌ Wrong — listener inside async callback
chrome.tabs.query({}, (tabs) => {
  chrome.runtime.onMessage.addListener(...); // never registered reliably
});
```

### 4. declarativeNetRequest (replaces webRequest)
- MV3 cannot block requests dynamically with webRequest
- Use `declarativeNetRequest` for URL blocking/redirecting
- Rules defined in JSON files and declared in manifest

```json
{
  "declarative_net_request": {
    "rule_resources": [{ "id": "ruleset_1", "enabled": true, "path": "rules.json" }]
  }
}
```

### 5. Content Security Policy
- MV3 enforces strict CSP: no inline scripts, no `eval()`
- Remote code execution prohibited (no loading scripts from CDN at runtime)
- All scripts must be bundled in the extension package
- Use `web_accessible_resources` for resources injected into pages

## Key Concepts
- **Manifest V3** — current extension standard; MV2 deprecated Jan 2025 in Chrome
- **Service worker** — event-driven background script that terminates when idle
- **host_permissions** — controls which websites the extension can access
- **optional_permissions** — permissions requested at runtime (better UX)
- **declarativeNetRequest** — static rules for network request modification (replaces dynamic webRequest)
- **web_accessible_resources** — extension files accessible from web pages

## Checklist
- [ ] `manifest_version: 3` (not 2)?
- [ ] No inline scripts (CSP compliant)?
- [ ] No remote code execution (all scripts bundled)?
- [ ] Service worker uses `chrome.storage` not in-memory state?
- [ ] Event listeners registered at top level (not in callbacks)?
- [ ] Minimal permissions — only what's needed?
- [ ] `host_permissions` scoped as narrowly as possible?
- [ ] Icons at 16, 48, 128px?

## Output Format
- 🔴 **Critical** — MV2 manifest, remote code execution, missing required fields
- 🟡 **Warning** — overly broad host_permissions (`<all_urls>`), persistent state in service worker
- 🟢 **Suggestion** — use optional_permissions for non-core features

## Common Pitfalls
- Service worker termination: store state in `chrome.storage.session` or `chrome.storage.local`, not global vars
- `return true` in `onMessage` listener is required to keep the message channel open for async responses
- MV3 blocks all inline scripts — use external .js files even for tiny scripts
- `web_accessible_resources` must explicitly list files injected into pages
