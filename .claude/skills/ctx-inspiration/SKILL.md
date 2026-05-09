---
name: ctx-inspiration
description: Process new files in the global inspiration library. Updates INDEX.md, appends to or rewrites synthesis files, runs quality checks, logs outcomes by job type. Run whenever new content is added to context-library/inspiration/raw/.
---

# /ctx-inspiration — Inspiration Library Enrichment

Processes new files in `context-library/inspiration/raw/`. Keeps INDEX.md current, builds and maintains synthesis files by theme, evaluates synthesis quality, and logs how the library is used so it improves over time.

---

## When to run

- You've added new files to `context-library/inspiration/raw/` (transcripts, articles, social posts)
- You want to check the library is up to date before starting a campaign or idea session
- You want to trigger a full synthesis for a theme after several appends

---

## Step 1 — Find unprocessed files

Scan all subfolders of `context-library/inspiration/raw/` for files where `enriched:` is blank or missing.

Show:
```
Found [N] unprocessed file(s):

  transcripts/
    — [filename] — [title from frontmatter or "untitled"]

  articles/
    — [filename]

[M] already enriched (skipping).

Process all [N], or specific ones?
```

Wait for confirmation. Process files one at a time — do not read all files upfront.

---

## Step 2 — Complete frontmatter

For each file, read it and check the full schema is populated:

```yaml
title:          # required
channel:        # required
host:           # required (unknown if not identified)
guest:          # required (unknown if not identified)
summary:        # required — 1-2 sentences
themes:         # required — use controlled taxonomy
topics:         # required
tone:           # required
format:         # required
audience:       # required
project-relevance:  # required
enriched:       # leave blank — filled in Step 9
```

For any missing required field: read the file content and fill it in. If genuinely unknowable (e.g. host of an article), use `unknown`. Do not ask the user for fields Claude can infer from the content.

Tag taxonomy for reference:
- **themes:** `AI-agents`, `automation`, `productivity`, `content-strategy`, `personal-OS`, `personal-knowledge-management`, `OpenClaw`, `agent-architecture`, `no-code-AI`, `startup-ideas`, `AI-tools`
- **tone:** `practical`, `educational`, `inspirational`, `technical`, `conversational`
- **format:** `interview`, `tutorial`, `explainer`, `essay`, `case-study`, `list`
- **audience:** `beginners`, `practitioners`, `technical`, `non-technical`, `executives`
- **project-relevance:** standalone project slug (`pm-os`), portfolio root (`ideas`), or portfolio item (`ideas/autonomous-agents`)

---

## Step 3 — Update INDEX.md

Read `context-library/inspiration/INDEX.md`.

- If the file already has a row (match on filename): update it with any frontmatter changes
- If not present: add a new row using this format:

```
| [filename-link] | [title] | [themes, comma-separated] | [tone] | [project-relevance] | [summary — one line] |
```

File in the correct section by type (`## Transcripts`, `## Articles`, `## Social`). If the section doesn't exist yet, create it.

Update `total-files:` in frontmatter.

---

## Step 4 — Synthesis: evaluate before writing

For each theme in the file's `themes` frontmatter:

### If no synthesis file exists for this theme:
This is a first-source situation. Go directly to **Full Synthesis** (Step 6). No evaluation needed.

### If synthesis file exists:
Read `context-library/inspiration/synthesis/[theme].md`. Run three evaluations:

**Eval 1 — Source count threshold** *(frontmatter read only)*
Read `appends-since-synthesis:` from synthesis frontmatter.
- If ≥ 5: flag as `THRESHOLD_HIT`

**Eval 2 — Gap closure check** *(section read only)*
Read the `## Gaps` section of the synthesis.
- Check if the new file's `topics` or `themes` frontmatter matches any listed gap.
- If yes: flag as `GAP_CLOSED` (the synthesis body doesn't reflect this yet — structural drift)

**Eval 3 — Contradiction signal** *(reasoning task)*
Read the existing `## Key Patterns` section and the new file's `summary` field.
- Ask: does any new insight make an opposing claim about the same topic as an existing pattern?
- Look for: same subject + negating language ("without", "no longer", "contrary", "unlike", "doesn't require")
- If found: flag as `CONTRADICTION_DETECTED` and note which pattern(s) are in tension

**Show evaluation results:**
```
Synthesis evaluation — [theme]

  Appends since last full synthesis: [N]  [THRESHOLD_HIT if ≥5]
  Gap closure detected: [yes/no — which gap]
  Contradiction signal: [none / "New source contradicts Pattern 3: ..."]

Recommendation: [Append / Full synthesis recommended]
```

If any flag is raised: recommend full synthesis. Let the user decide:
```
One or more signals suggest a full synthesis may be needed. 
Run full synthesis, or append anyway? (full / append)
```

Default to append unless user says full.

---

## Step 5 — Append mode

Extract from the new file (read the full content):

- **New Key Pattern(s):** 1-2 distinct patterns not already present in the synthesis. Skip if the insight is already captured.
- **Notable Quotes:** any quotes worth preserving verbatim
- **Content Angles:** 1-2 specific angles this source enables (format: `Angle — Format — Relevant Campaign`)
- **Gap updates:** remove any gaps that this source now fills; add new gaps it reveals

Append under each relevant section, with a source attribution line:
```
*Source: [title](../raw/transcripts/filename.md) — added [date]*
```

Update synthesis frontmatter:
```yaml
appends-since-synthesis: [increment by 1]
sources: [add this file to the list]
```

---

## Step 6 — Full synthesis mode

Read ALL source files listed in the synthesis frontmatter, plus the new file.

Rewrite the synthesis completely using this structure:

```markdown
---
theme: [theme]
last-full-synthesis: [today]
appends-since-synthesis: 0
sources:
  - [all source file paths]
relevant_to: [union of all project-relevance values across sources]
---

# Synthesis: [Theme]

Cross-source patterns, key ideas, and content angles. [N] sources as of [date].

## Key Patterns
[Numbered list — each pattern is a distinct, named insight. No duplicates.]

## Notable Quotes
[Verbatim quotes worth preserving, with attribution]

## Content Angles
| Angle | Format | Relevant Campaign/Project |
|-------|--------|--------------------------|

## Gaps / Open Questions
[What's still missing. What would strengthen this synthesis.]

## What to Add Next
[Types of sources that would add most value]
```

After rewriting: run the **Quality Sub-Agent** (Step 7).

---

## Step 7 — Quality sub-agent (full synthesis only)

After a full synthesis, evaluate it against five criteria. Do not show working — show results only.

| Check | Pass/Fail | Notes |
|-------|-----------|-------|
| Coverage | ✅/⚠ | Are all listed sources represented in Key Patterns? |
| Distinctness | ✅/⚠ | Are patterns genuinely separate, or do any overlap significantly? |
| Contradictions | ✅/⚠ | Any unresolved tensions between patterns? |
| Actionability | ✅/⚠ | Are Content Angles specific enough to act on without more context? |
| Gap accuracy | ✅/⚠ | Have previously listed gaps been removed if sources now fill them? |

If any check fails: show what's wrong and offer to fix before moving on.

---

## Step 8 — Update project links

For each entry in the file's `project-relevance:` frontmatter:

**Portfolio item** (e.g. `ideas/autonomous-agents`):
- Find the item's primary file (e.g. `projects/ideas/ideas/autonomous-agents/idea.md`)
- Add or update a `## Sources` section with a wikilink entry:
  ```
  | [title] | [[filename]] | [type] |
  ```
  Wikilinks resolve by filename in Obsidian without needing full paths.

**Portfolio root** (e.g. `ideas`, `content-engine`):
- No automatic file update — the INDEX.md serves as the reference point.

**Standalone project** (e.g. `pm-os`):
- No automatic file update unless the project has a `context/inspiration-sources.md` file. If it does, add the file there.

---

## Step 9 — Mark enriched

Update the raw file's frontmatter:
```yaml
enriched: [today's date]
```

---

## Step 10 — Outcome log

Ask:
```
What job did you process this synthesis for? (or skip)

1. content-creation         — writing a post, campaign, blog
2. idea-development         — developing an idea, writing a hypothesis
3. technical-implementation — building a skill, automating a process
4. decision-making          — choosing a direction or approach
5. research                 — deepening understanding of a topic
6. skip
```

If not skipped, ask two more:
```
What did the synthesis give you that helped? What was missing or harder than it needed to be?
(type "none" to skip)
```

```
Did you need to load individual source files to supplement the synthesis? (y/n)
```

This last question is the behavioral signal: if yes, the synthesis didn't fully serve the job — it needed the raw files to fill gaps. Log `went-deeper: yes` in the eval-log. Over time, patterns in `went-deeper` by job type reveal which synthesis sections need more depth for which use cases.

Log to `context-library/inspiration/synthesis/eval-log.md`:

```
| [date] | [synthesis theme] | [job type] | [project from .current-session] | [what helped] | [what was missing] | [went-deeper: y/n] | [eval flags triggered] |
```

---

## Step 11 — Calibration check

Read `eval-log.md`. Count total rows.

If row count is a multiple of 10:
```
[N] outcomes logged. Patterns emerging:

  Most used synthesis: [theme]
  Most common job type: [type]
  Most common "missing" complaint: [if any pattern]

Want to review evaluation thresholds? (y/n)
```

If yes: show current thresholds (source-count ≥5, gap closure, contradiction signal) and invite the user to adjust.

---

## Step 12 — Summary

```
Inspiration library updated

File:           [filename]
INDEX.md:       [added / updated]
Synthesis:      [theme] — [appended / full rewrite]
Quality check:  [pass / N warnings]  (full synthesis only)
Project links:  [N updated]
Outcome logged: [job type / skipped]

Next: [most logical action — e.g. "Run /ctx-inspiration on [next unprocessed file]" or "Start content session with updated synthesis"]
```

---

## Eval-log file format

`context-library/inspiration/synthesis/eval-log.md`

Create if missing:

```markdown
---
last-calibration-check: —
total-entries: 0
---

# Inspiration Library — Outcome Log

Tracks how the library is used and whether synthesis files served the job.
Review every 10 entries to calibrate evaluation thresholds.

| Date | Synthesis | Job Type | Project | What Helped | What Was Missing | Flags Triggered |
|------|-----------|----------|---------|-------------|-----------------|-----------------|
```

---

## Notes

**On synthesis theme matching:**
A file with `themes: [AI-agents, automation]` should update both `synthesis/AI-agents.md` and `synthesis/automation.md` if both exist. If only one exists, update that one and note the other is not yet initialised.

**On full synthesis cost:**
Reading 6 × 30k-word transcripts for a full synthesis is expensive. Prefer reading the first ~200 lines of each (the highest-signal section) unless the quality check reveals a coverage problem. Only read the full file if coverage fails.

**On contradiction signal:**
In v1, the contradiction check is a reasoning task — Claude reads the summary and existing patterns and asks itself if there's a direct conflict. This is imprecise but cheap. Future: use embeddings or structured claim extraction.
