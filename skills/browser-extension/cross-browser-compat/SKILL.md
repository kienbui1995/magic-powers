---
name: cross-browser-compat
description: Build browser extensions that work across Chrome, Firefox, Safari, and Edge — API differences, polyfills, and browser-specific manifest requirements.
---

# Cross-Browser Compatibility

## When to Use
- Building an extension that needs to work in Chrome + Firefox (most common)
- Adding Safari support (requires Xcode conversion)
- Debugging browser-specific API differences
- Choosing between Chrome-only and cross-browser approach

## Core Jobs

### 1. Browser Support Matrix

| Feature | Chrome | Firefox | Safari | Edge |
|---------|--------|---------|--------|------|
| Manifest V3 | ✅ Required | ✅ Supported | ✅ Required | ✅ Required |
| Service Workers | ✅ | ✅ (110+) | ✅ | ✅ |
| Side Panel | ✅ (114+) | ❌ (sidebar) | ❌ | ✅ |
| declarativeNetRequest | ✅ | ✅ | ✅ | ✅ |
| `chrome.*` namespace | ✅ | ✅ (alias) | ✅ (alias) | ✅ |
| `browser.*` namespace | ❌ native | ✅ native | ✅ native | ❌ native |

### 2. webextension-polyfill (Recommended)
Use `@mozilla/webextension-polyfill` for Promise-based APIs across browsers:
```javascript
import browser from 'webextension-polyfill';
// Works in Chrome, Firefox, Safari, Edge
const tabs = await browser.tabs.query({ active: true });
```

### 3. Firefox-Specific Differences
- Firefox uses `browser.*` namespace natively (Promise-based)
- Firefox requires `browser_specific_settings` in manifest:
```json
"browser_specific_settings": {
  "gecko": {
    "id": "extension@yourdomain.com",
    "strict_min_version": "109.0"
  }
}
```
- Firefox does NOT support Side Panel (has its own sidebar API)
- Firefox blocks some cross-origin requests that Chrome allows

### 4. Safari via Xcode
```bash
# Convert Chrome extension to Safari format
xcrun safari-web-extension-converter /path/to/extension --project-location ./safari-ext
```
- Requires Xcode + Apple Developer account ($99/year)
- Distributed through Mac App Store (not separate store)
- User must enable extension in Safari settings

### 5. Build-time Detection
```javascript
// Runtime browser detection
const isFirefox = navigator.userAgent.includes('Firefox');
const isChrome = !!window.chrome && !!window.chrome.runtime;

// Feature detection (preferred)
const hasSidePanel = !!chrome.sidePanel;
```

## Key Concepts
- **`chrome.*`** — Chrome/Edge native; aliased in Firefox/Safari
- **`browser.*`** — Firefox/Safari native; NOT available in Chrome without polyfill
- **webextension-polyfill** — wraps callback APIs in Promises, normalizes browser differences
- **Gecko ID** — Firefox requires unique extension ID in `browser_specific_settings`
- **WXT/Plasmo** — handle cross-browser builds automatically

## Checklist
- [ ] Using `webextension-polyfill` or WXT for cross-browser Promise APIs?
- [ ] Firefox `browser_specific_settings.gecko.id` set in manifest?
- [ ] Side Panel replaced with fallback for Firefox?
- [ ] Feature detection used (not browser-string sniffing)?
- [ ] Tested in Firefox (not just Chrome)?

## Output Format
- 🔴 **Critical** — `browser.*` calls without polyfill in Chrome, missing Gecko ID for Firefox
- 🟡 **Warning** — Chrome-only APIs without fallback, no Firefox testing
- 🟢 **Suggestion** — webextension-polyfill for cleaner cross-browser code, WXT for automated builds

## Common Pitfalls
- `browser.tabs.query()` fails in Chrome without polyfill — use `chrome.*` or add polyfill
- Firefox rejects extension without `browser_specific_settings.gecko.id`
- Safari extension requires full Xcode project + App Store review (not just a zip)
