---
project: acme-corp
last-updated: 2026-05-05
updated-by: ctx-doc
tags:
  - type/context
  - project/acme-corp
  - status/synthesised
---

# Product — Acme Corp

## Three Pillars

| Pillar | PM | Status |
|---|---|---|
| Core Platform (reporting, integrations, stability) | Aditi Kapoor | Active |
| AI & Workflow (AI candidate matching, workflow intelligence) | **VACANT** (Marcus interim) | Open since 2025-11 |
| Candidate Experience | Marek Wiśniewski | Active |

Two Senior PM seats vacant on Simon's day one. See `hiring-priorities.md`.

## Flagship: AI Candidate Matching

**Demo flow:** Recruiter pastes a job description → system returns top matches in <5s → explainability layer shows why each candidate matched → AI drafts personalised outreach.

**Status (late April 2026):**
- Working prototype in Warsaw applied research squad (Kasia Nowak's team)
- Embedding-based: open-source transformer fine-tuned on ~18 months of Acme Corp hiring decision data
- Vector store: dedicated Elasticsearch instance, isolated from production cluster
- Bias benchmark suite exists (Priya Nair, early 2025)
- **NO production ML serving layer**, NO ML observability, NO formal bias audit protocol, NO explainability layer, NO customer consent flow

**Production lift required (Wei Chen's estimate):** 8–10 weeks of concentrated Warsaw squad work. **Has not formally started as of late April 2026.**

**Q2 OKR:** Live with at least one design-partner enterprise customer by end of Q2 2026.
**Public demo:** HR Tech Reimagined Europe, 9 August 2026 — see `events.md`.
**Owner:** Simon Conway (demo readiness + design-partner launch).
**Go/no-go on stage demo:** 24 July 2026 (joint: Marcus + Wei + Elena).
**Fallback if not stage-ready by 24 July:** Video walkthrough.

## Workflow Intelligence

- Concept defined; PRD not written; ownership floating as of April 2026
- Q3 2026 beta target depends on PRD landing early Q2
- Simon expected to resolve ownership in Month 1

## Candidate Experience

- End-of-2026 target
- No discovery started

## What Is NOT Scheduled

- Bias audit framework for AI features (no owner)
- Candidate consent flow for AI-driven decisions (Legal flagged Q4 2025 — no action)
- AI explainability layer (referenced in strategy, not in any sprint)
- AI-generated outreach (attempted mid-2025, didn't ship; blocked pending candidate matching)
- Full AI-assisted screening: H2 inside workflow intelligence pillar
- Workforce planning / supply intelligence: targeted 2027

## Reporting Product (Legacy Migration)

Acme deprecated its legacy reporting suite in late 2024 when the replacement shipped. Replacement was NOT at feature parity at cut-over — acknowledged internally as wrong (James Whitfield, Jan 2026).

**Known parity gaps (as of Jan 2026):**
- Pipeline-by-source: aggregation bug (~15-20% error). Fix ETA mid-Jan 2026.
- Time-to-fill-by-business-unit: query timeout for >400 open requisitions. Rewrite ETA late Feb 2026.
- Offer-acceptance-by-role-level: legacy taxonomy mapping declared "no longer supported." No committed date.

**As of April 2026:** 3 of 5 gaps closed; remainder in Q3 plan (Tom's London team). 14 customers remain on legacy reporting suite. Migrations frozen.

**Customer consequences:** Northwind Bank churned (£312k ARR), Hartfield Retail Group also churned. See `customers.md`.

**Estimate gap to resolve (Month 1):** Tom (engineering) says end of Q1; Aditi (PM) says Q1 + 4 weeks.

## Workday Connector

- v2 at risk: Workday API rate limit changes (late 2025) broke existing behaviour
- Workaround in place
- v2 targeted end of Q3 2026

## Sources

- `intelligence/docs/raw/product-roadmap-q1-q2-2026.md`
- `intelligence/docs/raw/engineering-tech-stack.md`
- `intelligence/docs/raw/all-hands-2026-q1-transcript.md`
- `intelligence/docs/raw/q1-2026-board-update.md`
- `intelligence/docs/raw/conference-brief-htr-europe-2026.md`
- `intelligence/docs/raw/series-c-investor-update-q4-2025.md`
- `intelligence/docs/raw/strategy-deck-2026.md`
- `intelligence/docs/raw/customer-escalation-northwind-bank.md`
