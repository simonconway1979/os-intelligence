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

## Step 1 — Scope and scan

1. Confirm the folder exists and is readable. If not: `Can't read <folder>. Check the path.` and stop.
2. Collect candidate source files: all `*.md` (and `*.txt`) under the folder, **excluding** the output file `current-state.md` itself and any obvious non-source files (`README.md`, `CLAUDE.md`, `INDEX.md`, `_SCHEMA.md`, `LICENSE`).
3. If the folder is empty of source files: `No markdown to synthesise in <folder>.` and stop.
4. **Decide the unit.** If `--per-subfolder`, loop Steps 2–7 once per immediate child folder. Otherwise treat the whole folder as one unit.
5. Note rough size. If there are more than ~60 source files, say so and synthesise the most recent + most referenced first, then state explicitly what was not yet read (no silent truncation).

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
- **Sequence over time.** Newer evidence updates older; say what changed and when. A recent source does not automatically outweigh a repeated pattern — weight repeated signals over fresh anecdotes, and say when a single new source is just a watch item.
- **Separate observation from inference.** Keep "what was said/measured" distinct from "what it might mean."

## Step 4 — Detect staleness

For each section of findings, record the **newest** supporting evidence date and its age relative to today. Flag:
- 🟢 fresh
- 🟡 watch / ageing — re-check soon (fast-moving topics, or a forward commitment with a near date)
- 🔴 stale — the section is materially older than the facts likely are; recommend a refresh

Also flag **hygiene catches** when you find them:
- a source that exists but was clearly never incorporated into prior state (filed, not synthesised)
- an action item or commitment with a due date that has passed without visible closure
- a state file (theirs, or a prior `current-state.md`) whose timestamp is recent but whose substance predates a newer source

## Step 5 — Compound (diff against the prior run)

If a `current-state.md` already exists in the output location, read it first. In the new output, include a **"What changed since last run"** section that names: claims that strengthened, weakened, or self-corrected; new findings; new contradictions; and sections that aged into 🟡/🔴. If there's no prior file, say "first run — baseline." Rely on git for history; the file is overwritten with the new version.

## Step 6 — Write one file

Write `current-state.md` into the unit folder (or chat only, if `--dry-run`). **Touch nothing else.** Use the template below. Every finding carries at least one provenance link or honest tag. All links are **relative to the folder the file is written into** — count the path carefully so they resolve.

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
