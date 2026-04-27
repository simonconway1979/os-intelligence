---
name: ctx-synthesise
description: Cross-synthesise stakeholder intelligence across all meetings for the active project. Reads meeting synthesis files, produces corroborated findings, themes, urgency flags, influence map, and hypotheses. Updates per-person standing briefs. Run after adding new transcripts.
user_invocable: true
---

# SI Synthesise

Two phases:
1. **Interactive:** Confirm project, scope, and meetings to process
2. **Background:** Full analysis → cross-synthesis.md → per-person standing brief updates

---

## Phase 1 — Confirm Scope

**Step 1** — Print:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CROSS-SYNTHESISE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Step 2 — Project.** Read `[workspace-root]/.current-session` to identify the active project (parse left of ` / ` if portfolio). Look up the folder path in `projects.md`. Show the project name. Confirm with user (Y/N or just Enter).

**Step 3 — Check for prior synthesis.** Look for `[PROJECT_ROOT]/intelligence/cross-synthesis.md`.

- **Found:** Read its frontmatter. Extract `last-synthesised`. Show:
  `Last synthesis: [date]. Running in delta mode — only new meetings will be re-read; prior synthesis used as baseline.`
- **Not found:** Show:
  `No prior synthesis found. First run — all meetings will be processed.`

**Step 4 — Scope meetings.** Glob all subdirectories under `[PROJECT_ROOT]/intelligence/meetings/`. For each, check for a `synthesis.md` and read only its frontmatter (first 20 lines) to get the `date` field.

- **Delta mode:** Include only synthesis files with `date` newer than `last-synthesised`.
- **First run:** Include all synthesis files found.

Display:
```
Meetings to process:
  [YYYY-MM-DD]  [topic from frontmatter]
  ...
  [N] meeting(s)
```

If delta run, also show: `[M] prior meeting(s) carried forward from last synthesis — will not be re-read.`

If delta mode and no new meetings found: say `No new meetings since last synthesis ([date]). Nothing to do.` and stop.

**Step 5 — Confirm.** Ask: `Run synthesis? (Y/N)`. Wait for response.

**Step 6 — Hand off.**

Say: `Got it. Running cross-synthesis in the background — you can keep working.`

Spawn background agent (`run_in_background: true`). Pass:
- `PROJECT_ROOT` — e.g. `projects/acme-corp-launch/`
- `MEETINGS_DIR` — `[PROJECT_ROOT]/intelligence/meetings/`
- `NEW_MEETING_FILES` — list of full paths to synthesis.md files to process this run
- `IS_DELTA` — true/false
- `PRIOR_SYNTHESIS_PATH` — path to existing cross-synthesis.md if delta run, null if first run
- `PEOPLE_DIR` — root-level `people/` directory path (e.g. `people/`)
- `OUTPUT_PATH` — `[PROJECT_ROOT]/intelligence/cross-synthesis.md`

Tell the agent: **Read `.claude/skills/ctx-synthesise/BACKGROUND.md` for full instructions. Do not ask questions — proceed through all steps. After writing cross-synthesis.md, also update the Stakeholder Dynamics section of `[PROJECT_ROOT]/context/current-state.md` if it exists. Use the cross-synthesis findings to populate: Current read (2-3 sentences), Key positions, Tensions, Who to watch. Update the section's `_Last updated:_` line and the file frontmatter (`last-updated`, `updated-by: ctx-synthesise`).**
