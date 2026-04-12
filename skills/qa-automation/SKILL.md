---
name: qa-automation
description: Use when designing or implementing test automation — choosing the right automation framework (Playwright, pytest, JUnit), Page Object Model, selector strategies, test isolation, managing flaky tests, and CI integration.
---

# QA Automation

## When to Use
- Starting a new test automation project
- Refactoring brittle/flaky test suite
- Choosing between automation frameworks
- Debugging why tests pass locally but fail in CI
- Designing a maintainable automation architecture

## Core Jobs

### 1. Framework Selection
```
Playwright (recommended for web E2E):
  ✅ Cross-browser (Chromium, Firefox, WebKit)
  ✅ Auto-wait for elements (no explicit waits needed)
  ✅ Network interception built-in
  ✅ TypeScript/JavaScript/Python/Java
  ✅ Trace viewer for debugging failures
  Use for: Web UI automation, API testing

pytest (Python backend/API):
  ✅ Fixtures for setup/teardown
  ✅ Parameterization built-in
  ✅ Rich plugin ecosystem (pytest-cov, pytest-xdist)
  Use for: API testing, unit tests, data pipeline testing

JUnit 5 / TestNG (Java):
  ✅ Native Java ecosystem
  ✅ Parameterized tests, test lifecycle annotations
  Use for: Java application testing

Cypress (alternative web E2E):
  ✅ Developer-friendly, real-time reload
  ❌ Chrome-only (Chromium), no multi-tab support
  Use for: Component testing, developer-owned tests
```

### 2. Page Object Model (POM)
```typescript
// pages/LoginPage.ts — Page Object
export class LoginPage {
  constructor(private page: Page) {}

  // Locators as getters (lazy evaluation)
  get emailInput() { return this.page.getByLabel('Email'); }
  get passwordInput() { return this.page.getByLabel('Password'); }
  get submitButton() { return this.page.getByRole('button', { name: 'Sign in' }); }
  get errorMessage() { return this.page.getByRole('alert'); }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }

  async expectLoginError(message: string) {
    await expect(this.errorMessage).toContainText(message);
  }
}

// tests/auth.spec.ts — Test using POM
test('invalid password shows error', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await page.goto('/login');
  await loginPage.login('user@test.com', 'wrongpassword');
  await loginPage.expectLoginError('Invalid credentials');
});
```

### 3. Selector Strategy (Playwright best practices)
```typescript
// Priority order for selectors:
// 1. Role-based (most resilient)
page.getByRole('button', { name: 'Submit' });
page.getByRole('textbox', { name: 'Email' });

// 2. Label-based
page.getByLabel('Password');

// 3. Text content
page.getByText('Confirm order');

// 4. Test ID (explicit, stable)
page.getByTestId('checkout-button');  // data-testid="checkout-button"

// 5. CSS/XPath (last resort — brittle)
page.locator('#submit-btn');          // ❌ avoid — breaks on refactor
page.locator('//div[@class="btn"]'); // ❌ avoid
```

### 4. Test Isolation & Fixtures
```python
# conftest.py — pytest fixtures for test isolation
import pytest
from playwright.sync_api import sync_playwright

@pytest.fixture(scope="session")
def browser():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        yield browser
        browser.close()

@pytest.fixture(scope="function")
def page(browser):
    context = browser.new_context()
    page = context.new_page()
    yield page
    context.close()  # fresh context per test = isolation

@pytest.fixture
def logged_in_page(page, test_user):
    """Pre-authenticated page — reuse auth state"""
    page.goto('/login')
    page.get_by_label('Email').fill(test_user.email)
    page.get_by_label('Password').fill(test_user.password)
    page.get_by_role('button', name='Sign in').click()
    return page

@pytest.fixture
def test_user(db):
    """Create test user, cleanup after test"""
    user = db.create_user(email='test@example.com', password='Test123!')
    yield user
    db.delete_user(user.id)  # cleanup
```

### 5. Flaky Test Management
```
Root causes of flaky tests:
1. Timing issues — hardcoded sleeps, no proper waits
   Fix: Use explicit waits (await page.waitForSelector), never time.sleep()

2. Test interdependence — tests share state
   Fix: Each test creates its own data, cleans up after itself

3. Environment differences — works locally, fails in CI
   Fix: Use Docker for consistent environments, seed data deterministically

4. Random data — tests rely on dynamic content
   Fix: Seed with fixed data, mock random number generators

5. Network instability — external API calls
   Fix: Mock external APIs in tests, use contract tests for real integration

Tracking flaky tests:
- Tag flaky tests: @pytest.mark.flaky(reruns=3)
- Track in CI: collect flaky test metrics over time
- Quarantine: move flaky tests to separate suite, fix before re-enabling
```

### 6. CI Integration
```yaml
# GitHub Actions
- name: Run Playwright tests
  run: npx playwright test --reporter=html
  env:
    BASE_URL: ${{ env.TEST_BASE_URL }}

- name: Upload test results
  uses: actions/upload-artifact@v3
  if: always()
  with:
    name: playwright-report
    path: playwright-report/
    retention-days: 7

# Parallel execution with pytest
- name: Run pytest in parallel
  run: pytest tests/ -n auto --dist=loadbalance
```

## Key Concepts
- **POM (Page Object Model)** — encapsulate UI interactions in classes; tests use POM, not raw selectors
- **Test isolation** — each test is independent; creates/destroys its own data; can run in any order
- **Role-based selectors** — prefer ARIA roles over CSS/XPath; tests survive UI refactoring
- **Fixture** — reusable setup/teardown logic; dependency-injected into tests
- **Flaky test** — test that passes and fails non-deterministically; erodes test suite trust
- **Test pyramid** — many unit tests (fast, cheap), fewer integration, few E2E (slow, expensive)

## Checklist
- [ ] Page Object Model used (no raw selectors in test files)?
- [ ] Role-based selectors preferred over CSS/XPath?
- [ ] Each test is independent (creates own data, cleans up)?
- [ ] No `time.sleep()` / hardcoded waits (use auto-wait or explicit conditions)?
- [ ] Flaky tests tracked and quarantined?
- [ ] Tests run in CI with results published?
- [ ] Parallel execution configured for speed?

## Key Outputs
- Page Object classes for each major page/component
- Test fixtures for authentication, database state, mock APIs
- CI configuration running tests in parallel with results published
- Flaky test inventory with status and fix plan

## Output Format
- 🔴 **Critical** — hardcoded `sleep()` everywhere (timing = flaky), tests sharing state (order-dependent), CSS selectors hardcoded in test files (brittle)
- 🟡 **Warning** — no POM (maintenance nightmare at scale), no parallel execution (slow CI), no test isolation
- 🟢 **Suggestion** — use Playwright trace viewer for debugging CI failures, add `data-testid` to new components, configure test retry for known-flaky tests

## Anti-Patterns
- `time.sleep(5)` as the "fix" for timing issues (makes tests slower AND still flaky)
- God-class POM (one huge page object for the entire app)
- Tests that require specific execution order (hidden dependencies = fragile suite)
- Automating every manual test case (automate regression, explore manually)

## Integration
- `qa-test-design` — test cases designed there are automated here
- `qa-test-data` — fixture patterns for test data creation
- `ado-pipeline-optimization` — publishing automation results in CI
- `test-driven-development` — TDD and automation complement each other
