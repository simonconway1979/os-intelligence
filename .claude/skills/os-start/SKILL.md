---
name: os-start
description: Load project context and start a session with a compact briefing of recent work and next steps
user_invocable: true
---

# /os-start — Session Start Briefing

Invoked manually with `/os-start` to load project context and get a session briefing.

---

## Output Format

```
PROJECT BRIEF

## [Project Name]

Description: [one-liner from projects.md]
Goal: [goal from projects.md]
[For portfolios: Item: [Item Name] — [stage]]

**Current State** · updated [date]
[2-3 sentence summary drawn from current-state.md Project Position]

**In flight**
- [from current-state.md In Flight section]

**Open questions**
- [from current-state.md Open Questions section]

**Most Recent Session** · [date] (on demand — ask to load)
```

---

## Instructions for Claude

### Step 1: Identify the Active Project

Read `projects.md` and list all Active projects. Ask:

```
What do you want to work on?

1. [Project Name]
2. [Project Name]
[...all active projects...]
N. New project
```

Wait for selection.

If **New project**: run `/os-new-project`, then continue.

If existing project:
- Note the folder path (e.g. `projects/job-opportunities/`)
- Check `**Type:**` in projects.md

**If Type is `project`:** write the project name to `[workspace-root]/.current-session` (one line, e.g. `PM-OS`), then continue to Step 2.

**If Type is `portfolio`:** go to Step 1b.

#### Step 1b — Portfolio drill-down

Read the portfolio's `TRACKER.md`. Extract all active items.

```
Which [item name] will you work on?

1. [Item Name] ([stage])
2. [Item Name] ([stage])

N. Add new [item name]
```

If **Add new**: run `/os-new-item`, then continue.

If existing item:
- Write to `[workspace-root]/.current-session`:
  ```
  [Portfolio Name] / [Item Display Name]
  ```
  Example: `Job Opportunities / Acme Corp — Senior PM`
- Continue to Step 2 with both portfolio root and item folder in context

---

### Step 2: Load Current State

Look for `[project-root]/context/current-state.md`.

**If found:** This is the primary context source. Read it fully. Note the `last-updated` field in frontmatter.

Check each section's `_Last updated:_` timestamp:
- Any section last updated more than 14 days ago: flag as potentially stale in the briefing
- Any section still showing `—`: flag as not yet populated

**If not found:** Note in the briefing: `No current-state.md found. Consider running /os-save after this session to initialise it.` Fall back to Step 3.

For portfolios: also read the selected item's `[item-name].md` frontmatter for `next_action` and `stage`.

---

### Step 3: Load Most Recent Session (fallback or on-demand)

Used as fallback if no current-state.md, or when the user explicitly asks for session history.

Look in these locations in priority order:
1. `[project]/memory/` — files named `YYYYMMDD-HHMM.md` (exclude `-reasoning.md`). Sort descending.
2. `[project]/memory/SESSIONS-INDEX.md` — first data row.
3. `context-library/memory/context-snapshot/` — legacy fallback.
4. `context-library/_CURRENT-STATE.md` — legacy fallback.

Do not load session files automatically when current-state.md exists. Instead, note the most recent session date and offer: `Last session: [date] — ask me to load it if you need the detail.`

---

### Step 4: Output the Briefing

Print this header first (exact text):

```
✦ os-start ✦
Getting your context...
```

Then output the briefing. Rules:
- If current-state.md exists: lead with Project Position, then In Flight, then Open Questions
- If current-state.md is missing: fall back to session-file format (most recent work + next steps)
- For portfolios: include the selected item name and stage
- Flag any stale sections clearly
- No preamble after the header
- Add a blank line after the briefing, then respond to any user message

---

## Example Output — Current State present

```
✦ os-start ✦
Getting your context...

PROJECT BRIEF

## Job Opportunities

Description: Working space to explore job opportunities from discovery through to interview.
Goal: Secure a senior PM role at an AI-forward company.
Item: Acme Corp — Senior PM (engaging)

**Current State** · updated 15 Apr 2026
Initial HR call completed. Acme Corp is a mid-size planning software company actively building an AI layer into their core product. Role is Senior PM, reporting to the CPO. Strong fit on mandate; comp range and team size TBC.

**In flight**
- Prep for technical interview (scheduled 18 Apr)
- Research Acme's AI roadmap and recent releases

**Open questions**
- What is the actual budget authority for this role?
- Is the AI layer greenfield or replatform?

Last session: 15 Apr 2026 — ask me to load it if you need the detail.
```

---

## Example Output — No current-state.md (fallback)

```
✦ os-start ✦
Getting your context...

PROJECT BRIEF

## PM-OS

Description: A context-aware Product Management harness for Claude Code.
Goal: Increase productivity as a product manager 100X.

**Most Recent Work** · 15 Apr 2026
Foundational session establishing PM-OS as a first-class project. Root CLAUDE.md trimmed from 616 to 86 lines. Multi-window os-start flow implemented.

**What comes next**
- Review skills-review.md and mark each KEEP / REMOVE
- Fix add-contact Step P3
- Validate os-start end-to-end

No current-state.md found. Run /os-save after this session to initialise it.
```

---

## Handling Missing Files

- **No current-state.md:** Fall back to session files; prompt to initialise
- **No session files either:** Note `No previous sessions found. Starting fresh.`
- **Portfolio with empty TRACKER:** Note `No items yet. Run /os-new-item to add your first [item name].`
- **Stale sections:** Flag inline — `⚠ Stakeholder Dynamics last updated 21 days ago`
