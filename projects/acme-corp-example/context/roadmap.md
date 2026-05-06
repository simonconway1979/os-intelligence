---
project: acme-corp
last-updated: 2026-05-05
updated-by: ctx-doc
tags:
  - type/context
  - project/acme-corp
  - status/synthesised
---

# Roadmap — Q1/Q2 2026

Source: `product-roadmap-q1-q2-2026.md` (Marcus Webb interim, 2026-04-19), reconciled with conference brief and Q1 board update.

## Q1 2026 (Jan–Mar) — In Flight

| Workstream | Owner (PM / Eng) | Status |
|---|---|---|
| Legacy reporting parity gap closure | Aditi Kapoor / Tom Okafor | 3 of 5 gaps closed; on track |
| Platform stability work | Marcus interim / Tom Okafor | On track |
| AI candidate matching prototype → production lift | Marcus interim / Kasia Nowak | Started; production target Q2 |
| Workday connector v2 | Aditi Kapoor / Tom Okafor | At risk — API rate limit changes |
| Candidate experience polish | Marek Wiśniewski / Tom Okafor | On track |
| Discovery: workflow intelligence framework | — | Concept defined; PRD not written |
| Discovery: AI-generated outreach | — | Revisit only after candidate matching ships |

## Q2 2026 (Apr–Jun) — Critical Path

| Date | Deliverable | Owner | Risk |
|---|---|---|---|
| 23 May | AI candidate matching backend in production-grade env (Warsaw) | Kasia Nowak | **Medium** — security review not started |
| 22 Jun | First design-partner enterprise customer signed | Vinod Mehta + Simon | **High** — customer not yet identified |
| 23 Jun | Keynote draft complete | Diego Ferreira + Johnny Rotten | Low |
| 7 Jul | Design-partner customer onboarded; live AI matching in tenant | Simon + James Whitfield + Kasia | **High** — cascades from prior |
| 23 Jul | Production-readiness dress rehearsal | Wei Chen + Simon + Marcus | High |
| 24 Jul | Go/no-go decision on stage demo | Marcus + Wei + Elena | — |
| 9 Aug | Public demo at HR Tech Reimagined Europe (ExCeL London) | Johnny | Public-failure risk |
| End Q2 | OKR: AI candidate matching live with ≥1 enterprise customer | Simon | Cascading |

## Q2 Secondary Work

- Workflow intelligence beta scope (Simon — PRD due end of April, NOT done)
- North America enterprise pilot sourcing (Vinod, in flight)
- Reporting parity tail items (Aditi)
- Platform debt (Tom, continuous)

## Not on Roadmap (deferred / unscheduled)

- AI-assisted screening (full): H2 inside workflow intelligence pillar
- Bias audit framework: unscheduled, no owner — see `governance.md`
- Candidate consent flow: unscheduled (Legal flagged Q4 2025) — see `governance.md`
- AI explainability layer: in strategy, not in any sprint — see `governance.md`
- Data governance policy update for AI: last reviewed Sep 2024 — see `governance.md`
- Workforce planning / supply intelligence: targeted 2027

## Open Decisions for Simon (Month 1)

1. **Bias audit, explainability, consent flow** — blocking or not blocking design-partner launch?
2. **Two vacant Senior PM seats** — hire, restructure, or fold in?
3. **Workflow intelligence PRD ownership** — Simon writes it, new hire, or slips to Q3?
4. **Reporting parity tail estimate gap** — Tom (end Q1) vs Aditi (Q1 + 4 weeks). Which is right?
5. **Candidate experience pillar (3rd AI-First pillar)** — start discovery now or after Q2 launch?
6. **Design-partner customer for AI matching** — joint sales-product call needed immediately

## Sources

- `intelligence/docs/raw/product-roadmap-q1-q2-2026.md`
- `intelligence/docs/raw/conference-brief-htr-europe-2026.md`
- `intelligence/docs/raw/q1-2026-board-update.md`
- `intelligence/docs/raw/all-hands-2026-q1-transcript.md`
