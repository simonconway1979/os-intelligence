---
title: The orchestrator — a loop whose only output is claims
date: 2026-09-19
status: design note, not built. The test in section 8 is PROPOSED and its parameters are provisional. They lock after the first hand-run (section 9); any change after that is logged here with its date.
licence: Apache-2.0 (see LICENSE and NOTICE at the repository root)
author: Simon Conway
---

# The orchestrator

OS-Intelligence keeps four jobs apart: **skills** save and stamp sources; one **extractor** turns sources into claims; **readers** interpret claims and write proposals to their own sidecar files; **people** decide what becomes the record. Nothing an agent writes becomes the record by itself.

This note adds a fifth part. One rule: **the orchestrator decides which skill runs next. It writes nothing but raw run output and an event line. Claims come from the extractor. Understanding comes from readers. Promotion stays human.**

A loop without a ledger is a chat window with connectors. A ledger without a loop is an empty filing cabinet. This note specifies the loop.

```
triggers ─► SCHEDULER ─► skill run ─► raw + event line ─► EXTRACTOR ─► claims (pending)
               ▲                                                          │
               │                                                          ▼
        rankers score ◄── gaps · contradictions · open questions ◄── READERS ─► sidecars
                                                                          │
                                                       person: kept / rejected ─► project record
```

## 1. The workspace (generic shape)

Visible, plainly named, inside the project it serves. The person whose project it is can open every file. Nothing in it is project record.

```
<project>/agent/
  README.md            the rule: nothing here is project record until a person keeps it
  runs/NNN-<skill>-<slug>/raw.md      one folder per run, never edited
  claims/NNN-<slug>.md                extractor output, one block per claim
  ledger.md            index: one row per claim + state + edges
  understanding.md     programme reader sidecar: the current read, size-budgeted
  understanding-log.md per run: what changed and why, by claim ID
  questions-queue.md   what to ask the person next, ranked, with the reason
  orchestrator-log.md  per run: trigger, ranker scores, skill chosen, cost, stop check
```

## 2. The ledger contract

Every claim has one of three states: **pending** (extractor wrote it, no person has seen it) · **kept** (a person accepted it; it may now be copied into the project record by the human step) · **rejected** (stays, with the reason; training data).

Two profiles of the same claim block:

- **Full profile (a personal workspace):** `id` · `claim` · `type` (observation | interpretation | hypothesis | assumption | decision) · `level` · `source` · `provenance` (raw | session-record | inference) · `entities` · `state` · `reverse-if` (decisions only) · `supersedes`.
- **Team profile (any shared or client repo):** `id` · `claim` · `tag` (evidence | assumption | decision) · `source` (run ID + verbatim quote + link) · `date` · `ledger-state` (pending | kept | rejected) · `bears-on` (risk or question ID). No `type`, no `confidence`, no `reverse-if`. A shared repository sees the protocol and three plain tags, nothing finer.

Edges (`supports` / `contradicts` / `supersedes`) are reader output. They live in `ledger.md`, never in the claim block.

## 3. Triggers

1. **Event:** the person adds a source, answers a question, or saves.
2. **Gap:** a reader reports a ranked risk with no evidence on one side.
3. **Contradiction:** two claims on the same subject disagree.
4. **Staleness:** a kept claim's source is older than the project's threshold.
5. **Heartbeat:** a timer that only checks triggers 2–4. It never runs a skill on its own.

## 4. Scheduler over rankers

Each ranker scores candidate next runs from 0 to 1 and gives one sentence of reason. The scheduler takes the top candidate, writes the reason to `orchestrator-log.md`, and runs one skill.

| Ranker | Scores high when |
|---|---|
| **risk-coverage** | a top-three risk has evidence on only one side |
| **contradiction** | an unresolved `contradicts` edge touches a top risk |
| **question-yield** | a refine question is still unanswered and the answer would move a ranking |
| **novelty** | the last run of this skill on this subject produced claims that survived |
| **cost** | (negative weight) the skill is slow or uses an external source |

## 5. Stop rule

Stop when any of these holds. Log which one.

- Two consecutive runs produce no new claim that changes a ranking in `understanding.md`.
- The budget is spent.
- The questions queue holds more than five unanswered items. The loop waits for the person. It does not run ahead of them.

## 6. Budget

Per project per day: a run count, a token ceiling, an external-call ceiling. Defaults: 6 runs, set per deployment. Every run logs its cost. No budget, no loop.

## 7. Boundaries

- Nothing agentic writes to the project record. Ever.
- The workspace is disclosed, never discovered. The person can read, correct and delete it.
- The unit in a team repo is the project and the team. No claims about a person's performance, pace or habits. No people reader.
- The orchestrator never contacts anyone. Questions go into the queue and surface when the person next opens the project.

## 8. Pre-registered falsification test (PROPOSED — Simon signs or amends before any build)

**Claim under test:** a loop that runs skills against a ledger gives a person better answers on synthesis questions than the same skills run by hand without it.

**Design:** freeze a corpus and a layer built over it. A domain owner writes ten questions (five synthesis, five lookup) and the answer key from the raw files, not from the claims. Run both conditions blind. Score fact coverage, source coverage, unsupported facts. The programme lead picks the answer they would act on.

**Pass:** on the five synthesis questions: equal on facts, +20 points on sources, no more unsupported facts.

**Fail, and what failing means:** anything less. The loop is then not built; the skills stay hand-run.

**Orchestrator-specific check (added here):** on a replay, the scheduler's chosen run is compared with the run a person would have chosen at the same point. Below 60% agreement over 20 decisions, the rankers are wrong and the loop does not ship.

**Prior, stated before the run:** 35% lookup / 55% synthesis / 70% on a real corpus after four weeks.

**Not evidence:** demand. A sponsor asking for this is not the test passing. A hand-built demonstration is not the test passing.

## 9. Hand-simulation protocol

Before any code, the loop can be run by a person acting as scheduler: pick the next skill by the ranker table, run it, extract claims in the team profile, update the ledger, rewrite `understanding.md`, log what changed. The demonstration must say it is hand-run in its first sentence. The logs from a hand run are the first replay set for the check in §8.
