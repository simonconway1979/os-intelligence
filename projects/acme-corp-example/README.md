# Acme Corp Example Project

This folder demonstrates a populated OS-Intelligence project: stakeholders, meetings, documents, notes, and a synthesised `current-state.md` showing what the system produces after a few weeks of use.

**Status:** placeholder — full example content lands in v0.1.1.

For now, see:
- [`../../ARCHITECTURE.md`](../../ARCHITECTURE.md) for the conceptual model and folder shape this example will follow.
- [`../../MIGRATION.md`](../../MIGRATION.md) for how to set up your own first project.
- [`../../README.md`](../../README.md) for the three "try this in 10 minutes" use cases.

When the example ships, this folder will contain:

```
acme-corp-example/
├── CLAUDE.md           ← project context (Acme Corp scenario)
├── context/
│   └── current-state.md ← synthesised picture, the live read
├── intelligence/
│   ├── meetings/        ← 2 meeting transcripts + synthesis
│   ├── docs/raw/        ← 1 example document + synthesis
│   ├── notes/           ← 1 example note
│   └── chats/           ← 1 example thread
├── people/              ← 3 stakeholders (Alex Chen, Priya Sharma, Marcus Webb)
└── memory/              ← session save examples
```

Run `/os-welcome` after install to be walked through your own first project, or browse this folder once the content lands to see the full shape.
