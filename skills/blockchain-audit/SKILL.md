---
name: blockchain-audit
description: Use when reviewing smart contracts for security vulnerabilities, auditing web3 patterns, or preparing for a formal audit
---

# Blockchain & Smart Contract Audit

## When to Use
When reviewing Solidity/Rust smart contracts before deployment, preparing for a formal security audit, or assessing web3 integration risks.

## Core Jobs

### 1. Smart Contract Security Checklist
Critical vulnerabilities to check:
- [ ] **Reentrancy**: Does state update before external call? Use CEI pattern (Checks-Effects-Interactions)
- [ ] **Integer overflow/underflow**: Using SafeMath or Solidity 0.8+?
- [ ] **Access control**: Are admin functions properly restricted? (onlyOwner, role-based)
- [ ] **Front-running**: Can transaction ordering be exploited? (price oracle manipulation)
- [ ] **Unchecked return values**: Are all `.call()` return values checked?
- [ ] **Timestamp dependence**: Is `block.timestamp` used for randomness or time-sensitive logic?
- [ ] **Denial of service**: Can loops be made to run out of gas?
- [ ] **Logic errors**: Does the business logic match the spec exactly?

### 2. DeFi-Specific Risks
- **Flash loan attacks**: Can an attacker manipulate price oracles in a single transaction?
- **Price oracle manipulation**: Using on-chain DEX prices without TWAP?
- **Slippage**: Are swap functions protected against excessive slippage?
- **Liquidity**: Are there constraints on withdrawal that could trap funds?

### 3. Code Quality Review
- Test coverage: 100% line coverage expected for mainnet contracts
- Static analysis: run Slither, MythX, or Semgrep on contract code
- Fuzzing: Echidna or Foundry fuzz tests for edge cases
- Formal verification: for critical financial logic

### 4. Pre-Audit Checklist
- [ ] All known issues resolved or documented
- [ ] Test coverage > 95%
- [ ] Static analysis clean (no medium+ findings)
- [ ] Deployment scripts reviewed
- [ ] Emergency pause mechanism exists
- [ ] Upgrade mechanism reviewed (proxy pattern risks)

## Key Outputs
- Security findings report (severity: Critical / High / Medium / Low / Info)
- Pre-audit readiness assessment
- Remediation recommendations
- Post-fix verification

## Anti-Patterns
- Deploying to mainnet without audit
- "We'll fix it in the next version" for critical vulnerabilities (immutable contracts)
- Trusting on-chain data without validation
- No emergency mechanism — can't pause a compromised contract
