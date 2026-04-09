---
name: extension-security
description: Secure browser extensions — CSP configuration, minimal permissions, content script XSS prevention, and handling sensitive data safely.
---

# Extension Security

## When to Use
- Reviewing extension permissions for Chrome Web Store submission
- Preventing XSS in content scripts
- Handling sensitive user data (tokens, passwords)
- Configuring Content Security Policy

## Core Jobs

### 1. Permission Minimization
- Request only permissions you actively use (CWS rejects over-permissioned extensions)
- Use `optional_permissions` for features users might enable later
- `host_permissions: ["<all_urls>"]` requires strong justification and detailed privacy policy
- Prefer specific host patterns: `"*://*.github.com/*"` over `"<all_urls>"`

### 2. Content Security Policy
MV3 default CSP (strict):
```json
"content_security_policy": {
  "extension_pages": "script-src 'self'; object-src 'self'"
}
```
- No `unsafe-inline`, no `unsafe-eval`
- No remote scripts (all JS must be bundled)
- If using WebAssembly: add `'wasm-unsafe-eval'`

### 3. Content Script XSS Prevention
```javascript
// ❌ Dangerous — XSS if pageData contains script tags
element.innerHTML = pageData;

// ✅ Safe — text only, no HTML interpretation
element.textContent = pageData;

// ✅ Safe — create elements programmatically
const div = document.createElement('div');
div.textContent = userInput;
container.appendChild(div);
```

### 4. Secure Data Handling
- Never store passwords/secrets in `chrome.storage` (not encrypted)
- Use `chrome.identity` for OAuth (tokens managed by browser)
- For API keys: use backend proxy, not hardcoded in extension
- Sensitive operations (auth, payments) → send to backend, not done in extension

### 5. Message Validation
```javascript
// Validate message sender in background
chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
  // Verify sender is your extension (not a malicious page)
  if (sender.id !== chrome.runtime.id) return;
  // Validate message structure
  if (!msg.action || typeof msg.action !== 'string') return;
  // Process safely
});
```

### 6. web_accessible_resources Security
Only expose what's needed:
```json
"web_accessible_resources": [{
  "resources": ["images/logo.png"],
  "matches": ["*://*.trusted-site.com/*"]
}]
```
Avoid `"matches": ["<all_urls>"]` for sensitive resources.

## Key Concepts
- **CSP** — blocks inline scripts and remote code execution in MV3
- **Isolated world** — content scripts can't be accessed by page JS (security boundary)
- **`chrome.identity`** — secure OAuth without exposing tokens to page
- **`web_accessible_resources`** — extension files visible to web pages (exposure surface)
- **Message validation** — always verify sender origin and message structure

## Checklist
- [ ] No `<all_urls>` without strong justification?
- [ ] No `innerHTML` with external/user data (use `textContent` or DOMParser)?
- [ ] No secrets/API keys hardcoded in extension code?
- [ ] Message listeners validate sender identity?
- [ ] `web_accessible_resources` scoped to specific match patterns?
- [ ] No `eval()` or dynamic code execution?
- [ ] Privacy policy URL in CWS listing?

## Output Format
- 🔴 **Critical** — `innerHTML` with untrusted data (XSS), hardcoded API keys, `eval()` usage
- 🟡 **Warning** — overly broad host_permissions, missing message sender validation
- 🟢 **Suggestion** — optional_permissions for non-core features, backend proxy for API calls

## Common Pitfalls
- `innerHTML = userContent` in content scripts is XSS — page can inject malicious content through DOM
- Hardcoded API keys in extension source are visible to anyone who downloads the extension
- `chrome.storage` is not encrypted — don't store auth tokens or sensitive data there
