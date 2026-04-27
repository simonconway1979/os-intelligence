---
title: Architecture
author: Simon Conway
type: reference
status: synthesised
---

# Architecture

How OS-Intelligence is put together, and how the pieces talk to each other.

---

## The mental model

Three things, in order:

1. **Capture** raw context (meetings, documents, notes, chats) into a project's `intelligence/` folder.
2. **Synthesise** across captured context into a living read of where things stand.
3. **Retrieve** that synthesis at the start of every session, so the agent works with full context from minute zero.

Everything else is infrastructure for those three moves.

---

## Four layers

```
┌─────────────────────────────────────────────────────┐
│ Skills (.claude/skills/)                            │
│   ctx-* capture and synthesise                      │
│   os-*  scaffold and orchestrate                    │
├─────────────────────────────────────────────────────┤
│ Sub-agents (sub-agents/)                            │
│   Second-opinion reviewers                          │
├─────────────────────────────────────────────────────┤
│ Context library (context-library/)                  │
│   File conventions, tone, MCP config                │
├─────────────────────────────────────────────────────┤
│ Projects (projects/[project]/)                      │
│   Where actual work and context live                │
└─────────────────────────────────────────────────────┘
```

The first three layers ship in this repo and stay generic. The fourth is yours.

---

## Projects vs portfolios

A **project** is one ongoing piece of work with its own stakeholders, meetings, and decisions. Examples: a product launch, a hiring round, a customer-facing initiative.

A **portfolio** is a container for many smaller items that share a shape but live independently. Examples: a job-search pipeline (each opportunity is an item), an ideas list (each idea is an item), a sales pipeline (each deal is an item).

Both types live under `projects/`. `projects.md` declares the type. Portfolios add a `TRACKER.md` that lists items; each item has its own folder with the same `intelligence/` + `memory/` shape as a project.

`/os-start` handles the difference. For a project it loads context directly. For a portfolio it asks which item you're working on first, then loads that item.

---

## The `intelligence/` folder

Every project has one. Four subfolders, one per shape of input:

```
intelligence/
├── meetings/    ← /ctx-transcript writes here
├── docs/raw/    ← /ctx-doc reads from here, writes synthesis alongside
├── notes/       ← /ctx-note writes here
└── chats/       ← /ctx-chat writes here
```

Each subfolder follows the same file convention: raw input is append-only and never edited; LLM synthesis sits next to it with `status/synthesised` in frontmatter; once you've reviewed it, change to `status/validated`.

`/ctx-synthesise` reads across all four subfolders and updates `context/current-state.md` with the cross-cutting picture: who said what, what tensions are open, what's in flight.

---

## `current-state.md` as the live read

This is the file `/os-start` loads. Not the most recent session file, not the project README — `current-state.md`.

Sections:

- **Project Position** · where things stand in 2-3 sentences
- **Stakeholder Dynamics** · who matters, what they want, where the tensions are
- **Standing Decisions** · decisions made and why
- **In Flight** · what's open right now
- **Open Questions / Blockers** · what's unresolved
- **Recent Changes** · the last week or two of meaningful shifts

`os-save`, `ctx-synthesise`, and `ctx-doc` all write into `current-state.md`. Each section carries a `_Last updated:_` timestamp so `/os-start` can flag stale sections.

Session files in `memory/` (`YYYYMMDD-HHMM.md`) are archives. They're useful for "what did I do last Tuesday" but not the primary retrieval target.

---

## CLAUDE.md inheritance

```
/CLAUDE.md                       ← root: OS-Intelligence working context
└── projects/[project]/CLAUDE.md ← project: name, goal, key people, focus
    └── projects/[project]/[item]/CLAUDE.md  (portfolios only)
```

Each level adds context, none replaces. The root file holds output rules, conventions, and pointers to tone / MCP / add-ons. The project file holds the project's name, goal, people, and current focus.

If you already have a working `CLAUDE.md`, you can drop it in as the root file. Just preserve the stakeholder-intelligence section so the `ctx-` skills know where to write. See the section in [`CLAUDE.md`](CLAUDE.md).

---

## The skills, by job

### Capture

| Skill | What it does |
|---|---|
| `/ctx-transcript` | Process a meeting transcript: synthesise, extract decisions, link people, update current-state.md |
| `/ctx-doc` | Add a document to the project; enrich context files; sync people records |
| `/ctx-note` | Capture a personal observation, written note, or voice memo; link to a person if relevant |
| `/ctx-chat` | Capture a WhatsApp / Slack / DM thread with deduplication for re-imports |
| `/ctx-inspiration` | Process new files in the global inspiration library (cross-project content) |

### Synthesise

| Skill | What it does |
|---|---|
| `/ctx-synthesise` | Cross-synthesise across all meetings, docs, notes, chats for the active project; update standing briefs |
| `/ctx-timeline` | Generate a project timeline from captured intelligence |

### Retrieve

| Skill | What it does |
|---|---|
| `/os-welcome` | First-run entry point; routes new users to first synthesis on their own data in <15 min |
| `/os-start` | Load project context at session start; show current-state, in flight, open questions |
| `/os-save` | Save session summary; update current-state.md; create a memory snapshot |
| `/os-switch-project` | Switch active project mid-session |

### Scaffold

| Skill | What it does |
|---|---|
| `/os-new-project` | Create a new project from template; link people and company; generate CLAUDE.md |
| `/os-new-item` | Add an item to an existing portfolio |
| `/os-new-person` | Add a person or company at root level |
| `/os-project-design` | Design a project's structure when the standard template doesn't fit |

---

## Sub-agents

Seven reviewer perspectives in `sub-agents/`. Each is a Claude Code sub-agent that reads your work and gives a second opinion from a defined point of view.

| Sub-agent | Use when |
|---|---|
| `customer-voice` | Validating that a decision survives a real customer conversation |
| `designer-reviewer` | UX or product-design critique |
| `engineer-reviewer` | Technical feasibility and edge cases |
| `executive-reviewer` | Will this hold up in front of leadership |
| `legal-advisor` | Compliance, contract, IP risk |
| `skeptic` | Challenge the load-bearing assumptions |
| `uxr-analyst` | User research lens on interview data, surveys, or behavioural signals |

---

## Where things actually live

```
os-intelligence/
├── .claude/skills/          ← 16 skills (capture + synthesise + retrieve + scaffold)
├── sub-agents/              ← 7 reviewer perspectives
├── context-library/
│   ├── file-conventions.md       ← naming, folders, frontmatter, status tags
│   ├── writing-styles.md         ← tone of voice (edit to yours)
│   ├── writing-styles-global/    ← 5 audience-specific style guides
│   ├── tone-of-voice.md          ← stub, points to writing-styles-global
│   └── mcp-setup.md              ← stub, paste your MCP routing
├── docs/
│   └── addons.md            ← how to drop in your own skills + frameworks
├── projects/
│   └── acme-corp-example/   ← example project, full intelligence/ shape
├── people/                  ← global identity (one file per person)
├── companies/               ← global company files
├── CLAUDE.md                ← root working context (this is what Claude reads)
├── README.md                ← what is this, who it's for
├── ARCHITECTURE.md          ← this file
├── MIGRATION.md             ← how to set up + how to overlay an existing setup
├── projects.md              ← projects index
└── LICENSE                  ← Apache 2.0
```

---

## File conventions

Status tags (`raw`, `synthesised`, `validated`, `archived`), frontmatter shape, naming rules: [`context-library/file-conventions.md`](context-library/file-conventions.md).

Tag taxonomy: `type/`, `project/`, `status/`, `theme/`, `item/`. YAML frontmatter, nested format. The skills enforce this on write; you don't normally have to think about it.
