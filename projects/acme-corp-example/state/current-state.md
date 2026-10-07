---
project: Acme Corp
last-updated: 2026-05-06
updated-by: ctx-synthesise
---

# Current State

The current snapshot of the project. Living synthesis.

_Updated by os-save, ctx-synthesise, and ctx-doc. Primary context loaded at session start._

---

## Acme Corp

Onboarding into Acme Corp as new Head of Product — AI; navigating an organisation publicly committed to AI-first with a CEO-driven conference demo on the runway.

**Goal:** Establish AI as a credible, delivering product capability at Acme Corp — move from public AI-first commitment to operational reality, with customer-trusted production features shipped, London and Warsaw working as one engineering org, and a sustainable AI product team and operating model in place by end of year one.

_Synced from `projects.md`. Edit there._

---

## Project Position
_Last updated: 2026-05-04 via os-save (end of day 1)_

**Where we stand:** End of week-one listening tour. Six 1:1s done in a single day, plus four weeks of #london-senior Slack scrolled back. Three concurrent and aligned conditional commitments from Tom, Kasia, and Priya — all asking for the same behaviour: engineering involved from day one, a named London owner of the AI programme, follow-through over promises. Marcus is the sole outlier on Priya's standing and is positioning as expectation buffer rather than programme owner. Eight further enterprise accounts at material churn risk per Johnny's 26-Apr exec disclosure (chat-only — never raised in any 1:1).

**Primary goal:** Make the Warsaw prototype-to-HTR Europe demo a real, named programme with engineering ownership from day one. This single decision defuses every urgent flag at once: closes Priya's flight clock by responding to her three-time proposal, gives Kasia the named London owner she explicitly asked for, lets Tom resolve his three architecture prerequisites against a real artifact, and addresses the conference scope vacuum.

**Key constraint or risk:** Priya's 2–3 month evaluation window is already running from 2026-05-04. She has an active conversation with another company. Lose her and the technical foundation for AI-First leaves with her. Marcus's "finding her feet a bit" framing — contradicted by Tom, Kasia, the 360 panel, and Priya herself — is the leading indicator that authority for AI delivery may not flow cleanly from CPO down.

---

## What We Know From Documents
_Last updated: 2026-05-05 via ctx-doc_

Synthesised from 21 source documents — company about page, CEO memo, all-hands transcript, Q1 board update, Series C investor letter, 2026 strategy deck, conference brief, JD, predecessor handoff memo, Priya's 360 review, customer escalation, data governance policy, engineering tech stack, org chart, product roadmap, and 6 LinkedIn bios.

**Company snapshot.** Founded 2018. London HQ + Warsaw R&D hub. 180 people. Series C £42M closed Q3 2024. ARR £18M (Q4 2025), targeting £24M FY 2026 (33% growth). NRR 108%, logo retention 94% (target ≥95%, primary watchpoint). 36-month runway. 220+ enterprise customers, 4M+ applications/year. Northwind Bank (£312k) and Hartfield Retail Group both churned in 2025-26 traced to legacy reporting deprecation without parity.

**The strategic bet.** "AI-First by 2026" — public CEO commitment, on the website + Series C deck, board signed off. Three pillars: (1) AI candidate matching, flagship — public demo at HR Tech Reimagined Europe 9 Aug 2026, design-partner production launch end Q2; (2) workflow intelligence — H2 / Q1 2027 beta; (3) candidate experience — end 2026. Three of top 30 accounts already requesting AI briefings. Naming inconsistency: "AI-First by 2025" survives in some assets despite the 2026 delivery target.

**The technical reality.** AI candidate matching prototype works (embedding-based, fine-tuned on 18 months of Acme data, in Warsaw applied research squad under Kasia Nowak). **Production lift estimated at 8–10 weeks; not formally started as of late April 2026.** Missing: production ML serving, tenant isolation for models, ML observability, security review, formal bias audit protocol, explainability layer, customer consent flow.

**The governance vacuum.** Data Governance Policy v2.1 is six months overdue for review. Explicitly does NOT cover LLM/AI use with customer or candidate data, third-party AI services, candidate consent for AI screening, explainability for AI hiring decisions, or bias auditing. Two enterprise customers using ChatGPT directly with candidate data, no Acme oversight (raised by James at Q1 all-hands; Johnny deferred — outcome unresolved).

**Org structure tensions.** No dedicated AI org line — all AI work sits in Kasia's Applied Research squad (~3 people including Priya). No exec-level Head of AI. Customer Success reports to COO (Sarah Mensah), structurally isolated from Product and Revenue — informal CS→Product loop. ~80% of engineering in Warsaw; 100% of product in London. Two vacant Senior PM seats on Simon's team (Core Platform open since Apr 2026; AI & Workflow open since Nov 2025, Marcus interim).

**Inherited dynamics (per Sam Reilly's handoff memo).** Two prior AI failures at Acme: skills-extraction CV screening (shipped Oct 2024 without bias audit, pulled Dec 2024); auto-generated outreach drafts (committed externally pre-customer-testing, didn't ship 2025). The candidate-matching prototype now central to AI-First was twice deprioritised (Sam, on Marcus's direction) when Priya brought it in 2025. **Priya signed her H2 2025 review under protest** after Marcus's calibration committee declined her Staff promotion — Kasia formally contested the reasoning as circular. **Trust debt with both Kasia and Priya.** Pattern Sam identified: commercial commitments made without engineering in the room at finalisation.

**Sam's recommended first six weeks:** listen first month; visit Warsaw in Month 1; written delivery constraints to Elena, quarterly; decision log from Day 1; structured weekly with James Whitfield; acknowledge prior AI failures publicly to engineering.

**Hard external commitments inherited:** AI candidate matching live with ≥1 design-partner enterprise customer by end Q2 (~7 weeks from start, no customer identified); CEO keynote at HR Tech Reimagined Europe 9 Aug 2026 with live demo (~14 weeks); Johnny's 7 June investor update will reference Simon's first six weeks publicly. Go/no-go on stage demo: 24 July (Marcus + Wei + Elena joint). Fallback: video walkthrough.

**Sources:** `business.md` · `strategy.md` · `product.md` · `roadmap.md` · `engineering.md` · `governance.md` · `org.md` · `stakeholders.md` · `customers.md` · `competitive-landscape.md` · `events.md` · `risks.md` · `role.md` · `ai-history.md` · `okrs.md` · `hiring-priorities.md`

---

## Stakeholder Dynamics
_Last updated: 2026-05-06 via ctx-synthesise_

**Current read:** Six week-one listening tour interviews plus a four-week senior Slack export reveal an organisation publicly committed to AI but operationally fractured around how to deliver it. Tom (engineering), Kasia (Warsaw), and Priya (data science) hold the technical capacity and have offered Simon three aligned, conditional professional contracts — all asking for engineering involvement from day one and a named London owner of the AI programme. Marcus (CPO and Simon's manager) is positioning as expectation buffer rather than programme owner, and is the sole outlier on Priya's standing — a reading contradicted by everyone else who works with her. Elena (CRO) is driving commercial momentum harder than product can deliver and will commit Acme externally if not given a structured input mechanism.

**Key positions:**
- **Marcus Webb (CPO):** AI programme is real and board-aligned. Expectation management between board/CEO and engineering is Simon's job. Priya is "finding her feet a bit." London-Warsaw relationship is solid. Defers cross-functional conflicts (governance to Esme, demo definition deferred 24-Apr).
- **Tom Okafor (Eng London):** Stability first, AI second. Three architecture prerequisites unresolved (model placement, customer data in prompts, testing for non-deterministic outputs). Conditional offer of full support if engineering is involved from day one. Priya marginalised and shouldn't have been. Will say so if it goes the other way.
- **Elena Sousa (CRO):** Revenue first. AI story is huge in deals; product needs to catch up. Wants to "be involved in shaping" the conference demo. Acknowledges historical product-sales misalignment as past tense. Engineering needs to be pushed on velocity.
- **Kasia Nowak (Eng Warsaw):** Working candidate matching prototype, demo-ready, 8–10 weeks to production. Built unofficially because official process kills work. Two engineers left after reporting feature cancellation. Single most important ask: a named London owner with decision authority. Trust is conditional and Tom-mediated.
- **Priya Nair (Data Science):** Three times proposed candidate matching, deprioritised twice. Eight months in with nothing in production. Has had an external conversation. Watching for "an actual different pattern" over 2–3 months. James↔Priya gap named unprompted.
- **James Whitfield (CS):** Two enterprise churns were product failure not market conditions; CS knew. Cancelled reporting feature substitute is not equivalent. CS team using ChatGPT informally with customer data, no governance review. AI should improve workflows customers already use, not be a new feature.
- **Johnny Rotten (CEO, chat-only):** Owns public AI commitment. Disclosed in 26-Apr exec meeting that 8 further accounts at material churn risk. Instructed "be honest with him from day one." Held back by Marcus on accelerating Simon's start.

**Tensions:**
- Conference scope vacuum: 5 of 6 interviewees + chat say no one has been formally briefed; Elena and Marcus are the ones positioned to fix it and neither has.
- Priya's standing: Marcus alone reads her as developmental; everyone else (Tom, Kasia, James, 360, Priya herself) reads her as marginalised.
- Engineering excluded from commercial commitments: structural pattern named by Tom, Kasia, Elena (acknowledged), James, and Sam Reilly's handoff. Marcus frames it as Simon's calibration job, not a structural failure.
- London-Warsaw relationship: Marcus reads as solid; Tom, Kasia, Priya read as fragile and structurally under-supported.
- Marcus as buffer vs owner: explicitly scoping expectation management to Simon while deferring on demo definition (24-Apr) and governance (13-Apr).

**Who to watch:**
- **Priya** — 2–3 month flight clock running; how Simon handles the candidate matching proposal is the trust signal she has chosen.
- **Marcus** — whether the demo-types paper (committed 24-Apr) lands and whether his Priya framing softens with cross-evidence.
- **Elena** — what she has already told top-30 accounts about AI; whether next external commitment runs through engineering.
- **Tom** — his conditional offer is the most actionable in the listening tour; treat as a structural commitment.
- **Johnny** — not yet met directly; his read on Marcus and the CPO-CEO dynamic is load-bearing and unobserved.
- **Esme & Sarah** — both engaged via the chat governance escalation; James's CS ChatGPT disclosure flows to them.

---

## Standing Decisions
_Last updated: 2026-05-04 via os-save_

| Decision | What was decided | Why it matters |
|----------|-----------------|----------------|
| Listening tour week, not delivery week | First 4-6 weeks frame is to listen + diagnose, not commit to direction. Per Sam Reilly's handoff. | Resists pressure to set direction in Week 2; preserves credibility with engineering who have watched the previous two AI failures land badly. |
| Decision log from Day 1 | Every material call captured here in current-state.md (Standing Decisions row + In Flight bullet) and in session memory. | Sam's #4 explicit recommendation. Protects against "no one remembers what was decided" pattern that hurt prior initiatives. |
| Written delivery constraints to Elena, quarterly | Quarterly written summary of what engineering can/can't deliver against external commitments Elena is making. Be unsentimental. | Sam's #3 recommendation. The single biggest lever on the structural product↔commercial gap that has driven prior failures. |

---

## In Flight
_Last updated: 2026-05-04 via os-save_

- **Schedule Warsaw visit** — Sam's #2 priority; Kasia explicitly asked for it and described it as "a gesture she will value." Tom can facilitate. Target: bring forward to Month 1.
- **Establish weekly with James Whitfield** — Sam's #5; James is the documented customer-reality canary. Critical given AI governance disclosure (CS using ChatGPT with customer data) is now Simon's to own.
- **Acknowledge the two prior AI failures publicly to engineering** — Sam's #6. Skills-extraction (pulled Dec 2024) + auto-outreach (didn't ship 2025). Pre-condition for re-engaging trust with Tom + Kasia + Priya.
- **Identify design-partner enterprise customer for AI candidate matching** — End-Q2 OKR depends on it; no customer named as of late April. Joint owner: Vinod Mehta + Simon. Hard deadline 22 Jun.
- **Verify reporting-line ambiguity** — Kasia said "I report to Tom" in her 1:1; org chart says Wei Chen. Affects authority + escalation paths for the AI programme.
- **Confirm AI governance v1 scope** — Esme's policy published 1 May (Simon's start); James disclosed 4 May that CS team is using ChatGPT with customer data informally. Verify whether the v1 policy covers this disclosed practice or leaves it open.
- **Resolve Tom-Aditi reporting parity estimate gap** — Tom: end of Q1. Aditi: Q1 + 4 weeks. Determine which is right; affects Q2 capacity.
- **Respond to Priya's third proposal of candidate matching** — She raised it again in the 1:1 with full product logic. How Simon responds is the trust signal she will use to evaluate "an actual different pattern" over the next 2-3 months.

---

## Open Questions / Blockers
_Last updated: 2026-05-04 via os-save_

1. **Does Marcus see his role as expectation buffer (not programme owner)?** He framed expectation management as Simon's job, deferred on demo definition (24-Apr chat), forced Esme to escalate governance publicly. Test in Week 2.
2. **Is Marcus's Priya read motivated or limited-visibility?** "Finding her feet a bit" is the only contrary voice. He made the call to deny her promotion AND twice deprioritised her prototype. Confirms or refutes the buffer-not-solver hypothesis above.
3. **Which 8 enterprise accounts are at material churn risk?** Disclosed by Johnny at 26-Apr exec meeting. Not surfaced by Marcus or Elena in their 1:1s. Get the list.
4. **What scope is the August demo committed to?** Tom hasn't been briefed. Kasia heard from Priya, not London. Priya found out the day before her 1:1. Elena is selling against an undefined demo. Marcus deferred 24-Apr. Owner is missing.
5. **Workflow intelligence PRD** — ownership floating; Q3 beta target depends on PRD landing early Q2. Simon writes it, hires for it, or slips it?
6. **Two vacant Senior PM seats** — Core Platform (open since Sam's exit 2026-04-09) and AI & Workflow (open since 2025-11, Marcus interim). Hire fast with low context, or restructure?
7. **Candidate experience pillar (third AI-First pillar)** — no discovery started. Start now or post-Q2?

---

## Recent Changes
_Last updated: 2026-05-04 via os-save_

- **2026-05-04** — Listening tour day. Six 1:1s back-to-back (Kasia 09:00, Marcus 10:00, Priya 10:00, James 11:00, Elena 14:00, Tom 15:00). Cross-synthesis surfaced the Warsaw-prototype-to-conference single-decision insight + 4 urgent flags + 9 hypotheses + 12 open questions.
- **2026-05-01** — Joined Acme Corp. Added to #london-senior Slack at 14:02. Scrolled back through the prior 4 weeks: Sam Reilly resignation, governance escalation by Esme, Northwind Bank churn aftermath, AI demo definition impasse — all observed retrospectively before any direct interaction.
- **2026-04-29 to 2026-04-30** — Pre-start prep. Read 21 source documents (CEO memo, Q1 board update, predecessor handoff, strategy deck, 360 review, customer escalation, governance policy, tech stack, org chart, roadmap, conference brief, investor update, all-hands transcript, 6 LinkedIn bios). All processed via /ctx-doc, synthesised into 16 topical context files.
- **2026-04-16** — Marcus forwarded Sam Reilly's handoff memo with Sam's permission. Most candid single source on stakeholder dynamics + AI history Simon has.
