---
project: acme-corp
last-updated: 2026-05-05
updated-by: ctx-doc
tags:
  - type/context
  - project/acme-corp
  - status/synthesised
---

# Engineering — Acme Corp

## Platform Architecture

- **Core:** Python/Django modular monolith (services split out for search, notifications, analytics)
- **Frontend:** React (recruiter, candidate, admin apps)
- **Hosting:** AWS Frankfurt (EU data residency)
- **Data stores:** PostgreSQL (primary), Elasticsearch (search + vector store), Redis (cache/queues)

## Teams (~75 engineers)

Reports up to David Lindqvist (CTO) → Wei Chen (VP Engineering).

| Hub | Lead | Headcount | Scope |
|---|---|---|---|
| **London** | Tom Okafor (Head of Eng, London) | ~24 | Backend platform (Django), frontend apps, integrations (Workday, Greenhouse, M365, Google Workspace, Slack, Zoom), data pipeline / ETL |
| **Warsaw** | Kasia Nowak (Head of Eng, Warsaw) | ~40 | 5 squads: Core Platform, Search & Match, Workflow Engine, ML Infrastructure, Applied Research |
| **Distributed** | Cassandra Patel (Head of DevOps & Infrastructure) | ~6 | AWS, CI/CD, observability, security |

**Concentration:** ~57% of engineering is in Warsaw. All AI/ML work sits there.

## Applied Research Squad (Warsaw, under Kasia Nowak)

- Priya Nair (Data Scientist) + 2 applied researchers
- Owns AI candidate matching prototype + bias benchmark suite + cross-tenant evaluation framework

## Strengths

- 99.95% uptime over 12 months
- Scaled 50 → 220+ customers since 2022 rebuild without major architectural changes
- Search & match: sub-200ms p95 at current scale
- Tenant isolation: mature, no cross-tenant data leak in company history
- ISO 27001 + SOC 2 Type II (renewed annually, no findings)
- Strong applied research practice; well-developed evaluation harness

## Known Weaknesses / Tech Debt

- **Reporting product (late 2024 rebuild):** Functional parity gaps at cut-over — see `product.md`
- **Workday connector:** API rate limit changes broke behaviour; v2 not until end Q3 2026; workaround in place
- **Reporting query performance:** Issues at high scale (400+ concurrent open requisitions); Q1 fix in flight (Tom's team)

## AI Candidate Matching — Production Gap

What exists:
- Fine-tuned transformer on ~18 months of Acme Corp historical data
- Elasticsearch vector store (isolated from production)
- Bias benchmark suite (Priya Nair, 2025)
- Evaluation harness + held-out test set

What does NOT exist:
1. Production ML serving layer
2. Tenant isolation for customer-specific data and models
3. ML observability (drift, latency, fairness, prediction quality)
4. External security review
5. Formal bias audit protocol
6. Documented explainability layer
7. Customer consent flow for AI-driven candidate ranking

**Estimated lift:** 8–10 weeks of concentrated Warsaw squad work. Not formally started as of late April 2026 (Wei Chen, in `engineering-tech-stack.md`).

## Engineering View on AI-First Timeline (Wei Chen)

- August 2026 conference demo: tight but achievable
- Q2 design-partner customer launch: tight; depends on resource decisions not yet made; critical work not scheduled

## Sources

- `intelligence/docs/raw/engineering-tech-stack.md`
- `intelligence/docs/raw/org-chart.md`
- `intelligence/docs/raw/ceo-ai-first-memo.md`
- `intelligence/docs/raw/all-hands-2026-q1-transcript.md`
