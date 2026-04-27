---
tags:
  - type/context
  - status/validated
---

# PM-OS File Conventions

How files are organised and written across all projects.

---

## Three-Layer System (within each project)

**`intelligence/docs/raw/`** — Original source documents exactly as received or written. Never edited after creation. Each file has YAML frontmatter with `informs:` tags pointing to which context files it feeds.

**`context/`** — Synthesised documents built from raw sources. Always include a `## Sources` section listing which raw files they draw from. Update these when new raw files arrive, not the raw files themselves.

**`people/`** — Project-specific profiles for people in this project. Covers: role here, what they care about, working style, relationship dynamics. Always link to root `/people/[name].md` (which holds identity, contact details, cross-project patterns).

---

## People System (two layers)

**Root `/people/[name].md`** — Global identity: name, title, contact details, project footprint table, standing brief (updated by `/ctx-synthesise`). One file per person, permanent.

**Project `people/[name].md`** — Operational context for this project only. Links to root profile. Created by `/ctx-transcript`, `/os-new-project`, or `/os-new-person`.

---

## Memory System (per project)

**`memory/YYYYMMDD-HHMM.md`** — Session saves. Fixed structure: Summary, Active Work Streams, Files Changed, Key Decisions, Current State, Next Steps.

**`memory/SESSIONS-INDEX.md`** — One-line summary per session. Scanned on `/os-start` without reading every file.

---

## Intelligence (per project)

```
intelligence/
├── meetings/
│   └── YYYYMMDD-HHMM-[person-slug]/
│       ├── raw.md          ← verbatim transcript, never edited
│       ├── synthesis.md    ← structured analysis
│       ├── validation.md   ← evidence audit (interpretive claims only)
│       └── shareable.md    ← professional summary safe to send
├── docs/
│   └── raw/                ← drop source documents here (never edited)
├── chats/
│   └── [thread-slug]/
│       └── [date-range]/
│           ├── raw.md
│           └── synthesis.md
├── notes/
│   └── YYYYMMDD-[slug]/
│       ├── raw.md
│       └── synthesis.md
├── cross-synthesis.md      ← output of /ctx-synthesise
└── timeline.md             ← output of /ctx-timeline
```

---

## Key Rules

- Raw files are never edited after creation.
- Context files always have a `## Sources` section.
- Project people files always link to root `/people/`.
- Session saves go in `memory/`, not `context/` or `outputs/`.
- Never put project-specific content at root level.
