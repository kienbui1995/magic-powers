---
name: qc-security-testing
description: Use when testing security from a QC perspective — OWASP Top 10 test cases, authentication and authorization testing, input validation testing, security regression testing, and integrating security checks into the QC process.
---

# QC Security Testing

## When to Use
- Adding security test cases to a feature's test suite
- Verifying authentication and authorization work correctly
- Testing for OWASP Top 10 vulnerabilities as part of QC
- Security regression after a vulnerability fix
- Pre-release security smoke test

## Core Jobs

### 1. OWASP Top 10 — QC Test Checklist

For each release, QC should verify these categories:

**A01: Broken Access Control**
```
Test cases:
- Direct object reference: change /api/orders/123 to /api/orders/124 — should return 403 not other user's order
- Privilege escalation: use regular user token to call admin endpoint → expect 403
- IDOR (Insecure Direct Object Reference): modify URL/body IDs to access other users' data
- Missing function-level access control: access /admin without admin role → expect 401/403
- Force browsing: try /admin, /config, /backup directly → expect 403/404

Test command example:
  curl -H "Authorization: Bearer $USER_TOKEN" https://api.app.com/api/admin/users
  Expected: 403 Forbidden
  Actual if broken: 200 OK with admin data
```

**A02: Cryptographic Failures**
```
Test cases:
- Sensitive data in logs: submit password reset, check application logs — password must not appear
- HTTP vs HTTPS: verify all pages redirect HTTP → HTTPS (check network tab)
- Sensitive data in URL: verify passwords, tokens never in query string (check browser history)
- Weak password policy: try "password", "123456" — should be rejected
- Session token entropy: capture multiple tokens — must not be sequential or predictable
```

**A03: Injection**
```sql
-- SQL Injection test cases (use in search, login, filter fields)
Test input: ' OR '1'='1
Test input: '; DROP TABLE users; --
Test input: 1 UNION SELECT username, password FROM users--

Expected: Error message (sanitized) or no results — NOT data exposure or SQL error
Never use against production without authorization
```

```javascript
// XSS test cases (use in name fields, comments, search)
Test input: <script>alert('XSS')</script>
Test input: <img src=x onerror=alert('XSS')>
Test input: javascript:alert('XSS')

Expected: Input displayed as literal text, alert does NOT fire
```

**A07: Identification and Authentication Failures**
```
Authentication test cases:
- Brute force: 10 wrong passwords → account should lock or rate-limit
- Weak token: capture JWT, decode payload — sensitive data should not be in payload
- Token expiry: use expired token → should return 401
- Session fixation: get session ID before login, check if same ID after login (should change)
- Concurrent sessions: login twice — both sessions valid? Or first invalidated?
- Logout: after logout, use old token → should return 401 (token invalidated server-side)
```

### 2. Authorization Testing Patterns
```python
# Matrix-based authorization testing
# Test each role against each resource

roles = ["anonymous", "user", "admin", "superadmin"]
endpoints = [
    ("GET", "/api/users", [None, None, 200, 200]),        # expected status per role
    ("GET", "/api/users/1", [401, 200, 200, 200]),
    ("DELETE", "/api/users/1", [401, 403, 200, 200]),
    ("GET", "/api/admin/stats", [401, 403, 200, 200]),
]

for method, path, expected_by_role in endpoints:
    for i, role in enumerate(roles):
        token = get_token(role)
        response = request(method, path, token)
        assert response.status_code == expected_by_role[i], \
            f"{role} {method} {path}: expected {expected_by_role[i]}, got {response.status_code}"
```

### 3. Input Validation Testing
```
Test boundary cases for all inputs:
  String fields:
    - Empty string: ""
    - Max length +1: "a" * (MAX_LENGTH + 1)
    - SQL injection: "' OR '1'='1"
    - XSS: "<script>alert(1)</script>"
    - Unicode: "日本語テスト", "émoji 🎉"
    - Null bytes: "test\x00injection"
    - Path traversal: "../../etc/passwd"
    - CRLF injection: "test\r\nHeader: injected"

  Numeric fields:
    - Negative values: -1, -999999
    - Zero: 0
    - Max integer +1: 2147483648
    - Float overflow: 999999999999.99
    - Non-numeric: "abc", "1.2.3"

  File uploads:
    - Oversized file (>max)
    - Wrong content type (exe as jpg)
    - Malicious filename: "../../../etc/passwd.jpg"
    - Empty file
    - Double extension: "file.jpg.exe"
```

### 4. Security Regression Testing
```bash
# After fixing a vulnerability, verify:
# 1. Original exploit no longer works
# 2. No regression in related functionality

# Example: SQL injection fix regression test
curl -X POST https://api.app.com/api/search \
  -H "Content-Type: application/json" \
  -d '{"query": "'\'' OR '\''1'\''='\''1"}'

# Expected after fix: {"results": [], "total": 0}
# Not expected: SQL error or unfiltered results
```

### 5. API Security Testing with Tools
```bash
# OWASP ZAP quick scan (passive + active)
zap-cli quick-scan --self-contained --start-options "-config api.disablekey=true" \
  --spider https://staging.myapp.com \
  --ajax-spider \
  --format json \
  --output zap-report.json

# Nikto web server scan
nikto -h https://staging.myapp.com -output nikto-report.html

# SSL/TLS check
testssl.sh https://staging.myapp.com
```

## Key Concepts
- **OWASP Top 10** — industry standard list of most critical web security risks; use as QC checklist
- **IDOR (Insecure Direct Object Reference)** — accessing another user's resource by changing ID in URL/body
- **Privilege escalation** — using lower-privilege account to access higher-privilege functionality
- **SQL injection** — malicious SQL injected through input fields to manipulate database
- **XSS (Cross-Site Scripting)** — malicious scripts injected into pages viewed by other users
- **Security regression** — verifying previously fixed vulnerabilities don't reappear
- **Authorization matrix** — table mapping roles × resources × expected HTTP status codes

## Checklist
- [ ] OWASP Top 10 checklist reviewed for each release?
- [ ] Authorization matrix tested (all roles × all sensitive endpoints)?
- [ ] Input validation tested (injection, XSS, boundary values) for all user inputs?
- [ ] Authentication tested (brute force, token expiry, logout invalidation)?
- [ ] Security regression test run after each vulnerability fix?
- [ ] Security testing in CI (OWASP ZAP scan or equivalent)?

## Key Outputs
- Authorization matrix test results (role × endpoint × expected/actual status)
- OWASP Top 10 test checklist with pass/fail per item
- Input validation test results for security-sensitive fields
- Security regression test report after vulnerability fixes

## Output Format
- 🔴 **Critical** — no authorization testing (any user can access admin endpoints), no input validation testing (injection vulnerabilities untested), security tests only run manually before major releases
- 🟡 **Warning** — authorization testing for happy path only (no negative cases), no security regression tests after fixes
- 🟢 **Suggestion** — add OWASP ZAP to CI pipeline for automated security scanning, create authorization matrix as living document, add security test cases to DoD

## Anti-Patterns
- Only testing that authenticated users CAN access resources (forgetting to test unauthorized access is blocked)
- Assuming developers handle input validation without QC verification
- No security regression test = same vulnerability reappears in future release
- Running security tests only on production (use staging; never SQL injection on prod without authorization)

## Integration
- `qc-test-design` — security test cases use same design techniques (EP, BVA for injection inputs)
- `qc-defect-management` — security defects have special handling (severity escalation, disclosure process)
- `qa-risk-management` — security risks are highest priority in risk register
- `qa-audit` — audit includes checking if OWASP testing is being performed
