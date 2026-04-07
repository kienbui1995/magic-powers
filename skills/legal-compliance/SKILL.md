---
name: legal-compliance
description: Use when reviewing code, docs, or features for legal and regulatory requirements (GDPR, CCPA, SOC2, HIPAA, etc.)
---

# Legal Compliance

## When to Use
When building features that handle user data, launching in new markets, preparing for a security audit, or reviewing contracts.

## Core Jobs

### 1. Data Privacy (GDPR / CCPA)
For any feature handling personal data:
- **Data inventory**: what data is collected, where stored, who has access?
- **Legal basis**: consent, legitimate interest, or contract?
- **Rights support**: can users access, export, and delete their data?
- **Data minimization**: collect only what you actually need
- **Retention**: delete data after the defined retention period
- **Third parties**: do you share data with processors? DPAs in place?

GDPR red flags: no cookie consent for tracking, no privacy policy, no deletion mechanism.

### 2. Security Compliance (SOC2 / ISO 27001)
Common requirements:
- Access control: least privilege, MFA enforced, access reviews quarterly
- Encryption: at rest (AES-256) and in transit (TLS 1.2+)
- Audit logs: who accessed what, when (tamper-evident)
- Incident response: documented plan, tested annually
- Vendor risk: third parties assessed before use

### 3. Terms of Service and Privacy Policy Review
Check that policies cover:
- What data is collected and how it's used
- User rights (access, deletion, portability)
- Data retention periods
- Third-party sharing
- Contact for privacy inquiries (DPO if required)

### 4. Feature-Level Compliance Checklist
Before shipping a feature that handles PII:
- [ ] Privacy impact assessment completed
- [ ] Data added to data inventory
- [ ] Retention policy set
- [ ] User rights mechanism exists (if user data)
- [ ] Legal reviewed if new data category

## Key Outputs
- Data inventory / map
- Compliance gap analysis
- Feature-level privacy checklist
- Policy review notes

## Anti-Patterns
- "We'll handle compliance later" (technical debt with legal consequences)
- Assuming your jurisdiction's rules apply to all users
- No deletion mechanism — can't comply with right-to-erasure requests
- Privacy policy written by engineers without legal review
