---
name: content-scripts
description: Build content scripts for DOM manipulation, page interaction, and messaging between extension and web pages.
---

# Content Scripts

## When to Use
- Manipulating or reading DOM on web pages
- Injecting UI elements into pages
- Communicating between webpage and extension background
- Accessing page JavaScript context

## Core Jobs

### 1. Content Script Registration
Static (manifest) vs Dynamic (programmatic):

**Static (manifest.json):**
```json
"content_scripts": [{
  "matches": ["*://*.example.com/*"],
  "js": ["content.js"],
  "css": ["content.css"],
  "run_at": "document_idle",
  "all_frames": false
}]
```

**Dynamic (runtime injection):**
```javascript
// From background/popup — inject on demand
await chrome.scripting.executeScript({
  target: { tabId: tab.id },
  files: ['content.js']
});
```

### 2. Isolated World vs Main World
- **Isolated world** (default) — content script cannot access page's JavaScript variables/functions
- **Main world** — content script runs in same context as page JS (can access `window.myPageVar`)

```javascript
// Main world injection (to access page JS)
await chrome.scripting.executeScript({
  target: { tabId },
  world: 'MAIN',
  func: () => window.myPageLibrary.getData()
});
```

### 3. Messaging Patterns
Content script → Background:
```javascript
// content.js
const response = await chrome.runtime.sendMessage({ action: 'getData', key: 'foo' });

// background.js
chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
  if (msg.action === 'getData') {
    sendResponse({ value: store[msg.key] });
  }
  return true; // async response
});
```

Page → Extension (custom events):
```javascript
// Webpage dispatches event
window.dispatchEvent(new CustomEvent('myExt:request', { detail: { data } }));

// Content script listens
window.addEventListener('myExt:request', (e) => {
  chrome.runtime.sendMessage({ data: e.detail.data });
});
```

### 4. DOM Manipulation Best Practices
- Use `MutationObserver` for dynamic pages (SPAs)
- Shadow DOM for injected UI (prevents style conflicts)
- Unique class/ID prefixes to avoid collisions with page styles
- Clean up listeners and DOM on `window.beforeunload`

### 5. Accessing Extension Resources from Content Scripts
```javascript
// Get URL to bundled image/file
const imgUrl = chrome.runtime.getURL('images/icon.png');
```
Resource must be listed in `web_accessible_resources` in manifest.

## Key Concepts
- **Isolated world** — content scripts can't see page's JS scope (security boundary)
- **Main world** — content scripts share page JS scope (needed for page SDK interaction)
- **run_at** — `document_start` (before DOM), `document_end` (DOM ready), `document_idle` (default, after load)
- **all_frames** — whether to inject in iframes (default: false)
- **MutationObserver** — watch for DOM changes in dynamic (SPA) pages

## Checklist
- [ ] Using MutationObserver for dynamic/SPA pages?
- [ ] UI injected with Shadow DOM to isolate styles?
- [ ] Unique prefixes on class names to avoid page conflicts?
- [ ] `return true` in message listeners for async responses?
- [ ] Resources referenced in content scripts listed in `web_accessible_resources`?
- [ ] Cleanup on page unload?

## Output Format
- 🔴 **Critical** — accessing page JS without main world injection, missing `return true` for async messages
- 🟡 **Warning** — no MutationObserver on SPA, style conflicts without Shadow DOM
- 🟢 **Suggestion** — dynamic injection for better performance (vs static for all pages)

## Common Pitfalls
- `window.myVar` in isolated world returns `undefined` — page variables are invisible; use main world or postMessage
- `chrome.runtime.sendMessage` from content script fails if background service worker is terminated — add retry logic
- CSS injected globally pollutes page styles — always use Shadow DOM or scoped selectors
