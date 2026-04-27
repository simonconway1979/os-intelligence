---
name: ctx-doc
description: Add a document to the project and update synthesised context. Run this whenever new source material arrives — calls, transcripts, documents, briefs. Walks through adding frontmatter, updating context files, and syncing people records.
---

# Add Document to Project Context

Run this when a new document arrives for a project. Output: raw files with frontmatter, updated context docs, updated people files (project + root level).

**Cost note:** This skill is designed to be context-efficient. The preferred path is to copy files into `intelligence/docs/raw/` yourself first, then run this skill. That way long transcripts and documents never sit in the conversation window — they're read by tool as needed and processed one at a time. Pasting content directly into chat is the expensive path and should be avoided for long files.

---

## When to run this

- You've received a new call transcript, meeting notes, or document
- You've done a prep session and have outputs to save
- You want to sync new people info to the people registry
- You've finished an event/interview and want to capture it
- `/ctx-transcript` has run and you want the meeting insights to flow into project context

---

## Step 1 — Identify the active project

Read `[workspace-root]/.current-session`. Parse left of ` / ` if portfolio. Look up the project name in `projects.md` to get the folder path. Load that project's `CLAUDE.md`.

Note:
- The raw files directory: `[project]/intelligence/docs/raw/`
- The context directory: `[project]/context/`
- The people directory: `[project]/people/`

---

## Step 2 — Check for unprocessed files

Check two locations:

**A. `[project]/intelligence/docs/raw/`** — For each file, check whether its frontmatter contains an `enriched:` field.
- **Has `enriched:`** — already processed, skip
- **Missing `enriched:`** — include in this run

**B. `[project]/intelligence/meetings/*/synthesis.md`** — For each synthesis file, check whether its frontmatter contains a `context_enriched:` field.
- **Has `context_enriched:`** — already pulled into context, skip
- **Missing `context_enriched:`** — include in this run

SI synthesis files are the bridge between stakeholder intelligence and project context. They are already distilled (people layer handled by SI), so reading them is cheaper than raw transcripts and avoids double-processing.

Show the user:
```
Found [N] unprocessed file(s):

intelligence/docs/raw/:
  — filename.md

intelligence/ (meeting synthesis):
  — meetings/[slug]/synthesis.md

[M] file(s) already processed (skipping).

Shall I process all [N], or just specific ones?
```

If both locations are empty or fully processed, say so and ask if they want to add new files.

**After the user confirms which files to process: if the count to process is 3 or more, ask:**

```
[N] files to process. Run in parallel? (Y/n)

In parallel mode I spawn one sub-agent per file to do the heavy reading
and analysis simultaneously. The merged context updates are then applied
here in the main thread, sequentially, so there are no conflicts on
shared files (context/*, people/*). Faster for batches; same result.
```

- If **yes** (default for N ≥ 3): go to **Step 2.5 — Parallel mode**
- If **no**, or N < 3: continue to Step 3 (sequential, existing flow)

---

## Step 2.5 — Parallel mode (for batches of 3+ files)

Use this when the user opted in to parallel processing.

### A. Fan out

In a single message, spawn one `general-purpose` sub-agent per file via the Task tool. Each agent receives a self-contained prompt.

**Per-agent prompt template** (substitute placeholders):

> You are analysing a single document for OS-Intelligence context enrichment. Do NOT modify any files in `context/` or `people/`. The main thread will apply those changes after all analyses come back. You MAY add YAML frontmatter to the raw file itself (the file you are analysing) if it lacks one, but do not add `informs` or `enriched` fields yet — the main thread will fill those in.
>
> **File to analyse:** `[FILE_PATH]`
> **Project:** `[PROJECT_NAME]` (slug: `[PROJECT_SLUG]`)
> **Project root:** `[PROJECT_ROOT]`
>
> **Tasks:**
>
> 1. Read the file via the Read tool.
> 2. If the file lacks YAML frontmatter, add it. Required fields: `date`, `type`, `tags` (`type/context`, `project/[PROJECT_SLUG]`, `status/raw`). Leave `informs:` and `enriched:` empty.
> 3. Analyse the content. Identify:
>    - The doc type (call_notes, meeting_prep, board update, policy, etc.)
>    - The date
>    - People mentioned (full names — main thread will resolve to slugs)
>    - Decisions, commitments, or facts the project should know
>    - Tensions, contradictions, or risks worth flagging
>    - Which `context/*` files this document should inform (project.md, business.md, current-state.md, or new ones)
>    - Which `people/*` files this document should inform (one per person meaningfully present)
> 4. Return a structured report in this exact format:
>
> ```
> FILE: [filename]
> TYPE: [doc type]
> DATE: [ISO date]
> SUMMARY: [2-3 sentences on what this reveals]
>
> PARTICIPANTS:
>   - [Full Name] (role, company)
>   - [Full Name] (role, company)
>
> DECISIONS / FACTS:
>   - [item]
>   - [item]
>
> TENSIONS / RISKS:
>   - [item]
>
> CONTEXT FILES TO UPDATE:
>   - target: context/project.md
>     content: |
>       [proposed addition or update — be specific, write the actual text]
>   - target: context/business.md
>     content: |
>       [...]
>
> PEOPLE FILES TO UPDATE:
>   - target: tom-okafor
>     project_addition: |
>       [proposed addition for project people file]
>     root_addition: |
>       [proposed addition for root identity file, if any]
> ```
>
> Return ONLY this report. Do not include other commentary.

Spawn all agents in a single message with multiple Agent tool calls so they run concurrently.

### B. Aggregate reports

When all sub-agents have returned:

1. Collect every report into memory (keep them in main-thread context — they're summaries, not full documents).
2. **Build a target-update map.** For each unique `context/*` file mentioned across all reports, gather the list of `(source_file, proposed_content)` pairs that target it. Same for each unique person.
3. Resolve any people-name ambiguities to slugs (use `people/[slug].md` matching by full name or first name + initial).

### C. Apply context updates (main thread, sequential)

For each unique context-file target:

1. Read the existing file. If it doesn't exist, create it.
2. Take all `proposed_content` blocks for this target and merge into a single coherent update. Deduplicate. Where two sources contradict, prefer the more specific or more recent.
3. Apply per Step 5 of the sequential flow (don't duplicate facts; update or extend existing sections).
4. Update the `## Sources` section to list every raw file that informed this target.

### D. Apply people updates (main thread, sequential)

For each unique person target:

1. Determine project-level path (`[project]/people/[slug].md`) and root-level path (`/people/[slug].md`). Create either if missing (use `people/TEMPLATE.md` for root).
2. Merge all `project_addition` blocks for this person into the project file (per Step 6 of the sequential flow).
3. Merge all `root_addition` blocks into the root file. Skip the root file if no root_addition was provided by any agent.

### E. Mark each raw file as processed

For each file analysed:

1. Determine which context/people files ended up being updated as a result of this raw file's report.
2. Update the raw file's frontmatter:
   - `informs: [list of context/people paths]`
   - `enriched: [today's ISO date]`

### F. Continue to Step 8

After E completes, skip the remaining sequential steps (Step 3 through Step 7 are already covered) and continue to **Step 8 — Update CLAUDE.md** with the full list of new raw files added and context/people files updated.

---

## Step 3 — Identify and accept new material

**Preferred path (cheaper):** Copy files into `[project]/intelligence/docs/raw/` yourself first, then tell me the filenames. Files are read by tool as needed — long content never sits in the conversation window.

**If the user wants to paste something:** Only accept pasted content for short items (under ~300 words). For anything longer, redirect:
```
That's a long file — better to save it to intelligence/docs/raw/ directly and I'll read it from there.
This keeps it out of the conversation window and saves context cost.
```

For each file to be processed, establish:
1. What is it? (call transcript, meeting notes, brief, guide, template, reference doc, etc.)
2. When was it created? (use the date in the filename or frontmatter if present, otherwise ask)
3. Who is involved? (names mentioned as participants or subjects)

Process files one at a time through Steps 4–7. Do not read all files upfront.

---

## Step 3 — Save to intelligence/docs/raw/

For each new file:

**If content was pasted directly:** Write to `[project]/intelligence/docs/raw/[date]-[descriptive-name].md`

Filename conventions:
- Dated files: `YYYYMMDD-description.md` (e.g. `20260416-post-event-notes.md`)
- Undated reference docs: `descriptive-name.md` (e.g. `speaker-intro-brief-generic.md`)
- Transcripts: `YYYYMMDD-[person]-[type].md` (e.g. `20260416-alex-chen-call.md`)

**If file is already in intelligence/docs/raw/:** Confirm it exists, read it, proceed.

**Add YAML frontmatter** to every raw file (at the top, before any content):

```yaml
---
date: YYYY-MM-DD
type: [see types below]
source: [optional — url, recording, tool used]
participants: [optional — list of names if a call/meeting]
informs: [list of context paths this file feeds — fill in after processing]
enriched: [leave blank — added automatically when processing is complete]
tags:
  - type/context
  - project/[project-slug]
  - status/raw
---
```

The project slug is the folder name under `projects/` (e.g. `projects/pm-os/` → `pm-os`).

**Type values:**
- `call_notes` / `call_transcript` — from a meeting or call
- `meeting_prep` — prep document for a meeting
- `action_list` — list of actions from a session
- `event_script` — host guide, run of show, script
- `speaker_brief` — brief sent to or received from a speaker
- `operations_guide` — how-to reference for running events/processes
- `brand_guide` — tone of voice, brand reference
- `template` — reusable blank document
- `speaker_resource` — promotion guides, FAQs for speakers
- `async_exchange` — back-and-forth via email, Slack, WhatsApp
- `research` — desk research, competitive notes, market data

Leave `informs:` empty for now — fill it in after Step 5.

---

## Step 4 — Analyse: what does this material tell us?

For each file, extract the key information:

**Ask yourself:**
- What decisions, plans, or facts does this reveal?
- What do we learn about the project (timeline, structure, goals)?
- What do we learn about the people involved?
- Does this contradict or update anything we already know?
- What context files does this touch? (project.md, business.md, event-format.md, etc.)
- What people files does this touch?

**If the source is an SI synthesis file (`intelligence/meetings/*/synthesis.md`):**
- Focus on project-level facts: company info, product direction, role scope, decisions, open questions
- Skip people file updates — SI already handled the people layer when the transcript was processed
- Extract only what belongs in `context/` files

Write a short analysis (internal — do not show to user unless asked). You'll use this in Step 5 and 6.

---

## Step 5 — Update context files

For each context file that needs updating:

1. Read the existing file
2. Identify what's new from the raw material
3. Update the relevant sections — add, revise, or extend
4. Update the `## Sources` section at the bottom to include the new raw file

**Do not duplicate information.** If a fact is already captured, only update it if the new source refines or corrects it.

**If a needed context file doesn't exist yet:** Create it.

Standard context files for most projects:
- `context/project.md` — team, cadence, financial model, success metrics, key decisions
- `context/business.md` — company/concept, operating model, brand voice
- `context/event-format.md` — for event projects: general format, timeline, roles, moderation

For other project types, create semantically named files as needed:
- `context/product.md`, `context/research.md`, `context/strategy.md`, etc.

**Project-type-specific folders** (not all projects will have these):
- `events/[date-slug]/event.md` — for event series: one subfolder per event with overview, host guide refs, pre-event checklist, post-event notes. The `events/` folder doesn't exist in product or research projects.

If you encounter raw material that's specific to a single event (e.g. a post-event debrief), put the synthesised version in `events/[event-slug]/` rather than the general `context/` folder.

**After updating:** Go back to the raw file and fill in the `informs:` frontmatter with the paths of context files updated (e.g. `informs: [context/project.md, context/event-format.md]`).

---

## Step 6 — Update people files

**Skip this step entirely if the source file is an SI synthesis file.** SI already updated people files when the transcript was processed. Only update people files for sources in `intelligence/docs/raw/`.

For each person meaningfully present in the new material:

### Project-level people file (`[project]/people/[firstname-lastname].md`)

Check if it exists. If not, create it.

Project people files cover:
- Role in this project
- What they care about (in this context)
- Working style and communication preferences
- Relationship dynamics, tensions, history
- Key quotes that reveal their thinking

If it exists, add or refine:
- Anything new about their role or position
- New quotes
- Updated relationship notes

### Root-level people file (`/people/[firstname-lastname].md`)

Check if it exists. If not, create it using `people/TEMPLATE.md`.

Root people files cover:
- Identity: full name, title, company, location
- Contact: LinkedIn, email, phone (if known)
- Tags: function, seniority, relationship type
- Summary: disposition, what they care about, how they work
- Project footprint: which projects they appear in

Update root file when:
- You have new identity or contact information
- Their title or company has changed
- They've joined a new project

Do not add project-specific context (relationship dynamics, event role) to the root file — that belongs in the project people file.

---

## Step 7 — Mark file as processed

After completing Steps 4–6 for a file, update its frontmatter:

**For `intelligence/docs/raw/` files:**
1. Fill in `informs:` with the context files that were updated (e.g. `informs: [context/project.md, people/alex-chen.md]`)
2. Add `enriched: YYYY-MM-DD` (today's date)

**For SI synthesis files (`intelligence/meetings/*/synthesis.md`):**
1. Add `context_enriched: YYYY-MM-DD` to the existing frontmatter
2. Add a `context_informs:` field listing the context files updated (e.g. `context_informs: [context/company.md, context/product.md]`)

These fields are the signal that context enrichment is complete. On the next `/ctx-doc` run, files with the relevant enriched field will be skipped automatically.

---

## Step 8 — Update CLAUDE.md

Open the project's `CLAUDE.md` and update the **Raw Files** table to include any new files added.

Format:
```
| `intelligence/docs/raw/filename.md` | type | context files it informs |
```

If the project CLAUDE.md doesn't have a Raw Files table, add one.

---

## Step 9 — Update current-state.md

Check if `[project-root]/context/current-state.md` exists.

**If it doesn't exist:** Skip — no current-state to update yet.

**If it exists:** Update the **What We Know From Documents** section with the key facts extracted from this enrichment run. Replace or extend — do not duplicate information already there. Summarise what the documents told us in bullet form. Update the Sources reference to include the context files updated.

Update the section's `_Last updated:_` line and the file frontmatter:
```yaml
last-updated: [today's date]
updated-by: ctx-doc
```

---

## Step 10 — Summary

Show the user what changed:

```
Context updated

Raw files added: [N]
  — [filename] ([type])

Context files updated: [N]
  — [filename]: [one line on what changed]

People files updated: [N]
  — [name] (project + root / project only / root only)

CLAUDE.md: updated
```

If nothing needed updating (file was already fully captured), say so clearly.

---

## Notes on judgment calls

**When to create a new context file vs update an existing one:**
Create new if: the information is a distinct domain that will grow over time (e.g. a separate `context/speakers.md` for an event series with many speakers). Update existing if: it's the same domain with more detail.

**When to update root vs project people file only:**
- New identity/contact info → root only
- New project role or relationship context → project only
- Both → both

**When raw content contradicts existing context:**
Trust the newer raw file. Update the context file and note the change. Do not silently overwrite — add a note if the change is significant (e.g. date moved, person left project).

**When the user provides partial information:**
Capture what you have. Leave fields blank rather than guessing. Better to have accurate partial records than inaccurate complete ones.
