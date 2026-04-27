# /os-project-design — Design a Project Structure

**Version:** 0.2 — renamed from os-project-setup 2026-04-22

Run this when starting a new project that doesn't fit the standard PM OS template. The goal is to design a lightweight structure that fits the project — not to impose a generic one.

This skill is conversation-driven. It asks questions, listens to the answers, and proposes a structure before building anything.

---

## When to run this

- You're starting a project that is a *portfolio* (many items) rather than a single initiative
- The project involves ongoing relationship-building rather than a deliverable
- The project has a personal rather than professional/company focus
- A standard `/os-new-project` would produce a folder structure that doesn't feel right

Note: `/os-project-design` differs from `/os-new-project` — it designs structure through conversation before building anything. `/os-new-project` creates from a standard template.

Examples where this applies:
- Job search (portfolio of opportunities)
- Content/engagement (portfolio of platforms and contacts)
- Investor relations (portfolio of relationships over time)
- Personal learning (portfolio of books, courses, experiments)

---

## Step 1 — Understand the project

Ask the user these questions. You can ask them all in one message. Listen carefully — the answers drive everything that follows.

```
A few questions to figure out the right structure:

1. What is this project? One sentence.
2. What's the primary *output* — a document, a decision, a relationship, a shipped thing?
3. Is this one thing or many things in parallel? (e.g. one product launch vs many job applications)
4. Will context accumulate over time for each item, or is it mostly one-shot?
5. How many other people are meaningfully involved? (just you / a handful / many)
6. Is there a natural *stage* or *status* each item moves through?
7. How long will this run — weeks, months, or ongoing indefinitely?
```

If the user has already answered some of these in their message or earlier in the conversation, skip them. Don't make them repeat themselves.

---

## Step 2 — Classify the project type

Based on the answers, identify the project shape:

**Portfolio project** — many parallel items at different stages
- Examples: job search, content pipeline, investment pipeline, customer accounts
- Structure: `items/[slug]/` with per-item context + SI
- Needs: top-level tracker, per-item frontmatter with stage/status

**Initiative project** — one focused effort with a clear end
- Examples: product launch, hiring sprint, market research study
- Structure: standard PM OS layout (use `/os-new-project` instead)
- This skill probably isn't needed

**Relationship project** — ongoing engagement with a network of people
- Examples: community building, investor relations, mentoring network
- Structure: people-first, with context about each relationship
- Needs: global people integration, interaction logs, engagement tracking

**Personal operating project** — ongoing system for managing yourself
- Examples: job search (hybrid: portfolio + relationships), content/brand
- Structure: mix of portfolio + relationship layers

Tell the user which type you think this is and confirm before proceeding.

---

## Step 3 — Propose the folder structure

Based on the project type, propose a folder structure. Show it as a tree. Explain each folder in one line.

Key decisions to make explicit:
- Does each item get its own subfolder? (portfolio: yes)
- What depth of SI is needed? (none / light / full)
  - None: just notes, no structured per-person files
  - Light: one file per person (fact card only, no log)
  - Full: fact card + relationship log (use for high-stakes relationships)
- Does this project feed the global `/people/` graph?
- Is a tracker/dashboard file needed?
- What context files belong at the project root vs per-item?

Show the proposed structure and ask: *Does this feel right, or are there things to add, remove, or rename?*

---

## Step 4 — Identify OS skill fit

Review the root OS skills and identify:

**Use as-is:**
- Skills that work unchanged for this project type
- List them explicitly

**Adapt:**
- Skills that need minor changes
- Describe what needs changing (e.g. "ctx-doc works but the `informs:` paths will be per-item")

**Project-specific skills needed:**
- Things this project type needs that don't exist yet
- List them as `[skill-name]: one-line description`
- These become candidates for new skill files

Show this as a short table or list. Get the user's input on what's most important to build first.

---

## Step 5 — Build the structure

Once the user has confirmed the structure and skill plan:

1. Create all folders (use `.gitkeep` for empty ones)
2. Create the key files:
   - `CLAUDE.md` at project root — document the structure, stages, key paths
   - `TRACKER.md` if a portfolio tracker is needed
   - Context file stubs in `context/` (headers only, marked "— add after first session")
   - Template files in `templates/` for any repeating unit (opportunity, contact, etc.)
3. Update the project `CLAUDE.md` with:
   - Project-specific skills (list them under a `## Skills` section)
   - Any project-specific rules or behaviors

---

## Step 6 — Document for iteration

After building, create a brief session note:

```
Project setup complete: [project name]
Type: [portfolio / initiative / relationship / personal operating]
Structure decisions:
  - [key decision 1 and why]
  - [key decision 2 and why]
Skills built: [list]
Skills reused: [list]
Open questions for next iteration:
  - [question]
```

Save this as `memory/[YYYYMMDD]-setup.md` in the project folder.

This becomes the reference point when we later formalise the skill pattern across project types.

---

## Design principles (for iteration)

These emerged from the job-opportunities setup conversation on 2026-04-14:

1. **Fit before build** — understand the project shape before creating folders
2. **Light by default** — start with less structure than you think you need; add as context grows
3. **Three-layer people** — item-level → project-level → global. Each layer has a different purpose.
4. **SI depth should match stakes** — full fact card + relationship log only for relationships where context compounds over time (job search yes, casual LinkedIn connection no)
5. **Template first** — any repeating unit (opportunity, contact, event) should have a template before any real instances are created
6. **Tracker for portfolios** — if there are multiple parallel items, there should be one file that shows the whole picture

---

## Version history

- **0.1** (2026-04-14): Initial draft based on job-opportunities setup conversation. Not yet tested.
