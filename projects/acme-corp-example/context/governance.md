---
project: acme-corp
last-updated: 2026-05-05
updated-by: ctx-doc
tags:
  - type/context
  - project/acme-corp
  - status/synthesised
---

# Governance — Acme Corp

## Data Governance Policy v2.1

**Effective:** 2024-09-01
**Status:** **Six months overdue for review** (next review was due 2025-10-24)
**Owners:** Esme Whitlock (Head of Legal & Compliance) + Cassandra Patel (Head of DevOps & Infrastructure)

### What's covered

- **Three-tier classification:** Tier 1 Restricted (candidate personal/decision data, customer financial), Tier 2 Confidential (tenant config, employee records), Tier 3 Internal
- **Hosting:** AWS Frankfurt (EU); no transfer outside EU/EEA without explicit customer authorisation
- **Encryption:** AES-256 at rest, TLS 1.3 in transit
- **Certifications:** ISO 27001 + SOC 2 Type II (annually renewed)
- **Approved processors:** AWS, Datadog, Stripe, Twilio, SendGrid, Slack
- **Production DB access:** Dual authorisation required — employee + Cassandra Patel or DPO
- **Employee restriction:** Must not paste customer/candidate data into any tool not on the approved processor register
- **Breach reporting:** Within 1 hour to Esme Whitlock + Cassandra Patel
- **Track record:** No notifiable data breach since founding
- **Subject rights:** UK GDPR — access within 30 days, rectification, erasure, portability

### What's NOT covered (the AI policy vacuum)

The policy explicitly does NOT address:
- Use of LLMs / generative AI with customer or candidate data
- Acceptable use of third-party AI services (ChatGPT, Claude, Gemini) by employees
- Data residency / training-data implications of LLM-based product features
- Candidate consent for AI-assisted screening or matching
- Explainability requirements for AI-driven hiring decisions
- Bias auditing protocols for AI features

**None of these are covered in any other current policy document.**

## AI Governance — Open Issues

### Customer-Side
James Whitfield raised at Q1 2026 all-hands: at least two enterprise customers using ChatGPT directly with candidate data, outside any Acme governance. Johnny deferred to Esme + Wei + Marcus. Ownership unresolved as of transcript date (2026-03-16). Worth verifying status before Simon engages externally.

### Internal AI Feature Build
Per CEO memo: every AI feature requires bias audit + security review before launch. **No owner, team, or timeline assigned.** This is not a process — it's a stated principle without infrastructure.

### Practical Blockers for AI Product Work
1. Any new third-party processor (LLM vendor, AI infra) needs Legal & Compliance sign-off + signed DPA — procurement bottleneck
2. Production DB access for AI feature development requires Cassandra Patel co-authorisation — dependency on key individual
3. Employee restriction implicitly bans current AI tooling (ChatGPT, Claude, Gemini) for any data work — almost certainly being violated in practice; needs reconciliation

### Bias Risk on AI Candidate Matching (high)
- No formal bias audit protocol exists (only Priya Nair's benchmark suite)
- No ML observability for fairness in production
- No explainability layer
- No customer consent flow
- Enterprise recruitment is a regulated domain — UK Equality Act + EU AI Act (high-risk system classification)

### Historical Precedent
The 2024 skills-extraction CV screening feature shipped without bias audit, was pulled in Dec 2024 after misclassification on non-Western university CVs. Decision to ship without audit was Sam Reilly's. No formal process established post-incident.

## Key Stakeholders for AI Governance

- **Esme Whitlock** (Head of Legal & Compliance) — policy co-owner, DPA sign-off authority for AI vendors. Effective veto power over AI data use. Must engage in Month 1.
- **Cassandra Patel** (Head of DevOps & Infrastructure) — policy co-owner, production DB dual-auth gatekeeper, incident response owner.
- **Priya Nair** (Data Scientist, Warsaw) — natural owner of formal bias audit protocol (closing the gap from benchmark → audit). Has FAccT publications on bias propagation in multi-tenant embedding spaces — directly relevant.

## Sources

- `intelligence/docs/raw/data-governance-policy-2024.md`
- `intelligence/docs/raw/ceo-ai-first-memo.md`
- `intelligence/docs/raw/all-hands-2026-q1-transcript.md`
- `intelligence/docs/raw/predecessor-handoff-memo.md`
- `intelligence/docs/raw/product-roadmap-q1-q2-2026.md`
