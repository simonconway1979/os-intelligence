---
name: add-context
description: Add context to the active project. Triages the input as a meeting transcript, document, personal note, or chat thread — then routes to the right writer. Replaces the four `/ctx-*` entry points.
user_invocable: true
---

# /add-context

One entry point for adding context. Reads the input, classifies it (transcript / doc / note / chat), and routes to the existing writer skill.

**Scope (v0.2):** thin router only. The four `/ctx-*` writers stay as they are. Downstream UX alignment + frontmatter standardisation tracked separately (T2.5, T2.6).

---

## Invocation shapes

```
/add-context <file-path>
/add-context <file-path> -- <hint>
/add-context                              # then prompt for content
/add-context --type <transcript|doc|note|chat> <file-path>
```

- **`<file-path>`** preferred over pasted content. Pasted content sits in the conversation window and is expensive for long files. If the user pastes a long block, suggest they save it to a file first.
- **`-- <hint>`** is anything after a literal `--` separator. Fed into the classifier as a hint.
- **`--type X`** hard override. Skips classification, logs `override=true` in telemetry.

---

## Step 1 — Resolve project

Read the active project:

1. If your Claude Code session ID is in context (injected by the SessionStart hook), read `[workspace-root]/.sessions/<session-id>`.
2. Fall back to `[workspace-root]/.current-session` if the per-session file doesn't exist.
3. If neither exists or both are `(no project)`, stop and say: `No active project. Run /os-start to pick one, then re-run /add-context.`

Look up the project in `projects.md` to get `PROJECT_ROOT`. For portfolios, parse left of ` / ` as portfolio name and use the portfolio root.

---

## Step 2 — Read the input header

If the input is a file path:
- Read the first 60 lines via the Read tool.
- Capture filename + extension.

If the input is pasted content:
- Take the first 60 lines of the paste as-is.
- No filename signal available.

If no input was given:
- Print: `Paste content below, or give a file path:`
- Wait for input. Treat the reply as either a path or paste.

---

## Step 3 — Classify

Skip this step if `--type X` was passed.

**Pre-check: is this global inspiration, not project context?** If the content is an external article, talk, or post the user found inspirational (not tied to one specific project), suggest `/ctx-inspiration` instead and stop:

```
This looks like global inspiration, not project context. Run /ctx-inspiration
to add it to context-library/inspiration/ where it's available across all projects.

Continue with /add-context anyway? [y/N]
```

Signals it's inspiration: filename or paste contains `substack.com`, `youtube.com`, `medium.com`, `blog`, talk-transcript with external speaker, or the hint says "inspiration" / "for the library" / "found this". When unsure, ask. If the user confirms project-specific, continue to scoring.

Score the four types in this order. First match with high confidence wins. If nothing scores high, ask.

### 1. Chat (highest-confidence signature)

Indicators:
- 5+ lines matching a per-message timestamp pattern:
  - WhatsApp: `[DD/MM/YYYY, HH:MM:SS] Name: …` or `[DD/MM/YYYY, HH:MM] Name: …`
  - Slack: `Name [HH:MM AM/PM]` on one line, message on the next
  - iMessage export: `Date Time` header followed by `Name:` lines
- Short messages (most turns < 200 chars)
- Reaction markers: `<image omitted>`, emoji reactions (`👍`, `❤️` on own lines), `:thumbsup:` (Slack)
- Filename hints: `whatsapp`, `slack`, `imessage`, `dm`, `chat`, `thread`

→ **high confidence: route to `/ctx-chat`**

### 2. Transcript

Indicators:
- Speaker labels at line start without per-message timestamps: `Speaker 1:`, `Name:`, `SIMON:`, or bold patterns `**Name**:`
- Long turns (avg > 200 chars per turn)
- Headers like `Recording started at …`, `Transcript - YYYY-MM-DD`, `Meeting:`
- Total length usually > 500 lines
- **Spoken-language disfluencies** — these don't appear in chats, docs, or notes:
  - Bracketed transcript artifacts: `[inaudible]`, `[laughter]`, `[crosstalk]`, `[unclear]`, `[pause]`, `[music]` — strong signal even at 1–2 occurrences
  - Filler words at conversational density: `um`, `uh`, `er`, `ah`, `hmm`, `you know`, `I mean`, `sort of`, `kind of` — count cumulative occurrences; 5+ in 60 lines is high signal
  - False starts and self-corrections: `I — well, what I mean is…`, repeated words at the start of phrases
- Filename hints: `transcript`, `recording`, `meeting`, `call`, `zoom`, `granola`

→ **high confidence: route to `/ctx-transcript`**

### 3. Note

**Headline signal: the user is the author.** A note is Simon's own observation, reflection, or voice memo. If a different author owns the content, it's a doc — not a note — regardless of length.

Supporting indicators:
- First-person prose, single author voice ("I think", "my read", "today I…")
- Short input (< 200 lines)
- No speaker labels
- Filename hints: `note`, `thought`, `reflection`, `observation`, `journal`
- Pasted content with no source attribution defaults here when short

→ **medium confidence: route to `/ctx-note`**

### 4. Doc (fallback)

**Headline signal: external authorship.** A doc is content authored by someone other than the user — articles, briefs, analyses, transcripts of external talks, Substack posts, PDFs. Preserve provenance (URL, author, captured-date) in frontmatter.

Supporting indicators:
- Long-form prose with structure (headings, sections)
- Third-person voice
- Filename hints: `memo`, `report`, `analysis`, `log`, `critique`, `teardown`, `brief`, `prd`, `decision`, `.pdf` source
- Anything that doesn't match the above three

→ **route to `/ctx-doc`**

**Two-artifact case.** When the user wants to capture both an external piece *and* their reaction to it, treat as two adds: one doc for the source, one note for the reflection (the note should link to the doc). Don't fold them into one — the source attribution is lost.

### Tiebreakers

- **Chat vs note:** when ambiguous, bias toward chat. A note misclassified as chat is harmless. A chat misclassified as note locks the thread out of dedup on the next reply (Standing Decision: chats must use ctx-chat).
- **Transcript vs chat:** Zoom exports can look chat-like with `Person [HH:MM:SS]:` per-message timestamps. Disfluencies (`[inaudible]`, filler words, false starts) break the tie toward transcript — chats don't have them. Falling back to length: turn averages > 200 chars + no reactions/short-message bursts = transcript.
- **Note vs doc:** first-person + short = note. Third-person or > 200 lines = doc.
- **The hint wins close calls.** If the user wrote `-- this is my reflection on …`, route to note even if the heuristics say doc.

### Confidence threshold

If no type scores high after the heuristics + hint, surface:

```
I think this is a [best-guess], but I'm not sure. Type one to confirm:
  [1] transcript    [2] doc    [3] note    [4] chat
```

Wait for selection. Don't route confidently below threshold.

---

## Step 4 — Log telemetry

Append one line to `[workspace-root]/logs/triage.log`:

```
<ISO8601-timestamp> | <input-shape> | <classified-as> | <confidence> | <hint-used> | <override>
```

Where:
- `<input-shape>` is `file` or `paste` or `none`
- `<classified-as>` is `transcript` / `doc` / `note` / `chat`
- `<confidence>` is `high` / `medium` / `asked`
- `<hint-used>` is `yes` / `no`
- `<override>` is `yes` (--type set) / `no`

Create `logs/` and `logs/triage.log` if they don't exist. Append-only. Don't read it back to the user.

---

## Step 5 — Route to writer

Print a one-line confirmation:

```
Type: <classified-as>. Routing to /ctx-<X>.
```

Then invoke the matching skill via the Skill tool:

| Classified as | Skill to invoke |
|---|---|
| transcript | `ctx-transcript` |
| doc | `ctx-doc` |
| note | `ctx-note` |
| chat | `ctx-chat` |

Pass the file path (or pasted content path) to the writer. From here the existing writer's flow takes over: it'll prompt for any missing context (attendees, person link, thread name, etc.) per its own SKILL.md.

**Do not duplicate the writer's prompts.** If the writer asks for the project again, that's fine — the user confirms.

---

## Edge cases

- **Empty file:** stop. Say `<path> is empty. Nothing to add.`
- **File doesn't exist:** stop. Say `Can't read <path>. Check the file path and re-run.`
- **Binary file:** stop. Say `<path> looks binary. /add-context expects text (markdown, txt, transcript export).`
- **Path contains a hint-like `--`:** the separator only takes effect when surrounded by spaces. `/add-context /Users/me/foo--bar.md` reads the whole token as a path.
- **`--type X` with malformed value:** stop. Say `Unknown type <X>. Use: transcript, doc, note, chat.`
- **Pasted content > 500 lines:** suggest `Long paste — save to a file and re-run with the path. That keeps the content out of the chat window (cheaper).`

---

## What this skill does NOT do

- Frontmatter standardisation (tracked: T2.6, this week).
- Writer UX alignment, including decommissioning `/ctx-doc`'s legacy `current-state.md` sync (tracked: T2.5, this week).
- Synthesis. The writers do their own synthesis as today.
- Validation flag work (tracked: T3.3).
