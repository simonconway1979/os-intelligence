# SI Synthesise — Background Agent Instructions

You are producing a cross-stakeholder synthesis for a PM stakeholder intelligence project. All inputs have been confirmed. Do not ask questions — proceed through all steps.

---

## Inputs you were given

- `PROJECT_ROOT`, `MEETINGS_DIR`, `PEOPLE_DIR`, `OUTPUT_PATH`
- `NEW_MEETING_FILES` — list of synthesis.md paths to process this run
- `IS_DELTA` — whether a prior synthesis exists
- `PRIOR_SYNTHESIS_PATH` — path to prior cross-synthesis.md (null if first run)

**Project slug:** derive from `PROJECT_ROOT` — the folder name under `projects/`. E.g. `projects/pm-os/` → `pm-os`. Use as `project/[slug]` in tags below.

---

## Step 1 — Load context (cost-efficient reading order)

Read in this order. Do not skip steps.

**1a — Prior synthesis (delta runs only)**
If `IS_DELTA` is true: read `PRIOR_SYNTHESIS_PATH` in full. This is your established baseline for all meetings not in `NEW_MEETING_FILES`. You do not need to re-read those older synthesis files — the prior cross-synthesis already represents them.

**1b — Per-person standing briefs**
For each `people/[name].md` relevant to this project, read only the `## Standing Brief` section if it exists. This gives you compact prior-context per person before reading new material. If no standing briefs exist yet (first run), skip.

**1c — New synthesis files**
Read every file in `NEW_MEETING_FILES` in full. These are the only synthesis files you read raw on a delta run.

---

## Step 2 — Build a findings map (internal, before writing)

Before writing any output, build a mental map across all material (new files + prior synthesis baseline):

For every significant claim, pattern, or finding:
- Note which sources state or imply it
- Count corroboration: how many distinct people mentioned it?
- Flag contradictions: where do sources disagree on the same question?

**Corroboration tiers:**
- **Strong (3+ sources):** State as a finding. Lead with source count.
- **Moderate (2 sources):** Include as a finding. Name both sources.
- **Single-source:** Do not include in Cross-Stakeholder Findings. Move to Open Questions as unverified.

---

## Step 3 — Write cross-synthesis.md

Write to `OUTPUT_PATH`. Overwrite if it exists. Use this exact structure:

```markdown
---
last-synthesised: [TODAY'S DATE in YYYY-MM-DD]
meetings-total: [total meeting count across all runs]
meetings-this-run: [count of NEW_MEETING_FILES]
prior-synthesis: [date of prior synthesis, or null]
people: [list of name slugs covered across all meetings]
tags:
  - type/context
  - project/[PROJECT_SLUG]
  - status/synthesised
---

# Cross-Synthesis — [Project Name] — [Date]

## URGENT FLAGS
...

## DELTA
...

## CROSS-STAKEHOLDER FINDINGS
...

## THEMES
...

## INFLUENCE MAP
...

## HYPOTHESES
...

## OPEN QUESTIONS
...
```

---

### URGENT FLAGS

Time-sensitive items where a clock is ticking or an opportunity is closing. Urgency means: something bad happens if this isn't acted on soon, or a window closes.

For each flag:

```
🚨 [Title]
Who: [person(s) involved]
Why urgent: [what happens if not acted on — one sentence]
Deadline: [stated or implied timeframe]
Source: [meeting slug(s)]
```

Apply judgment — not everything sensitive is urgent. A difficult conversation that can happen anytime is not urgent. A flight risk with a self-imposed two-month deadline is.

If nothing qualifies, write: `No urgent flags at this time.`

---

### DELTA

**First run:** Write: `First synthesis — no prior baseline to compare against. Full picture built from scratch.`

**Delta run:** Cover three things in bullet form:
- What's new — findings or facts that weren't in the prior synthesis
- What shifted — positions that moved, contradictions that emerged, anything that updates the prior read
- What was expected vs surprising — call out anything the new material confirmed vs anything that changed your picture

Keep this section to 3–8 bullets. It's a brief for someone who read the last synthesis and wants to know what's changed.

---

### CROSS-STAKEHOLDER FINDINGS

The core of the document. These are findings that only emerge from reading multiple synthesis files together — things no single interview would reveal on its own.

Sort by corroboration strength, strongest first.

For each finding:

```
### [Finding title]
**Corroboration:** [N]/[total people] — [names]
**Finding:** [2–4 sentences. What does the evidence show? Be direct.]
**Significance:** [Why does this matter for the project or the PM? One sentence.]
**Contradicting evidence:** [Who says otherwise, or "None."]
```

Do not pad this section. Five strong findings are better than ten weak ones. Single-source claims do not belong here.

---

### THEMES

**Consensus themes**
Topics where most or all stakeholders align. For each: note whether the consensus appears genuine (independently arrived at, consistent wording) or performed (people saying what they're expected to say in this kind of conversation).

**Fractured themes**
Topics where stakeholders hold meaningfully different views. For each: map who believes what, and note what's at stake if the fracture isn't resolved.

**Silence themes**
Topics no stakeholder raised but that context suggests are important. What is this organisation collectively not talking about? Distinguish where possible between avoidance (people know and aren't saying), assumption (everyone assumes someone else is handling it), and genuine absence of concern.

---

### INFLUENCE MAP

Update or build from scratch based on all available data.

| Name | Influence | Interest | Disposition | Confidence | Key dynamic |
|------|-----------|----------|-------------|------------|-------------|

- **Influence:** High / Medium / Low — real ability to shape outcomes, not just formal authority
- **Interest:** High / Medium / Low — how engaged and invested in this outcome
- **Disposition:** Ally / Cautious / Neutral / Resistant / Unknown
- **Confidence:** Low (1 meeting) / Medium (2–3 meetings) / High (4+ meetings)
- **Key dynamic:** One sentence. The single most important thing to understand about this person's relationship to the project right now.

---

### HYPOTHESES

Falsifiable statements about organisational reality generated from contradictions, silences, and ambiguities. The test of a good hypothesis: you can imagine evidence that would prove it wrong.

For each:

```
### H[N]: [Falsifiable statement about what is true]
**Status:** OPEN / PROVEN / DISPROVEN / INCONCLUSIVE
**Evidence for:** [what supports this]
**Evidence against / what would disprove it:** [what would show it's wrong]
**How to test:** [specific question to ask, observation to make, or document to find]
**Priority:** High / Medium / Low
**Category:** Power & Politics / Strategic Alignment / Process & Dysfunction / People & Relationships / Customer & Market / Technical & Feasibility
```

On delta runs: carry forward all prior hypotheses. Update status where new evidence is conclusive. Mark resolved hypotheses clearly. Add new ones from the new material.

Target 5–10 hypotheses. Prioritise the ones that, if true, would change what the PM should do.

---

### OPEN QUESTIONS

What this synthesis couldn't answer. Include:
- Single-source claims that need corroboration before acting on them
- Contradictions where the evidence doesn't yet point clearly in either direction
- Gaps in stakeholder coverage — important people not yet interviewed
- Questions raised by the evidence but unanswerable from current data

Format as a numbered list. One sentence per item on why it matters.

---

## Step 4 — Update per-person standing briefs

For each person whose synthesis files were read this run (i.e. anyone appearing in `NEW_MEETING_FILES`), update their file in `PEOPLE_DIR`.

Find the `## Standing Brief` section in `people/[name].md`. If it doesn't exist, add it after `## Summary`. Overwrite it entirely:

```markdown
## Standing Brief
*Updated: [date] · [N] meeting(s) · [project name]*

[100–200 words. Cover: their stated position on key issues, their actual disposition toward the project (from the interpretive layer), what they're consistent on across meetings, what has shifted or evolved, any load-bearing private flags (e.g. flight risk, undisclosed conflict). Written as a compact brief for someone who needs to interact with this person and has 30 seconds to prepare. Be direct — diplomatic vagueness is useless here.]
```

Also update the `## Interaction History` section:
- `Last interaction:` — date of their most recent meeting
- `Total interactions:` — count of synthesis files for this person across all projects

---

## Step 5 — Notify

After all writes complete, return **only** this closing message. Do NOT add headline, urgency flags, top findings, or running commentary — those live in `cross-synthesis.md` for the user to read at their pace. The point of this message is: confirm done + point at next step.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CROSS-SYNTHESIS COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[N] meetings into one cross-cutting picture. Standing briefs updated for each person involved. Stakeholder Dynamics in current-state.md refreshed.

→ Read the picture: projects/[slug]/intelligence/cross-synthesis.md
→ Save the session:  /os-save

(/os-start in future sessions loads the briefing automatically.)
```

Substitute `[N]` and `[slug]`. Nothing else. Do not append the cross-synthesis findings inline.
