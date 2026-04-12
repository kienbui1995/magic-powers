---
name: qc-test-data
description: Use when managing test data — designing test data strategies, using factories and builders, creating fixtures, generating synthetic data, masking PII for testing, and managing test database state.
---

# QA Test Data Management

## When to Use
- Tests break because they depend on specific production data
- Test environment has stale or missing data
- Cannot use production data in tests (GDPR/PII concerns)
- Tests interfere with each other due to shared data
- Need realistic-looking data for performance tests

## Core Jobs

### 1. Test Data Strategies
```
Strategy 1: Isolated test data (recommended)
  Each test creates its own data, deletes it after
  ✅ Tests are independent, no shared state conflicts
  ✅ Works with parallel test execution
  ❌ Slower (DB writes per test)

Strategy 2: Shared base data + test-specific data
  Seed base reference data (countries, categories) once
  Each test creates entity-specific data
  ✅ Balance of speed and isolation
  ✅ Good for data that rarely changes

Strategy 3: Database snapshots
  Snapshot DB before test run, restore after
  ✅ Fast (no per-test cleanup)
  ❌ Risky for parallel execution
  ❌ Hard to maintain as schema evolves

Strategy 4: Test containers
  Each test run gets fresh ephemeral DB (Docker)
  ✅ Perfect isolation
  ✅ Tests database migrations
  ❌ Slower startup (~5-10s per suite)
```

### 2. Factory Pattern
```python
# factories.py — centralized test data creation
import factory
from factory.django import DjangoModelFactory
from faker import Faker

fake = Faker()

class UserFactory(DjangoModelFactory):
    class Meta:
        model = User

    email = factory.LazyFunction(lambda: fake.email())
    first_name = factory.LazyFunction(lambda: fake.first_name())
    last_name = factory.LazyFunction(lambda: fake.last_name())
    password = factory.PostGenerationMethodCall('set_password', 'Test1234!')
    is_active = True

class OrderFactory(DjangoModelFactory):
    class Meta:
        model = Order

    user = factory.SubFactory(UserFactory)  # auto-creates user
    status = Order.Status.PENDING
    total = factory.LazyFunction(
        lambda: fake.pydecimal(min_value=10, max_value=1000, right_digits=2)
    )

# Usage in tests
def test_user_can_cancel_order():
    order = OrderFactory(status=Order.Status.CONFIRMED)
    result = cancel_order(order.id, order.user)
    assert result.status == Order.Status.CANCELLED
```

### 3. Builder Pattern (fluent interface)
```typescript
// TypeScript builder for complex test data
class UserBuilder {
  private data = {
    email: 'test@example.com',
    role: 'USER',
    isActive: true,
    credits: 100,
  };

  withEmail(email: string) { this.data.email = email; return this; }
  withRole(role: string) { this.data.role = role; return this; }
  inactive() { this.data.isActive = false; return this; }
  withCredits(credits: number) { this.data.credits = credits; return this; }
  asAdmin() { this.data.role = 'ADMIN'; return this; }

  async build() {
    return await createUser(this.data);
  }
}

// Usage
const adminUser = await new UserBuilder()
  .withEmail('admin@test.com')
  .asAdmin()
  .build();

const lockedUser = await new UserBuilder()
  .inactive()
  .withCredits(0)
  .build();
```

### 4. PII Masking for Test Environments
```python
# pii_masker.py — mask real data for test use
from faker import Faker

fake = Faker()

def mask_user_data(user: dict) -> dict:
    """Replace PII with realistic-looking fake data"""
    return {
        **user,
        'email': fake.email(),
        'name': fake.name(),
        'phone': fake.phone_number(),
        'address': fake.address(),
        # Keep non-PII fields for realistic testing
        'created_at': user['created_at'],
        'plan': user['plan'],
        'usage_gb': user['usage_gb'],
    }

def mask_production_export(data: list[dict]) -> list[dict]:
    """Safe to use in test environments after masking"""
    return [mask_user_data(record) for record in data]
```

### 5. Database State Management
```python
# conftest.py — pytest database management
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import Session

@pytest.fixture(scope="session")
def db_engine():
    engine = create_engine("postgresql://test:test@localhost/testdb")
    run_alembic_migrations(engine)
    yield engine
    engine.dispose()

@pytest.fixture(autouse=True)
def db_transaction(db_engine):
    """Wrap each test in a transaction that rolls back after"""
    connection = db_engine.connect()
    transaction = connection.begin()
    session = Session(bind=connection)
    yield session
    session.close()
    transaction.rollback()  # automatically undone after each test
    connection.close()
```

## Key Concepts
- **Factory** — object that creates test data with sensible defaults; override only what matters for the test
- **Builder** — fluent interface for step-by-step object construction; good for complex objects
- **Test isolation** — each test owns its data; no shared state between tests
- **PII masking** — replace real personal data with fake-but-realistic data for testing
- **Test containers** — ephemeral Docker-based databases for perfect isolation
- **Rollback fixture** — wrap test in transaction, rollback after (fast cleanup alternative to DELETE)

## Checklist
- [ ] Tests create their own data (no dependency on specific pre-existing data)?
- [ ] Factory/builder pattern used (not hardcoded test data inline)?
- [ ] PII not present in test environments (masked or synthetic data only)?
- [ ] Database cleanup happens reliably (even when test fails)?
- [ ] Factories generate unique values (avoid unique constraint violations in parallel tests)?
- [ ] Large dataset tests use synthetic generation (not production export)?

## Key Outputs
- Factory classes for each domain entity
- Test database fixture strategy (transaction rollback or test containers)
- PII masking script for production data sanitization
- Data seeding scripts for base reference data

## Output Format
- 🔴 **Critical** — production PII in test environments, tests sharing mutable data, no cleanup on test failure
- 🟡 **Warning** — hardcoded test data inline in tests (brittle when schema changes), no factory pattern
- 🟢 **Suggestion** — use transaction rollback for fast cleanup, Faker for realistic synthetic data, testcontainers for perfect DB isolation

## Anti-Patterns
- Using production database for testing (data corruption risk, PII exposure)
- Hardcoding IDs like `user_id = 42` (breaks when data changes)
- Test data created in `setUp` but not cleaned up (state leaks between tests)
- Factories with no randomization (unique constraint violations in parallel runs)

## Integration
- `qa-automation` — fixtures use these data patterns
- `test-driven-development` — TDD tests need isolated data from the start
- `ado-pipeline-optimization` — parallel test execution requires isolated test data
