# SI Timeline — Background Agent Instructions

You are building a project timeline from stakeholder intelligence sources. All inputs have been confirmed. Do not ask questions — proceed through all steps.

---

## Inputs you were given

- `PROJECT_ROOT`, `PROJECT_NAME`, `MODE` (summary / detailed), `FROM_DATE` (YYYY-MM-DD or null)
- `SI_DIR` — `[PROJECT_ROOT]/intelligence/`
- `EVENTS_DIR` — `[PROJECT_ROOT]/events/` (may not exist)
- `MEMORY_DIR` — `[PROJECT_ROOT]/memory/`
- `OUTPUT_PATH` — `[PROJECT_ROOT]/intelligence/timeline.md`

---

## Step 1 — Collect all events

Build a raw event list from all available sources. For each source type, read the minimum needed for MODE.

### 1a — Meetings (`SI_DIR/meetings/`)

Glob all `*/synthesis.md` files. For each:
- Always read frontmatter (first 30 lines): extract `date`, `time`, `topic`, `attendees`, `commitments`, `themes`, `sentiment`
- **Summary mode:** stop here
- **Detailed mode:** also read `## What they said`, `## What they meant`, `## Key quotes`, `## Potential contradictions`

Skip files where `date` < `FROM_DATE` if scope is restricted.

Create an event entry of type `MEETING` for each file.

### 1b — Logs (`SI_DIR/logs/`)

Glob all `*/*/synthesis.md` files. For each:
- Always read frontmatter: extract `date`, `thread`, `participants`, `commitments`, `themes`
- Note: log dates may be ranges (e.g. `2026-02-23_2026-04-13`) — use the END date for chronological placement, but note the full range in the entry
- **Summary mode:** read first 20 lines after frontmatter (`## Conversation arc` summary)
- **Detailed mode:** read full file

Create an event entry of type `LOG` for each file.

### 1c — Events folder (`EVENTS_DIR`)

If `EVENTS_DIR` exists: glob all `*/event.md` files. For each, read in full.

Extract: event date (from filename or file content), event name, speaker(s), venue, ticket status, key decisions.

Classify as `EVENT` — past if date < today, upcoming if date >= today.

### 1d — Key decisions from memory

Read the most recent file in `MEMORY_DIR` (sorted by filename desc, exclude `-reasoning.md`).

From the `## Key Decisions` section: extract each decision with its date (use the session date from the filename `YYYYMMDD`).

Create entries of type `DECISION` for each significant decision. A significant decision is one that changed the project direction, locked in a format, or committed resources. Skip operational micro-decisions.

---

## Step 2 — Build upcoming list

From all sources collected above, identify:

**Known upcoming events:** Any event from 1c where date >= today (2026-04-14).

**Open commitments:** From all synthesis files read in Step 1, collect all `commitments` that appear to be unresolved. A commitment is likely unresolved if:
- It references a future date that hasn't passed
- It's in a recent synthesis file (< 30 days ago) with no obvious completion signal

Do not mark commitments complete unless there's explicit evidence. When in doubt, include them.

**Open questions:** If `SI_DIR/cross-synthesis.md` exists, read it and extract `## URGENT FLAGS` and `## OPEN QUESTIONS`. Include urgent flags in upcoming, open questions in "what comes next."

---

## Step 3 — Write timeline.md

Write to `OUTPUT_PATH`. Overwrite if it exists. Use this structure:

```markdown
---
generated: [TODAY'S DATE YYYY-MM-DD]
project: [PROJECT_NAME]
mode: [summary / detailed]
entries-past: [count]
entries-upcoming: [count]
---

# Project Timeline — [PROJECT_NAME]
*Generated [DD Mon YYYY] · [N] entries*

---

## PAST

[entries in ascending date order — oldest first]

---

## UPCOMING

[entries in ascending date order — nearest first]

---

## WHAT COMES NEXT

[open commitments and next steps]
```

---

### Entry formats

#### Summary mode

**MEETING:**
```
**[DD Mon YYYY]** · MEETING · [Attendee names, comma-separated]
[topic — one line]
[1–2 key commitments if any, indented with ·]
```

**LOG:**
```
**[DD Mon YYYY]** · LOG · [Thread name] ([date range if multi-day])
[One-sentence arc — what happened across the thread]
```

**EVENT:**
```
**[DD Mon YYYY]** · EVENT · [Event name]
[Speaker(s), venue, ticket status — one line]
```

**DECISION:**
```
**[DD Mon YYYY]** · DECISION
[What was decided — one sentence]
```

---

#### Detailed mode

**MEETING:**
```
### [DD Mon YYYY] · MEETING · [Attendee names]

**Topic:** [topic]
**Duration:** [duration] · **Setting:** [setting]
**Sentiment:** [sentiment]

**What happened:**
[3–5 sentences. What was discussed, what was agreed, what shifted. Draw from "What they said" and "What they meant".]

**Key quote:**
> "[quote]"
— [speaker]

**Commitments:**
- [commitment — owner]

**Significant because:** [Why this entry matters for the arc of the project. One sentence.]
```

**LOG:**
```
### [Date range] · LOG · [Thread name]

**Participants:** [names]
**Arc:** [2–3 sentences. How the conversation evolved. What shifted between participants.]

**Key moments:**
- [moment 1]
- [moment 2]

**Commitments:**
- [commitment — owner]
```

**EVENT:**
```
### [DD Mon YYYY] · EVENT · [Event name]

**Speaker:** [name, role]
**Venue:** [venue]
**Tickets:** [status]

**What to know:**
[Key decisions about this event. Format, logistics, what was novel or hard-won. 2–3 sentences.]
```

**DECISION:**
```
### [DD Mon YYYY] · DECISION · [Decision title]

[What was decided and why. 2–3 sentences. Include what was rejected if relevant.]
```

---

### UPCOMING section

Always use this format regardless of mode:

```
**[DD Mon YYYY]** · [TYPE] · [Name/description]
[One line: what it is, who's involved, what needs to happen before then]
```

If date is approximate or unknown: use `~[Mon YYYY]` format.

---

### WHAT COMES NEXT section

Format as a numbered list. Each item: action, owner (if known), urgency signal (if any).

```
1. [Action] — [Owner] · [urgency signal if applicable]
2. [Action] — [Owner]
...
```

Draw from:
- Open commitments identified in Step 2
- Most recent memory file's `## Suggested Next Steps`
- Urgent flags from cross-synthesis.md if it exists

Dedup — if the same action appears in multiple sources, list it once.

Cap at 8 items. Prioritise: overdue commitments first, then upcoming event prep, then forward planning.

---

## Step 4 — Notify

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TIMELINE COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Project:   [Project name]
Mode:      [Summary / Detailed]
Entries:   [N] past · [N] upcoming

Sources read:
  · [N] meetings
  · [N] logs
  · [N] events
  · [N] decisions from memory

File written:
  ✓ intelligence/timeline.md

Notable:
  · [1–2 sentences on the most interesting pattern or fact that emerged from building the timeline — something the user might not have noticed]
```
