---
name: os-new-person
description: Add a person or company. Creates root-level identity files (people/ or companies/) and optionally links to a project. OS-level task — entities are global, not project-specific. Use when someone new comes up and you want to capture them before you forget.
user_invocable: true
---

# OS New Person

Adds a person or a company to global contacts. Fast and conversational — ask only what's needed. This is an OS-level task: people and companies are stored globally (`people/`, `companies/`), not inside projects.

---

## Step 1 — What are you adding?

Ask:
```
What would you like to add?

1. A person
2. A company
```

---

## Adding a Person

### Step P1 — Basic details

Ask in one message:
```
Name and title? (e.g. "Sarah Chen, Head of Product at Vercel")
```

Parse name, title, and company from a natural-language answer. If company isn't clear, ask: `Which company?`

### Step P2 — Duplicate check

Check `people/` at root for an existing file matching the name (fuzzy — first name + last name, case-insensitive).

- **Match found:** Show: `[Name] is already in your contacts ([file]). Want to update their details instead? (Y/N)`
  - If Y: skip to Step P5 with the existing file.
  - If N: stop.
- **No match:** Continue.

### Step P3 — Link to a project?

Read `[workspace-root]/.current-session`. Parse left of ` / ` if it contains a portfolio drill-down (e.g. `Job Opportunities / Acme Corp — Senior PM` → `Job Opportunities`). If the file is missing or empty, skip to option 2. Ask:

```
Link to a project?

1. [Active project name] (active)
2. Choose another project
3. No project — just add to contacts
```

If they choose another project: read `projects.md` and show the active projects list.

### Step P4 — Their role in the project (if linked)

If a project was selected, ask:
```
What's their role in [project name]? (e.g. "engineering lead", "external advisor")
```

### Step P5 — Create files

**Root file** (`people/[firstname-lastname].md`):
Create using `people/TEMPLATE.md`. Populate:
- Name, title, company
- Project Footprint: add the linked project and role (if applicable)
- Leave all other sections blank
- Add frontmatter: `tags: [type/person, status/synthesised]`

**Project-level file** (if a project was linked):
Create `projects/[project-name]/people/[firstname-lastname].md`. Add frontmatter: `tags: [type/person, project/[project-slug], status/synthesised]`

```markdown
# [Full Name] — [Project Name]

**Role:** [Title, Company]
**See also:** [Root profile](../../people/[firstname-lastname].md)

---

## Their Role Here

[Role in project as stated]

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

**Update project CLAUDE.md** (if linked):
Add to the Key People table: `| [Full Name](../../people/[slug].md) | [Role] |`

**Update company file** (if company exists in `companies/`):
If a matching `companies/[name].md` exists, append to its people or contacts section if one exists.

### Step P6 — Add background material (optional)

Ask:
```
Do you have any background material for [Name]?
(LinkedIn profile, bio, blog, intro email — paste content or give me a filename in raw/)

Type "none" to skip.
```

If the user provides content:
- If pasted and short (under ~300 words): write to `[project]/raw/[YYYYMMDD]-[firstname-lastname]-background.md` with frontmatter (`type: research`, `participants: [name]`, `informs: []`, `enriched:` blank)
- If pasted and long: ask them to save it to `raw/` first and provide the filename
- If a filename: confirm it exists in `raw/`

Then process it:
1. Extract key facts about the person (role history, areas of expertise, stated interests, notable work)
2. Update their root `people/[name-slug].md` — Summary and any identity fields that can be filled
3. Update their project-level people file (if linked) — What They Care About, Key Context
4. Fill in `informs:` frontmatter on the raw file and mark `enriched: [today]`

If skipped: continue to Step P7.

---

### Step P7 — Confirm

```
Added [Name] to your contacts.

  ✓ people/[name-slug].md
  [✓ projects/[project]/people/[name-slug].md]
  [✓ projects/[project]/CLAUDE.md updated]
  [✓ raw/[filename] processed]

You can fill in more detail after your first meeting, or run /ctx-doc when you have new material.
```

---

## Adding a Company

### Step C1 — Basic details

Ask in one message:
```
Company name, type, and industry? (e.g. "Vercel — B2B SaaS, developer tooling")
```

Parse name, type (B2B SaaS / agency / startup / enterprise / nonprofit / other), and industry.

### Step C2 — Duplicate check

Check `companies/` for an existing file matching the name.

- **Match found:** Show: `[Company] is already in your contacts ([file]). Want to update it instead? (Y/N)`
- **No match:** Continue.

### Step C3 — Create file

Create `companies/[company-slug].md`:

```markdown
# [Company Name]

## Identity
- **Type:** [B2B SaaS / agency / startup / enterprise / nonprofit / other]
- **Industry:** [industry]
- **Website:**
- **HQ:**

## What They Do

[Fill in]

## Our Relationship

[Fill in]

## Projects

| Project | Description |
|---------|-------------|

## Key Contacts

| Name | Role |
|------|------|
```

### Step C4 — Confirm

```
Added [Company] to your contacts.

  ✓ companies/[company-slug].md

You can fill in more detail as you learn more, or run /ctx-doc when you have raw material.
```
