---
project: acme-corp
last-updated: 2026-05-05
updated-by: ctx-doc
tags:
  - type/context
  - project/acme-corp
  - status/synthesised
---

# AI Initiatives History — Acme Corp

What's been tried before Simon. Source: predecessor handoff memo (Sam Reilly, 2026-04-16) corroborated against the priya-360-review and customer-escalation files.

## Initiative 1 — Skills-Extraction CV Screening (2024)

- **Built by:** Warsaw data team (8-week prototype)
- **Shipped:** October 2024
- **Pulled:** December 2024
- **Reason:** Misclassification tickets on CVs from non-Western university systems
- **Bias audit:** Not conducted. Decision to ship without audit was Sam Reilly's.
- **Process change post-incident:** None formalised. No bias review process established.

## Initiative 2 — Auto-Generated Outreach Drafts (2025)

- **Target:** September 2025 trade show
- **External commitment:** Made before customer testing completed. Decision to commit pre-testing was Sam's.
- **Built:** Yes
- **Shipped:** No — customer testing revealed generic AI-sounding output
- **Marcus + Elena:** Managed the comms fallout
- **Status today:** Blocked until candidate matching launches

## The Prototype That Became AI-First

Priya Nair brought the candidate-matching prototype proposal to Sam **twice** (May 2025, December 2025). Both times deprioritised by Sam under Marcus's direction to focus on workflow features.

That prototype is now the technical foundation of the public AI-First commitment (announced January 2026).

The 360 review of Priya formally noted this — and Marcus's calibration committee then declined her promotion to Staff on grounds of insufficient product-level impact. Kasia contested the reasoning as circular in the written record. The grievance is unresolved.

## Pattern (Sam's framing)

Commercial / strategic decisions have repeatedly been announced on timelines that engineering is then asked to absorb, **without engineering in the room at finalisation.**

Examples:
- Reporting tool migration (late 2024) — joint Sam + previous VP Engineering call, no parity at cut-over → Northwind + Hartfield churn (£312k+ ARR)
- AI-First commitment (January 2026) — public CEO commitment, prototype not yet productionised, engineering not in the finalisation room

This pattern predates Simon's tenure but lives in current decisions (Q2 design-partner deadline, August demo).

## What Engineering Has Learned (and what Simon inherits)

- Tom Okafor: cautious for legitimate reasons; not a blocker — a quality filter. Watched both prior failures.
- Kasia Nowak: does not currently trust London product to make commitments she can deliver.
- Priya Nair: trust debt from being told twice not to build the prototype now central to company strategy.
- Wei Chen: candid about engineering reality; honest documentation of what hasn't been scheduled (see `engineering.md`).

## What's Missing (still)

- Formal bias audit protocol (only Priya's benchmark suite exists)
- ML observability (drift, fairness, latency, prediction quality monitoring)
- Customer consent flow for AI-driven decisions
- Explainability layer (referenced in strategy, not built)
- Updated data governance policy covering LLM/AI use

See `governance.md` for full policy gap detail.

## Sources

- `intelligence/docs/raw/predecessor-handoff-memo.md`
- `intelligence/docs/raw/priya-360-review-2025.md`
- `intelligence/docs/raw/customer-escalation-northwind-bank.md`
- `intelligence/docs/raw/ceo-ai-first-memo.md`
