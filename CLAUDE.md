# CLAUDE — OS-Intelligence

The working context for any Claude Code session opened in this repo.

This file inherits down: every project under `projects/` reads this, then adds its own `CLAUDE.md` on top.

---

## What OS-Intelligence is

A context layer for Claude Code. It captures meetings, documents, notes, and chats; synthesises across them; and surfaces what matters at the start of every session. See [`README.md`](README.md) for the full pitch and [`ARCHITECTURE.md`](ARCHITECTURE.md) for the mental model.

---

## How to interact

- Ask clarifying questions before assuming.
- Challenge assumptions: "Have you considered...?" "What if we're wrong about...?"
- Flag risks, missing stakeholders, and edge cases proactively.
- Reference specific files in this workspace by path.
- Revisions: re-read the output file and apply the specific change. Never regenerate from scratch.
- No hedging, no "perhaps," no corporate jargon, no AI disclaimers.

---

## Output rules

- Shorter is better. Minimum viable document.
- Specific over generic. Real names, real numbers, real quotes.
- Actionable over informational. Every section helps someone decide or act.

**Voice:** vary sentence length. Use contractions. Avoid AI-flavoured filler. Default tone lives in [`context-library/tone-of-voice.md`](context-library/tone-of-voice.md) — edit it to your own voice.

---

## File conventions

Naming, folder shape, frontmatter, status tags: [`context-library/file-conventions.md`](context-library/file-conventions.md).

---

## Stakeholder intelligence

This is the part to keep if you replace this `CLAUDE.md` with your own. The `ctx-` skills depend on it.

```
projects/[project]/
├── CLAUDE.md           ← project-level context, inherits from this file
├── context/
│   └── current-state.md ← living synthesis, loaded at /os-start
├── intelligence/
│   ├── meetings/        ← /ctx-transcript output
│   ├── docs/raw/        ← /ctx-doc input + output
│   ├── notes/           ← /ctx-note output
│   └── chats/           ← /ctx-chat output
├── people/              ← project-level person context (root /people/ holds global identity)
└── memory/              ← /os-save session files
```

`current-state.md` is the live read. Session files are archives. The `ctx-` skills write into `intelligence/`; `os-save` and `ctx-synthesise` keep `current-state.md` updated.

If you swap in your own `CLAUDE.md`, preserve this folder shape and these conventions so the skills keep working.

---

## MCP setup

Routing logic and example config: [`context-library/mcp-setup.md`](context-library/mcp-setup.md). Paste your own MCP block there.

---

## Adding your own skills, sub-agents, and frameworks

OS-Intelligence ships an intelligence layer, not a full PM toolkit. To add your own decks, content, planning, or domain skills on top: [`docs/addons.md`](docs/addons.md).

---

## Skills

| Group | Skills |
|---|---|
| **OS containers** | `os-welcome`, `os-start`, `os-save`, `os-switch-project`, `os-new-project`, `os-new-item`, `os-new-person`, `os-project-design`, `new-project` |
| **Context (ctx-)** | `ctx-transcript`, `ctx-doc`, `ctx-note`, `ctx-chat`, `ctx-synthesise`, `ctx-timeline`, `ctx-inspiration` |

Sub-agents (in `sub-agents/`): `customer-voice`, `designer-reviewer`, `engineer-reviewer`, `executive-reviewer`, `legal-advisor`, `skeptic`, `uxr-analyst`.

---

## Workspace shape

```
os-intelligence/
├── .claude/skills/          ← 15 skills (intelligence + OS containers)
├── sub-agents/              ← 7 reviewer perspectives
├── context-library/         ← conventions, tone, MCP config
├── projects/[project]/      ← inherits this CLAUDE.md
├── people/                  ← global identity files
├── companies/               ← global company files
└── docs/                    ← repo-level docs (architecture, migration, addons)
```

Every project under `projects/` follows the stakeholder-intelligence shape above.
