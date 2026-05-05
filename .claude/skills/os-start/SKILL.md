---
name: os-start
description: Load project context and start a session with a compact briefing of recent work and next steps
user_invocable: true
---

# /os-start — Session Start Briefing

---

## Step 1 — Render menu

Invoke exactly this Bash command:

```
bash .claude/skills/os-start/menu.sh
```

Then print the bash stdout **verbatim** as your text response (Claude Code collapses long bash output by default, so the user won't see it unless you echo it). Add NO preamble, NO commentary — just relay the script output. Then wait for the user to reply with a number.

---

## Step 2 — Resolve the selection

When the user replies with a number, read `projects.md` and find the matching project under `## Active`. Extract:
- Project name
- `**Type:**` (project | portfolio)
- `**Folders:**` path
- `**One-liner:**`, `**Goal:**`

Branch on Type:
- **New project** (last menu item) → run `/os-new-project`, then continue.
- **Type: project** → write project name to `[workspace-root]/.current-session`. Go to Step 3.
- **Type: portfolio** → go to Step 2b.

### Step 2b — Portfolio drill-down

Read the portfolio's `TRACKER.md`. By default, show only items with stage `pipeline`, `prep`, `upcoming`, or `complete` — hide `archived`. Print:

```
Which [item name] will you work on?

1. [Item Name] ([stage])
...
N. Add new [item name]

Tip: 0 to see old/archived [item name]s in the list.
```

- **0** → re-render the menu with all items (including `archived`), no tip line. Renumber from 1. Wait for selection.
- **Add new** → run `/os-new-item`, then continue.
- **Existing item** → write `[Portfolio Name] / [Item Display Name]` to `.current-session`. Go to Step 3.

Pluralise the item name naturally in the tip (e.g. "events", "ideas", "opportunities"). If the portfolio has zero archived items, omit the tip line.

---

## Step 3 — Load current state

Read `[project-root]/context/current-state.md` if it exists. This is the primary context source.

For each section, check `_Last updated:_`:
- > 14 days old → flag as stale in the briefing
- still `—` → flag as not yet populated

If missing: note `No current-state.md found. Run /os-save after this session to initialise it.` and fall back to Step 4.

For portfolios: also read the selected item's `[item-name].md` frontmatter for `next_action` and `stage`.

---

## Step 4 — Most recent session (fallback only)

Only run if `current-state.md` is missing, or the user explicitly asks for session detail.

Search order: `[project]/memory/YYYYMMDD-HHMM.md` (newest, exclude `-reasoning.md`) → `[project]/memory/SESSIONS-INDEX.md` first row → `context-library/memory/context-snapshot/` → `context-library/_CURRENT-STATE.md`.

When `current-state.md` exists, do NOT auto-load session files. Just note: `Last session: [date] — ask me to load it if you need the detail.`

---

## Step 5 — Output the briefing

Format:

```
PROJECT BRIEF

## [Project Name]

Description: [from projects.md]
Goal: [from projects.md]
[Portfolio only: Item: [Item Name] — [stage]]

**Current State** · updated [date]
[2-3 sentences from current-state.md Project Position]

**In flight**
- [from current-state.md In Flight]

**Open questions**
- [from current-state.md Open Questions]

Last session: [date] — ask me to load it if you need the detail.
```

Rules:
- If `current-state.md` is missing, swap **Current State** / **In flight** / **Open questions** for **Most Recent Work** / **What comes next** drawn from the session file.
- Flag stale sections inline: `⚠ Stakeholder Dynamics last updated 21 days ago`.
- Empty portfolio TRACKER: `No items yet. Run /os-new-item to add your first [item name].`
- No session files at all: `No previous sessions found. Starting fresh.`
- No preamble. Blank line after the briefing, then respond to any user message.
