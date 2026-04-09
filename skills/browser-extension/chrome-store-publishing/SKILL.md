---
name: chrome-store-publishing
description: Publish and maintain Chrome extensions on the Chrome Web Store — packaging, store listing, screenshots, review process, and update management.
---

# Chrome Web Store Publishing

## When to Use
- Submitting a new extension to Chrome Web Store
- Preparing store listing (description, screenshots, icons)
- Responding to CWS review rejection
- Releasing updates

## Core Jobs

### 1. Pre-Submission Checklist
- Developer account: $5 one-time registration fee
- Extension packaged as .zip (not .crx)
- All permissions justified in store listing
- Privacy policy URL (required if handling user data)
- Icons: 128×128px PNG (store listing) + 16, 48, 128 in manifest

### 2. Packaging
```bash
# Build production extension
npm run build

# Create zip (from dist/ folder, not project root)
cd dist && zip -r ../extension.zip . && cd ..
# Do NOT include node_modules, .git, source maps in zip
```

### 3. Store Listing Best Practices
- **Name**: 45 chars max, no "Chrome" in name
- **Short description**: 132 chars — first thing users see in search
- **Detailed description**: explain value, list features, explain permissions
- **Screenshots**: 1280×800 or 640×400px, show actual usage (not mockups)
- **Promotional tile**: 440×280px (optional but recommended)
- **Category**: choose most relevant (Productivity, Developer Tools, etc.)

### 4. Permission Justification
CWS requires written justification for "sensitive permissions":
- `<all_urls>` or broad host access → explain why access to all sites is needed
- `history` → explain use case
- `webNavigation` → explain use case
- Submit via "Single Purpose" description field

### 5. Review Process
- Initial review: 1-3 business days (new extensions)
- Update review: 1-3 business days
- Rejection reasons: policy violations, deceptive permissions, insufficient justification, broken functionality
- Appeals: via Chrome Web Store Developer Support

### 6. Update Management
```json
// Increment version in manifest.json
"version": "1.1.0"
```
- Semantic versioning: MAJOR.MINOR.PATCH
- Users auto-update within 24 hours of approval
- Breaking changes → consider phased rollout via Google Groups

## Key Concepts
- **Developer account** — Google account + $5 one-time fee
- **Single purpose** — CWS requires extensions to have one clear purpose
- **Sensitive permissions** — permissions requiring written justification
- **Phased rollout** — release to % of users to catch issues before full release

## Checklist
- [ ] Developer account registered ($5)?
- [ ] Extension zipped from build output (not source)?
- [ ] All sensitive permissions justified in listing?
- [ ] Privacy policy URL provided (if handling user data)?
- [ ] Screenshots show real usage (1280×800)?
- [ ] Short description is compelling (132 chars)?
- [ ] Version incremented in manifest?

## Output Format
- 🔴 **Critical** — missing privacy policy (if handling data), invalid zip structure, broken extension
- 🟡 **Warning** — screenshots are mockups/blurry, vague permission justification
- 🟢 **Suggestion** — promotional tile for better store presence, video walkthrough

## Common Pitfalls
- Zipping project root (includes node_modules) instead of build output → huge file, rejected
- Name contains "Chrome" — CWS rejects names with browser brand names
- No privacy policy → auto-rejection if extension requests any user data permissions
- Updating without incrementing version number — update not recognized
