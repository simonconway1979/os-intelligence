---
name: os-new-project
description: Create a new project. Sets up the project folder, creates the projects.md entry, links people and company, and generates the CLAUDE.md. Run this when starting any new project.
---

# New Project Setup

Walks through creating a new project from scratch. Output: a project folder, a populated CLAUDE.md, an entry in projects.md, and linked people/company records.

---

## Step 1 — Project name (duplicate check)

Ask: **"What's the project name?"**

Before continuing, check `projects.md` for an existing entry with the same name (case-insensitive).

If a match is found, show:
```
A project with that name already exists. Please provide a different name.
```
Ask again. Do not proceed until the name is unique.

---

## Step 2 — Project basics

Ask the following questions one at a time:

1. **"One sentence — what is it?"**
2. **"What's the primary goal? What does success look like?"**

---

## Step 3 — Project type

Ask:
```
What type of project is this?

1. Standalone project — a single piece of work with a clear goal
   (e.g., building an app, running a product launch, writing a report)

2. Portfolio — a managed collection of similar items
   (e.g., a set of job opportunities, an ideas bank, a reading list)
```

Record the answer as `project` or `portfolio`. This determines the folder structure created in Step 8.

**If portfolio:** also ask:
- "What do you call a single item in this collection? (e.g., opportunity, idea, article)" — record as the item name (singular, lowercase)

---

## Step 4 — Personal or professional?

Ask:
```
Is this a personal or professional project?

1. Personal
2. Professional
```

Record the answer and add the corresponding tag (`personal` or `professional`) to the project.

---

## Step 5 — Company (professional projects only)

Skip this step if the project is personal.

Read the `companies/` folder at root. Present as a selectable list:

```
Is this project run for a business or organisation?
Select one, or add a new one:

○ Acme Corp
○ Globex Inc
○ [any other company files]
○ Add another
○ None / not applicable
```

If the user selects an existing company, link it.

If **Add another**: ask for the business name, then create `companies/company-name.md` with identity fields only (name, type, industry — rest blank).

If **None / not applicable**: skip.

---

## Step 6 — Add the user (automatic)

No prompt. Always add the user as project lead by default.

Link the user's own identity file at `people/[your-slug].md` as project lead. If no profile exists yet, run `/os-new-person` first to create one.

If the user needs to be removed from a project later, they can ask Claude directly.

---

## Step 7 — Existing contacts

Read the `people/` folder at root (exclude TEMPLATE.md and README.md).

Present as a numbered list:

```
Who else is in this project? Type the numbers of anyone to add
(or press Enter to skip):

1. Alex Chen — VP Sales, Globex Inc
2. Sam Patel — Head of Customer Support, Globex Inc
3. Maya Rodriguez — Engineering Lead, Globex Inc
4. Marcus Webb — CPO, Globex Inc
5. Priya Sharma — Data Scientist, Globex Inc
6. Jordan Kim — Engineering Lead, Globex Inc
```

Accept comma-separated numbers (e.g. `1, 3, 5`) or a range. Record all selected people.

---

## Step 8 — New contacts

Ask:
```
Anyone else to add who isn't in your contacts yet?
Give me their name and title. Also their company if it's
not [project company] — don't worry if you don't have
everyone, you can add more later.
```

If yes, for each person collect:
- Name
- Title
- Company — if not provided, default to the project company (if one was selected in Step 5)

**Important:** Collect only these three fields. Do not ask follow-up questions about the person — no "what's their relationship to you", no "manager/peer/direct report", no seniority, no history. Relationship and role detail get captured later via `/ctx-doc`, `/ctx-transcript`, or by running `/os-new-person` directly.

Create a new file at `people/firstname-lastname.md` using TEMPLATE.md. Populate identity fields only. Leave summary and interaction history blank. Set project footprint to this project.

Do not use the word "stub". Tell the user:
```
Added [Name] to your contacts. You can fill in more detail after your first meeting.
```

---

## Step 9 — Create the project

Do the following automatically, no further questions needed.

### For both project and portfolio types:

**a) Create the project folder structure**

Folder name: lowercase, hyphenated (e.g. `acme-corp-launch`).

Create the directory tree:
```bash
mkdir -p projects/[project-name]/{context,intelligence/{chats,docs/raw,meetings/inbox,notes},memory,outputs,people}
```

Add `.gitkeep` files to the empty folders so they survive cloning and git operations:
- `intelligence/chats/.gitkeep`
- `intelligence/docs/raw/.gitkeep`
- `intelligence/meetings/inbox/.gitkeep`
- `intelligence/notes/.gitkeep`
- `memory/.gitkeep`
- `people/.gitkeep`

**Switch the active session to the new project.** The scaffold now exists, so it's a valid switch target. Write the project name (matching the `### [Project Name]` heading written to `projects.md` in Step 9c) to `[workspace-root]/.current-session`:

```bash
echo "[Project Name]" > .current-session
```

This mirrors `/os-start` Step 2 and ensures any subsequent `/os-save`, `/ctx-doc`, or other skill writes to the correct project — without it, the session silently stays on whatever project was previously active.

Tell the user: `Switched active session to [Project Name].`

Write `projects/[project-name]/context/README.md`:
```markdown
# Context

Project knowledge. Flat structure — no subfolders.

Name files semantically so their content is obvious from the filename (e.g. `q2-okrs.md`, `competitor-analysis.md`).

**Rule:** Stable, reference-only knowledge lives here. Active drafts live in `outputs/`.
```

Write `projects/[project-name]/outputs/README.md`:
```markdown
# Outputs

Active work in progress. Flat structure — no subfolders.

**Rule:** If it's being edited, it lives here. When stable, move to `context/`.
```

Write `projects/[project-name]/context/current-state.md` using this template (substitute `[Project Name]` from Step 1, `[One-liner]` and `[Goal]` from the projects.md entry written in Step 9c, and `[today]` as YYYY-MM-DD). Mirrors the `/os-save` create-from-scratch template so future os-save runs find the expected structure.

```markdown
---
project: [Project Name]
last-updated: [today]
updated-by: os-new-project
---

# Current State

The current snapshot of the project. Living synthesis.

_Updated by os-save, ctx-synthesise, and ctx-doc. Primary context loaded at session start._

---

## [Project Name]

[One-liner]

**Goal:** [Goal]

_Synced from `projects.md`. Edit there._

---

## Project Position
_Last updated: — via —_

**Where we stand:** —
**Primary goal:** —
**Key constraint or risk:** —

---

## What We Know From Documents
_Last updated: — via ctx-doc_

—

**Sources:** —

---

## Stakeholder Dynamics
_Last updated: — via ctx-synthesise_

**Current read:** —
**Key positions:** —
**Tensions:** —
**Who to watch:** —

---

## Standing Decisions
_Last updated: — via os-save_

| Decision | What was decided | Why it matters |
|----------|-----------------|----------------|
| — | — | — |

---

## In Flight
_Last updated: — via os-save_

- —

---

## Open Questions / Blockers
_Last updated: — via os-save_

- —

---

## Recent Changes
_Last updated: — via os-save_

- —
```

**b) Write CLAUDE.md**

Write `projects/[project-name]/CLAUDE.md` using this template, substituting fields from Steps 1–8:

```markdown
# CLAUDE — [Project Name]

**Inherits from:** Root `/CLAUDE.md` (PM Operating System)

---

## Project

- **Name:** [Project Name]
- **Status:** Active
- **Started:** [today YYYY-MM-DD]

See `context/current-state.md` for description, goal, and current state (synced from `projects.md`).

---

## Company

[Company Name] — [link to company file, e.g. ../../companies/company-name.md]
(Or: `— (personal project)` if no company linked)

---

## Key People

See `people/` for project-level stakeholder profiles (auto-maintained by `/ctx-transcript` and `/ctx-doc`).
Current dynamics: `context/current-state.md` → Stakeholder Dynamics (auto-maintained by `/ctx-synthesise`).

---

## Current Focus

— add after first session

---

## Key Paths

- `context/` — project knowledge (flat, named semantically); `current-state.md` is the live read
- `outputs/` — work in progress
- `intelligence/` — meetings, docs, notes, chats (bulk import targets)
- `memory/` — session saves (`YYYYMMDD-HHMM.md`)
```

For portfolios, append a `## Portfolio` block to CLAUDE.md:
```markdown
---

## Portfolio

- **Item name:** [item name from Step 3] (singular)
- **Items folder:** `[item-name]s/` (pluralised)
- **Add skill:** `/os-new-item`
- **Tracker:** `TRACKER.md`
```

**c) Add to projects.md**
Append a new entry under `## Active` in `projects.md`:

For a **standalone project**:
```
### [Project Name]
- **Type:** project
- **Status:** Active
- **One-liner:** [from Step 2]
- **Goal:** [from Step 2]
- **Folders:** `projects/[project-name]/`
- **Company:** [link to company file, or —]
- **Key people:** [linked list]
- **Started:** [today]
- **Last session:** [today]
```

For a **portfolio**:
```
### [Project Name]
- **Type:** portfolio
- **Status:** Active
- **One-liner:** [from Step 2]
- **Goal:** [from Step 2]
- **Folders:** `projects/[project-name]/`
- **Company:** [link to company file, or —]
- **Key people:** [linked list]
- **Started:** [today]
- **Last session:** [today]
- **Items:** [TRACKER.md](projects/[project-name]/TRACKER.md)
```

**d) Portfolio-only: create additional structure**

If type is portfolio:
- Create `projects/[project-name]/[item-name]s/` folder (e.g., `opportunities/`, `ideas/`)
- Create `projects/[project-name]/TRACKER.md` with appropriate column headers for the item type
- Create `projects/[project-name]/templates/[item-name]/` folder with a blank `[item-name].md` template file

The TRACKER.md should follow this pattern:
```markdown
# [Project Name] Tracker

Last updated: [today]

---

## Active [Item Name]s

| [Item Name] | Stage | [relevant column] | Last Worked | Next Action |
|-------------|-------|-------------------|-------------|-------------|
| — | — | — | — | — |

---

## Archived [Item Name]s

| [Item Name] | Outcome | Closed | Notes |
|-------------|---------|--------|-------|
| — | — | — | — |
```

**e) Update people files**
For each person added:
- Append to their root `people/[name].md` Project Footprint table: `| [Project Name] | [their role] |`
- Create `projects/[project-name]/people/[name-slug].md` using this format:

```markdown
# [Full Name] — [Project Name]

**Role:** [Title, Company]
**See also:** [Root profile](../../people/[name-slug].md)

---

## Their Role Here

[Fill in after first meeting]

---

## What They Care About

[Fill in after first meeting]

---

## Working With Them

[Fill in after first meeting]

---

## Key Context

[Fill in after first meeting]

---

## Sources
```

Populate **Their Role Here** with the title and company from the project setup. Leave other sections as placeholders.

**f) Update company file**
If a company was linked, append to its `Projects` table:
`| [Project Name] | [one-liner] |`

---

## Step 10 — Confirm and next steps

Show the user what was created:

For a standalone project:
```
✅ Project folder created: projects/[name]/
✅ Active session switched to [Project Name]
✅ CLAUDE.md written (type: project)
✅ Entry added to projects.md
✅ [N] people linked
✅ Company: [name] (or — if none)

Your project is ready. You're already in it — start working, or run /os-save when you're done.
```

For a portfolio:
```
✅ Project folder created: projects/[name]/
✅ Active session switched to [Project Name]
✅ CLAUDE.md written (type: portfolio)
✅ Entry added to projects.md
✅ TRACKER.md created
✅ templates/[item-name]/ created
✅ [N] people linked
✅ Company: [name] (or — if none)

Your portfolio is ready. To add your first [item-name], run /os-new-item.
```

---

## Step 11 — Save session

Run `/os-save` to save this setup session.
Save the session output to `projects/[project-name]/memory/` as well as the default location.
