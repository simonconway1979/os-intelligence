---
name: synthesise
description: Point at a folder of markdown and write one reconciled, provenance-tagged, staleness-aware current-state.md sidecar — the summary-of-summaries that updates and self-corrects across runs. Works on any markdown corpus (call summaries, transcripts, notes, PRDs); imposes no folder structure and edits nothing but its own output file. Use when the user runs /synthesise, asks for a current state / synthesis / "what do we know now" over a folder, or wants a folder's scattered markdown reconciled into one living state file.
user_invocable: true
---

# /synthesise

Read across a folder of markdown and write **one** file — `current-state.md` — that holds the reconciled state of what's known: corroborated findings with provenance, contradictions surfaced (not flattened), per-section staleness, and what changed since the last run.

This is a **memory layer**, not a digest. The difference is the last point: it reconciles against its own previous output, so it compounds and self-corrects across runs. One-shot summarisers can't.

**It is read-only to everything except its own output.** It never edits, moves, or restructures the source files. It imposes no taxonomy. It plugs into whatever the user already has.

---

## Invocation

```
/synthesise <folder>                    # synthesise the folder into one current-state.md
/synthesise <folder> -- <hint>          # hint steers focus (e.g. "this is one customer account")
/synthesise <folder> --per-subfolder    # one current-state.md per immediate subfolder (e.g. accounts/*)
/synthesise <folder> --dry-run          # print the synthesis to chat, do not write the file
```

- `<folder>` is the scope. `current-state.md` is written **into** that folder unless `--per-subfolder` is set.
- Default scope is "this folder and everything under it, as one unit."
- `--per-subfolder` treats each immediate child folder as its own unit (use for account/feature/person trees).

---

## The lens (optional, but the biggest quality lever)

A synthesis is sharper when it knows *for whom and for what*. The hint (`-- <hint>`) sets a **lens** with up to three parts:

- **Vantage** — whose seat to read *from* (e.g. "incoming Head of Product"). Decides what counts as signal. Durable across runs.
- **Occasion** — the decision or moment it serves (e.g. "orient my first six weeks", "prep the renewal"). Forces prioritisation and the "so what". Rotates run to run.
- **Audience** — who *reads* the output. Default = the person running it (private; candid, inferred reads allowed). If the audience is a **team**, strip private/inferred reads, keep contradictions open as decisions rather than reconciling them on one reader's behalf, and make actions assignable by owner.

With no hint, produce a neutral, reader-agnostic synthesis (still reconcile and flag staleness) and say so. With a hint, lead the Position with the vantage's highest-leverage takeaway, and weight findings by relevance to the occasion.

---

## Step 1 — Scope and scan

1. Confirm the folder exists and is readable. If not: `Can't read <folder>. Check the path.` and stop.
2. Collect candidate source files: all `*.md` (and `*.txt`) under the folder, **excluding** the output file `current-state.md` and non-source files (`README.md`, `CLAUDE.md`, `INDEX.md`, `_SCHEMA.md`, `LICENSE`).
3. **Prefer raw; dedupe derived.** Sources are the *raw* originals (transcripts, notes, docs, exports). When one unit appears in multiple representations — a meeting folder with `raw.md` + `synthesis.md` + `validation.md` + `shareable.md`, or a chat present as both a flat export and a processed folder — read **one** representation per unit (prefer `raw`) and skip the rest. They are the same source re-expressed, not independent corroboration; counting them all fakes agreement.
4. **Existing synthesis is the prior, not a source.** Exclude `synthesis.md`, `validation.md`, `shareable.md`, `cross-synthesis.md`, and any prior `current-state.md` from extraction. A prior interpretation belongs in Step 5 (compound against + audit), never Step 2. Reading it as a source makes the skill plagiarise its own earlier output and hides the hygiene catch where a raw file was never reflected in the prior synthesis.
5. If the folder is empty of source files: `No markdown to synthesise in <folder>.` and stop.
6. **Decide the unit.** If `--per-subfolder`, loop Steps 2–7 once per immediate child folder. Otherwise treat the whole folder as one unit.
7. **Note rough size, and pick the mode.** Count the unit's source files. **≤ ~60** → synthesise it as one unit (Steps 2–7). **More than ~60** → do NOT skim-and-skip (that reads a fraction and loses all depth); switch to **hierarchical mode** (next section). Never silently truncate.

## Large folders — synthesise hierarchically (automatic when a unit exceeds ~60 sources)

A big multi-subfolder corpus can't be read well as one flat unit — you blow the context budget and end up skimming a fraction (e.g. reading 30 of 250 files and representing the busiest area at the same shallow depth as a dormant one). When a unit is over ~60 sources, recurse instead of skimming:

1. **Descend.** For each immediate child subfolder that contains source files, synthesise *that subfolder* as its own unit — run Steps 2–7 on it and write its own `current-state.md` inside it. If a child is itself over ~60 sources, recurse again (depth-first) before coming back up. Every leaf unit stays under the cap, so every source file is actually read somewhere.
   - **Keep each subfolder's read in its own context.** If you can dispatch a sub-task / sub-agent per subfolder (fresh context each, returns when its `current-state.md` is written), do — that's what makes this scale without the parent holding every raw file at once. If you can't, process one subfolder fully, write its file, then move on to the next; don't carry all raws forward.
2. **Roll up.** Synthesise the parent's `current-state.md` from the **freshly-generated child `current-state.md` files** (one per subfolder) plus any loose source files sitting directly in the parent. This is a synthesis-of-syntheses: reconcile across areas, surface cross-subfolder contradictions and the portfolio-level position, and **link to each child file** rather than repeating it.
3. **Verify, then report the tree.** Before the roll-up, confirm **every non-empty child subfolder now has its own `current-state.md`** — if one is missing (an easy slip across many subfolders), write it before continuing. The roll-up is only complete once every child exists. In Step 7, list every `current-state.md` written (parent + children) and the total source count covered — this list is the completeness check, not just a report.

**This is the one place a freshly-generated `current-state.md` is read as an input rather than a prior.** A child file written *this run* is the intended roll-up input. The Step 1.4 rule (existing synthesis = prior, not source) still holds for any *pre-existing* file from an earlier run — that's the Step 5 diff target, never a fresh source.

`--per-subfolder` is the explicit, non-recursive version of step 1 alone: one `current-state.md` per immediate child, no parent roll-up. Use it when you want per-area files and deliberately no portfolio-level summary.

---

## Step 2 — Read and extract per source

For each source file, read it and extract:
- **Date** — from frontmatter, filename, or the body. Record the most specific date you can find. If none, mark `(undated)`.
- **What it asserts** — the load-bearing claims, decisions, asks, numbers, and verbatim quotes worth preserving. Prefer specifics (real names, numbers, dates) over paraphrase.
- **Provenance** — the file path, so every claim in the output links back.

Tag each extracted claim honestly with how it's known. Carry these through to the output:
- a link to the source file (strongest)
- `(stakeholder-verbal, <name>, <date>)` — said by a person, no recording
- `(intuition, <date>)` — the author's own read, no external evidence
- `(industry-knowledge)` — accepted background
- `(undated)` / `(unattributed)` — flag rather than invent

**Never fabricate.** Quote verbatim or paraphrase with attribution. Never invent a date, a number, or a source. If you don't know, say so.

## Step 3 — Reconcile across sources

This is the work. Don't just concatenate per-file summaries.

- **Corroborate.** Where multiple sources say the same thing, state it once and cite each supporter by source.
- **Surface contradictions — never flatten.** Where sources disagree, name both sides explicitly with their sources, then reconcile if the evidence supports a reconciliation (e.g. "the single label hid two cases"). If it doesn't, leave the tension open. Do not average dissent into "mixed feedback."
- **Cross-check stated claims against structural sources.** When a source asserts a relationship, status, or fact that another document would independently record — a person's stated reporting line vs the org chart, a "done" / "in production" claim vs the artifact that would show it, a marketing or About-page claim vs the org chart or roster — check the two against each other and surface any mismatch. *Stated ≠ recorded* is itself a finding: it changes an escalation path, an external claim, or a plan.
- **Sequence over time.** Newer evidence updates older; say what changed and when. A recent source does not automatically outweigh a repeated pattern — weight repeated signals over fresh anecdotes, and say when a single new source is just a watch item.
- **Separate observation from inference.** Keep "what was said/measured" distinct from "what it might mean."

## Step 4 — Detect staleness

For each section of findings, record the **newest** supporting evidence date and its age relative to today. Flag:
- 🟢 fresh
- 🟡 watch / ageing — re-check soon (fast-moving topics, or a forward commitment with a near date)
- 🔴 stale — the section is materially older than the facts likely are; recommend a refresh

Also flag **hygiene catches** — run this as a deliberate pass over the sources, not an afterthought. These are the highest-value and most-missed findings:
- a source that exists but was clearly never incorporated into prior state (filed, not synthesised)
- a **dated milestone or commitment that has passed** relative to the run date with no later source confirming it shipped or closed — name it, date it, and mark it unverified; never assume it happened
- an **open loop**: an agreed action, accepted offer, or promised artifact (a paper, a review, an exit interview, a decision) with no recorded outcome — flag the loop even when the thing that prompted it is old
- a **named prerequisite or gate** a stakeholder says must be resolved before the work can proceed (especially "can't be fixed later / retrospectively") — surface it explicitly as a sequencing gate, and say who named it
- a state file (theirs, or a prior `current-state.md`) whose timestamp is recent but whose substance predates a newer source

## Step 5 — Compound (diff against the prior run)

If a `current-state.md` already exists in the output location, read it first. In the new output, include a **"What changed since last run"** section that names: claims that strengthened, weakened, or self-corrected; new findings; new contradictions; and sections that aged into 🟡/🔴. If there's no prior file, say "first run — baseline." Rely on git for history; the file is overwritten with the new version.

Make three behaviours fire explicitly: (a) **self-correct** — where a new source supersedes a prior claim, say the claim weakened or resolved and why; don't carry it forward stale. (b) **Age unmoved flags** — a prior flag with no new evidence gets *louder*, with the elapsed time noted, never silently dropped. (c) **Surface emergent contradictions** — conflicts that exist only because the new input meets the prior state (e.g. a newly-committed date against unchanged unstarted work). The prior is read from the existing `current-state.md` and git history; never re-ingest it as a fresh source.

## Step 6 — Write one file

Write `current-state.md` into the unit folder (or chat only, if `--dry-run`). **Touch nothing else.** In hierarchical mode this runs once per unit — one file inside each synthesised subfolder, plus the parent roll-up. Use the template below. Every finding carries at least one provenance link or honest tag. All links are **relative to the folder the file is written into** — count the path carefully so they resolve.

## Step 7 — Report back

Three or four lines: where it was written, how many sources it reconciled, the one headline finding, and the loudest staleness/hygiene flag. Don't reprint the whole file.

---

## Output template

```markdown
\`\`\`
●●● synthesise
points-at:  <folder>   (<N> sources)
run:        <YYYY-MM-DD>   ·   prior run: <YYYY-MM-DD | none>
mode:       read-only sidecar · source files untouched
\`\`\`

# Current State — <unit name>

> **Position.** <2–3 sentences: where things stand right now, and the one thing that matters most.>

## Reconciled findings
_Last updated: <date> · newest supporting input <date> (<age>)_

1. **<finding>.** <specifics, a verbatim quote if it earns its place.>
   `[<source label> <date>](<relative/path.md>)` · `[<source> <date>](<relative/path.md>)`
2. ...

## Contradictions surfaced & reconciled
_Last updated: <date>_

<Name both sides with sources; reconcile if the evidence supports it; otherwise leave open. Never flatten.>

## What changed since last run
_run <prior date> → run <this date>_

- <claim strengthened / weakened / self-corrected, with why>
- <new finding / new contradiction>
- <sections that aged into 🟡/🔴>

## Open questions
_Last updated: <date>_

- <what's unresolved, and what would resolve it>

## Staleness & hygiene flags
_Last updated: <date>_

- ⚠ <un-synthesised source / slipped commitment / stale-in-substance file, if any>

## Staleness map
_Last updated: <date> · ages relative to run date_

| Section | Newest evidence | Age | Flag |
|---|---|---|---|
| ... | <date> | <n days> | 🟢/🟡/🔴 |

---
_Generated by /synthesise. One file written; all source files untouched. Re-run to reconcile new inputs._
```

Drop sections that have nothing to say (e.g. no contradictions found) rather than padding them. Keep it the minimum viable state file — signal density over completeness.

---

## Anti-patterns

- **Concatenating per-file summaries.** The value is the reconciliation across files, not a list of digests.
- **Flattening dissent.** "Mixed feedback" hides the signal. Name both sides with sources.
- **Fabricating dates, numbers, or sources.** Tag `(undated)`/`(unattributed)` instead.
- **Editing the source files.** Read-only. The only file you write is `current-state.md`.
- **Imposing a taxonomy.** Don't tell the user to restructure their folder. Meet their files where they are.
- **Broken provenance links.** Count relative path depth from the output file's folder before saving; a link that doesn't resolve breaks the audit promise.
- **Silent truncation.** If you didn't read everything, say what you skipped.

---

## Edge cases

- **Huge folder (>~60 sources):** synthesise recent + most-referenced first; state what wasn't read.
- **No dates anywhere:** synthesise without the staleness map; note that dates were unavailable.
- **Mixed languages / messy auto-transcripts:** synthesise anyway; preserve verbatim quotes in original language.
- **`--per-subfolder` with one subfolder having no sources:** skip it, note the skip.
- **Output folder not writable:** fall back to `--dry-run` behaviour (print to chat) and say so.
