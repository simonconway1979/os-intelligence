---
name: os-archive-item
description: Archive a portfolio item (campaign, opportunity, idea, etc.). Marks it complete or stopped, writes a structured summary.md, moves the TRACKER row from Active to Archived, and appends a one-line entry to portfolio-level LEARNINGS.md. The summary is the durable record that informs future items in the same portfolio.
user_invocable: true
---

# /os-archive-item — Archive a Portfolio Item

Generic skill for closing out any portfolio item. Works for campaigns, job opportunities, ideas, events — anything in a portfolio.

The point of this skill is to produce a **summary that's actually re-read.** The user reviews and edits the summary; that's the deliverable, not the file move. Treat the move/tracker updates as housekeeping around the real work.

---

## Step 1 — Identify the item

If `[workspace-root]/.current-session` points to a portfolio item (format: `[Portfolio Name] / [Item Name]`), use that automatically. Confirm with the user: `Archiving [Item Name] from [Portfolio]?`

If standalone (no active item context):
1. Read `projects.md`, filter to `**Type:** portfolio`
2. Ask which portfolio
3. Read that portfolio's `TRACKER.md`, list active items
4. Ask which item

---

## Step 2 — Read what's already there

Read the item file (e.g., `campaign.md`, `opportunity.md` — name comes from portfolio CLAUDE.md `**Item name:**`).

Extract for pre-filling the summary:
- Goal / objective
- Any performance tables, metrics, dated activity logs
- Stage history if recorded
- Key files referenced

If the item folder contains a `summary.md` already, **stop and ask** — never overwrite an existing summary. Offer to update it instead.

---

## Step 3 — Outcome and reason

Ask:

```
Outcome?
1. Complete — the work finished as intended (or close enough)
2. Stopped — pulled before completion (deprioritised, killed, blocked)
```

If **Stopped**, ask one follow-up: **"Why stopped — in one line?"**

This drives which summary template applies.

---

## Step 4 — Pull the lessons out

Ask these three questions in order. Wait for each answer before moving on. The answers are the load-bearing content of the summary — pre-fill anything you can from Step 2 data, but don't skip the questions.

1. **"What worked?"** (or for Stopped: "What did we learn before we pulled it?")
2. **"What would you change next time?"** (or for Stopped: "What would need to be true to retry this?")
3. **"One reusable lesson — what's the single thing you'd want a future you to remember?"**

If the user gives terse answers, push back once: "Anything more specific? This is the one record you'll re-read." Don't push twice.

---

## Step 5 — Write summary.md

Write to `[item-folder]/summary.md`.

### Structure for Complete outcomes

```markdown
---
[item-type]: [Item Name]
status: complete
closed: [YYYY-MM-DD]
outcome: success | partial | mixed
---

# [Item Type] Summary — [Item Name]

## TL;DR

[2-3 sentences. What was the goal, what happened, what's the one-line takeaway. Written so a future you reading only this paragraph can decide whether to dig into the rest.]

---

## Goal vs. Outcome

[Table: each goal → outcome → verdict (Hit / Partial / Miss). Pull goals from the item file.]

---

## What Happened

[Timeline / activity / metrics, pulled from the item file. Concise — this is reference, not narrative.]

---

## What Worked

[From Step 4 Q1. Bullet list. Be specific — "tagging co-hosts extended reach" not "social engagement worked".]

---

## What to Change

[From Step 4 Q2. Numbered list — these are next-time actions, treat them as such.]

---

## Reusable Lessons

[From Step 4 Q3 + anything else generalisable from Q1/Q2. These get rolled into LEARNINGS.md. Write them as standalone sentences that make sense without context.]

---

## Open Questions

[Anything unresolved that a future similar item should test or watch for. Optional — only include if there are genuine open threads.]

---

## Files

[Links to key files inside the item folder + any cross-project references.]
```

### Structure for Stopped outcomes

```markdown
---
[item-type]: [Item Name]
status: stopped
closed: [YYYY-MM-DD]
reason: [from Step 3 follow-up]
---

# [Item Type] Summary — [Item Name] (Stopped)

## TL;DR

[2-3 sentences. What we tried, why we stopped, what we learned anyway.]

---

## What We Tried

[What got built / sent / scheduled before it stopped.]

---

## Why Stopped

[Expanded from the one-line reason. Be honest — was it priority shift, evidence against the bet, blocker we couldn't move, or just running out of energy?]

---

## What We Learned Anyway

[From Step 4 Q1. Stopped items often produce the most useful learnings.]

---

## What Would Change Our Mind

[From Step 4 Q2. What evidence or condition would make us reopen this?]

---

## Reusable Lessons

[From Step 4 Q3.]

---

## Files

[Links.]
```

---

## Step 6 — Update the item file

In the main item file (e.g., `campaign.md`):
- Change `**Stage:**` to `Complete (closed YYYY-MM-DD)` or `Stopped (closed YYYY-MM-DD)`
- Add a `**Closed:**` line under Stage with the one-line outcome or stop reason
- Do not touch other content — the summary.md is where the retrospective lives, the item file stays a record of what was planned/done

---

## Step 7 — Move row in TRACKER.md

Open the portfolio's `TRACKER.md`.

Remove the item's row from the **Active Campaigns** / **Active Items** / etc. table.

Add a row to the **Archived** table. Use this format:

| Item | Outcome | Closed | Notes |
|------|---------|--------|-------|
| [Item Name](path) | [one-line outcome — pull from summary TL;DR] | YYYY-MM-DD | See `summary.md` |

If the Archived table doesn't exist yet, create it under a `## Archived [Items]` heading at the bottom of TRACKER.md with the column headers above.

Update the `Last updated:` date at the top of TRACKER.md.

---

## Step 8 — Append to LEARNINGS.md

Path: `[portfolio-root]/LEARNINGS.md`. Create if missing.

If creating, use this header:

```markdown
# [Portfolio Name] — Learnings Log

A flat log of one-line lessons from every closed item. Newest at top. Skim this before starting a new item.

---
```

Prepend (newest at top) a new entry with this format:

```markdown
## [Item Name] — closed YYYY-MM-DD ([complete | stopped])

[The Step 4 Q3 answer — the one reusable lesson. One or two sentences.]

→ [summary.md](path/to/summary.md)
```

Keep entries short. The point of this file is to be skimmable in 60 seconds. If the user gave a long answer to Q3, condense it for this file but keep the full version in summary.md.

---

## Step 9 — Confirm and hand back

Show the user:

```
Archived: [Item Name]
Outcome: [complete | stopped]

Files:
  ✓ summary.md written → [path]
  ✓ [item-file].md updated (Stage = [Complete/Stopped])
  ✓ TRACKER.md row moved to Archived
  ✓ LEARNINGS.md entry added

Read the summary and push back where I got it wrong — that's the file you'll re-read.
```

Then suggest the next step: usually either updating `.current-session` (if archiving the active item), running `/os-start` to pick up next, or moving on to a related item.

If the archived item was the active session, clear `.current-session` or update it to the portfolio root level (e.g., `Content Engine` not `Content Engine / [archived item]`).

---

## Notes for the model

- **The summary is the deliverable.** Housekeeping (move + tracker + learnings) is wrapper. Don't speed through Step 4.
- **Don't invent metrics.** If the item file doesn't record numbers, leave them out — don't pad the summary with vague claims.
- **Stopped is not failure.** Frame stopped items neutrally. The lesson is what matters, not the stop itself.
- **One reusable lesson, not five.** Step 4 Q3 forces compression because LEARNINGS.md has to stay scannable. If the user gives five, pick the strongest with them.
- **Never overwrite an existing summary.md.** If it exists, ask — it may be intentional from a partial close-out earlier.
- **Item file Stage update is structural, not editorial.** Don't rewrite the item file's body. Just update the metadata.
