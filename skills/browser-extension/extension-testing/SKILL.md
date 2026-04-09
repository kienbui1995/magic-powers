---
name: extension-testing
description: Test browser extensions with Playwright, unit test background workers and storage, and set up CI for extension projects.
---

# Extension Testing

## When to Use
- Setting up automated tests for a browser extension
- Testing content scripts, popups, and background service workers
- Debugging extension behavior in CI/CD

## Core Jobs

### 1. Playwright Extension Testing
Playwright supports loading unpacked extensions:
```javascript
// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  use: {
    // Load extension
    contextOptions: {
      args: [
        `--disable-extensions-except=${path.join(__dirname, 'dist')}`,
        `--load-extension=${path.join(__dirname, 'dist')}`
      ]
    }
  }
});
```

### 2. Testing Popup UI
```javascript
test('popup shows correct count', async ({ context }) => {
  // Get extension service worker
  const [background] = context.serviceWorkers();
  
  // Open popup
  const popupPage = await context.newPage();
  await popupPage.goto(`chrome-extension://${extensionId}/popup.html`);
  
  await expect(popupPage.locator('#count')).toHaveText('0');
});
```

### 3. Unit Testing Background Logic
Extract pure logic from Chrome API calls for unit testing:
```javascript
// background.js — testable pure function
export function calculateBadgeText(count) {
  return count > 99 ? '99+' : String(count);
}

// background.test.js — no browser APIs needed
import { calculateBadgeText } from './background';
test('badge text caps at 99+', () => {
  expect(calculateBadgeText(100)).toBe('99+');
});
```

### 4. Mocking Chrome APIs
```javascript
// vitest / jest setup
global.chrome = {
  storage: {
    local: {
      get: vi.fn().mockResolvedValue({ count: 5 }),
      set: vi.fn().mockResolvedValue(undefined)
    }
  },
  runtime: { sendMessage: vi.fn() }
};
```

### 5. CI Setup
```yaml
# .github/workflows/test.yml
- name: Build extension
  run: npm run build

- name: Install Playwright browsers
  run: npx playwright install chromium

- name: Run extension tests
  run: npx playwright test
```

## Key Concepts
- **Unpacked extension** — loaded from directory during development/testing (not .crx)
- **Extension ID** — determined by public key or auto-generated; can be fixed for testing
- **Service worker** — accessible via `context.serviceWorkers()` in Playwright
- **Pure functions** — extract business logic from Chrome API calls for unit testing

## Checklist
- [ ] Playwright configured with `--load-extension` flag?
- [ ] Business logic extracted to pure functions (testable without browser)?
- [ ] Chrome APIs mocked in unit tests?
- [ ] Extension built before running Playwright tests?
- [ ] CI workflow builds and tests on every PR?

## Output Format
- 🔴 **Critical** — no tests at all for extension logic, no CI
- 🟡 **Warning** — only manual testing, Chrome APIs not mocked in unit tests
- 🟢 **Suggestion** — Playwright for E2E, Vitest for unit tests, extract pure logic

## Common Pitfalls
- Extension ID changes between builds — pin it with `--set-extension-name` or use key in manifest
- Playwright requires built extension — run build step before tests
- `chrome.*` APIs unavailable in Node.js test environment — always mock them
