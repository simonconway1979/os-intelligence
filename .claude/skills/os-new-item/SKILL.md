---
name: os-new-item
description: Add a new item to any portfolio project. Reads the portfolio's CLAUDE.md for item name and template path. Creates the item folder from templates/item/, updates TRACKER.md. Works for any portfolio type (opportunities, ideas, articles, etc.).
user_invocable: true
---

# /os-new-item — Add a New Item to a Portfolio

Generic skill for adding a new item to any portfolio project. Works for job opportunities, ideas, reading lists, or any other portfolio type.

---

## Step 1 — Identify the portfolio

If called from within an active portfolio session (i.e. os-start has already loaded a portfolio): use that portfolio's project path automatically.

If called standalone (no active portfolio context): read `projects.md`, filter to entries where `**Type:** portfolio`, and ask:

```
Which portfolio are you adding to?

1. [Portfolio Name]
2. [Portfolio Name]
```

Wait for selection.

---

## Step 2 — Read portfolio configuration

Read the selected portfolio's `CLAUDE.md`. Extract from the `## Portfolio` section:
- `**Item name:**` — what a single item is called (e.g., opportunity, idea, article)
- `**Items folder:**` — where items live (e.g., `opportunities/`, `ideas/`)
- `**Tracker:**` — tracker file name (default: `TRACKER.md`)

Read the `templates/[item-name]/[item-name].md` file to understand what fields the item template expects.

---

## Step 3 — Gather inputs

Ask for the minimum needed to create a useful item record. Base questions on the item template fields. At minimum, always ask:

1. **"What's the [item name] called?"** (name or title)
2. **"One sentence — what is it or why does it matter?"**
3. **"What's the first action you'll take on this?"**

If the template has additional frontmatter fields (e.g., `stage`, `fit`, `source`), ask for those too — but only what's useful now. Don't ask for fields the user can fill in later.

If the user has already provided some of this in their message, don't re-ask.

---

## Step 4 — Generate the slug

Create a kebab-case slug from the item name: `[key-words-from-name]`

Examples:
- "Acme Corp — Senior PM" → `acme-corp-senior-pm`
- "A feature for async notifications" → `async-notifications`
- "The Art of Strategy by Dixit & Nalebuff" → `art-of-strategy`

Confirm the slug with the user before creating files.

---

## Step 5 — Create the item folder

Copy `projects/[portfolio-name]/templates/[item-name]/` to `projects/[portfolio-name]/[items-folder]/[slug]/`.

Populate the main `[item-name].md` file with:
- Frontmatter filled from Step 3 inputs
- Body sections from the template, with what's known filled in and blanks left rather than guessed

Ensure these subfolders exist (create with `.gitkeep` if the template didn't include them):
- `intelligence/meetings/`
- `intelligence/docs/raw/`
- `intelligence/chats/`
- `intelligence/notes/`
- `memory/`
- `people/`
- `context/`

---

## Step 6 — Update TRACKER.md

Add a row to the active items table in the portfolio's `TRACKER.md`.

Use the stage from the item frontmatter (default to first stage if not set). Match the column format of the existing table.

---

## Step 7 — Update .current-session

Write to `[workspace-root]/.current-session`:

```
[Portfolio Name] / [Item Display Name]
```

Example: `Ideas / Interview Follow-Up Engine`

This makes the new item the active session context so subsequent skills (os-save, ctx-doc, etc.) target it automatically.

---

## Step 8 — Confirm and suggest next step

Show the user:

```
[Item name] added: [Display name]
Folder: [items-folder]/[slug]/
Active session: updated → [Portfolio Name] / [Item Display Name]

Next: [most logical first action based on next_action field or Step 3 answer]
```

---

## Notes

- This skill replaces the need for portfolio-specific add skills (jobs-new-opportunity, ideas-new) over time. Those skills remain valid for portfolios that already use them.
- If the template folder doesn't exist, tell the user: "No template found at templates/[item-name]/. Create one first or run /os-project-design to set up the portfolio structure."
