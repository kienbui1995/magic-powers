---
name: extension-apis
description: Use Chrome/WebExtension APIs correctly — storage, tabs, alarms, notifications, contextMenus, identity, and cross-browser compatibility.
---

# Extension APIs

## When to Use
- Using `chrome.storage`, `chrome.tabs`, `chrome.alarms`, or other extension APIs
- Building features that require browser permissions
- Handling cross-browser API differences

## Core Jobs

### 1. Storage API
Three storage areas for different needs:
```javascript
// local — persistent, device-specific, 10MB limit
await chrome.storage.local.set({ key: value });
const { key } = await chrome.storage.local.get('key');

// sync — synced across devices (Chrome account), 100KB limit, 8KB per item
await chrome.storage.sync.set({ settings: userSettings });

// session — cleared when browser closes, fast, 10MB, no persistence
await chrome.storage.session.set({ tabState: {} });
```

### 2. Tabs API
```javascript
// Get current tab
const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

// Execute script in tab
await chrome.scripting.executeScript({ target: { tabId: tab.id }, files: ['inject.js'] });

// Listen for tab updates
chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (changeInfo.status === 'complete') { /* page loaded */ }
});
```

### 3. Alarms API (keep-alive + scheduling)
```javascript
// Create repeating alarm (survives service worker termination)
await chrome.alarms.create('sync', { periodInMinutes: 5 });

chrome.alarms.onAlarm.addListener((alarm) => {
  if (alarm.name === 'sync') doSync();
});
```

### 4. Identity API (OAuth)
```javascript
// Launch OAuth flow (Chrome)
const token = await chrome.identity.getAuthToken({ interactive: true });

// Launch web auth flow (works cross-browser, custom OAuth)
const redirectUrl = chrome.identity.getRedirectURL();
const responseUrl = await chrome.identity.launchWebAuthFlow({
  url: `https://provider.com/auth?redirect_uri=${redirectUrl}`,
  interactive: true
});
```

### 5. Context Menus
```javascript
chrome.contextMenus.create({
  id: 'myAction',
  title: 'Do something with "%s"', // %s = selected text
  contexts: ['selection', 'page', 'link', 'image']
});

chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === 'myAction') { /* handle */ }
});
```

## Key Concepts
- **chrome.storage.local** — persistent storage, stays after browser restart
- **chrome.storage.session** — fast, cleared on browser close, ideal for service worker state
- **chrome.storage.sync** — synced via Google account, strict size limits
- **chrome.alarms** — survives service worker termination, ideal for periodic tasks
- **chrome.identity** — OAuth flows without exposing client secrets in page
- **chrome.scripting** — MV3 replacement for `tabs.executeScript`

## Checklist
- [ ] Using `storage.session` for transient service worker state (not global vars)?
- [ ] Storage quota checked for `storage.sync` usage?
- [ ] Alarms used for periodic tasks (not `setInterval` in service worker)?
- [ ] `chrome.scripting` used (not deprecated `tabs.executeScript`)?
- [ ] Context menus created in `runtime.onInstalled` listener?

## Output Format
- 🔴 **Critical** — global variables for state in service worker (lost on termination), using deprecated MV2 APIs
- 🟡 **Warning** — `storage.sync` near quota limit, `setInterval` in service worker
- 🟢 **Suggestion** — `storage.session` for tab-level state, alarms for background scheduling

## Common Pitfalls
- `setInterval` / `setTimeout` in service worker: the worker can terminate before they fire — use `chrome.alarms`
- Context menus must be created in `chrome.runtime.onInstalled` (re-registered on update), not top-level
- `storage.sync` has strict limits: 100KB total, 8KB per item, 1800 writes/hour
