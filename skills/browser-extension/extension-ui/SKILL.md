---
name: extension-ui
description: Build extension UI — popup, options page, side panel, and devtools panel — with React/Vue or vanilla JS.
---

# Extension UI

## When to Use
- Building popup, options page, side panel, or devtools panel
- Choosing between React/Vue/Svelte and vanilla JS for extension UI
- Handling UI state that needs to persist across popup open/close

## Core Jobs

### 1. UI Surface Types
| Surface | File | Trigger | Size |
|---------|------|---------|------|
| **Popup** | `popup.html` | Toolbar icon click | 800×600px max |
| **Options page** | `options.html` | Right-click → Options | Full browser tab |
| **Side panel** | `sidepanel.html` | `chrome.sidePanel` API | Persistent panel |
| **DevTools panel** | `devtools.html` | DevTools → custom tab | DevTools pane |
| **New tab override** | `newtab.html` | New tab | Full page |

### 2. Popup Best Practices
- Popup closes when user clicks outside — state is LOST (design accordingly)
- Load state from `chrome.storage` on open; save to storage on change
- Keep popup lightweight — heavy work goes in background service worker
- Popup communicates with background via `chrome.runtime.sendMessage`

```javascript
// popup.js
document.addEventListener('DOMContentLoaded', async () => {
  const { count } = await chrome.storage.local.get('count');
  document.getElementById('count').textContent = count ?? 0;
});
```

### 3. Options Page
```json
// manifest.json
"options_ui": {
  "page": "options.html",
  "open_in_tab": true
}
```
- Full page context — no size restrictions
- Ideal for complex settings
- Use `chrome.storage.sync` for user preferences (syncs across devices)

### 4. Side Panel (Chrome 114+)
```json
// manifest.json
"side_panel": { "default_path": "sidepanel.html" },
"permissions": ["sidePanel"]
```
```javascript
// Open side panel on action click
chrome.sidePanel.setPanelBehavior({ openPanelOnActionClick: true });
```

### 5. Framework Setup (React + Vite)
Use [Plasmo](https://docs.plasmo.com/) or [WXT](https://wxt.dev/) for React/Vue extensions:
```bash
# Plasmo
npm create plasmo@latest

# WXT
npm create wxt@latest
```
Handles: manifest generation, HMR in dev, production build, MV3 compatibility.

Vanilla JS for simple extensions — no framework overhead, faster popup load.

## Key Concepts
- **Popup** — temporary, closes on blur, state must be persisted to storage
- **Options page** — persistent tab, ideal for settings
- **Side panel** — Chrome 114+; persistent, visible alongside page
- **Plasmo/WXT** — extension frameworks handling build tooling, HMR, manifest generation
- **Shadow DOM** — isolate injected UI from page styles

## Checklist
- [ ] Popup reads state from `chrome.storage` on open (not relying on background state)?
- [ ] Options page uses `chrome.storage.sync` for user preferences?
- [ ] Side panel enabled in manifest if needed (Chrome 114+ only)?
- [ ] CSP-compliant: no inline scripts in HTML files?
- [ ] Build tool (Plasmo/WXT/Vite) configured for MV3?

## Output Format
- 🔴 **Critical** — inline scripts in HTML (CSP violation), popup storing state in memory
- 🟡 **Warning** — popup doing heavy computation (should be in background), no persistence between popup opens
- 🟢 **Suggestion** — side panel instead of popup for complex UI, Plasmo/WXT for React apps

## Common Pitfalls
- Popup "loses state" — because it's a new page on each open; always load from storage
- CSP blocks inline `<script>` — move all JS to external files
- `window.close()` in popup closes the popup, not the browser window
