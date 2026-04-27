---
title: Usage Log
type: reference
status: synthesised
---

# Usage Log

OS-Intelligence keeps a local activity log so you can see your own patterns: how often you use each skill, how many sessions you've run, how active you are over time.

**This file never leaves your machine.** It's not telemetry. Nothing is sent to any server. The only thing OS-Intelligence ever sends to the network is whatever Claude Code already sends when you prompt it (the standard Anthropic API call). The log is for you.

---

## Where it lives

```
.os-intel-log/usage.jsonl
```

At the root of this repo. Excluded from git via `.gitignore` so it never gets committed by accident.

---

## What it captures

Two event types, one line per event, JSONL format:

```jsonl
{"ts":"2026-04-26T22:30:15Z","event":"session_start"}
{"ts":"2026-04-26T22:35:42Z","event":"skill_run","skill":"ctx-transcript"}
{"ts":"2026-04-26T22:40:18Z","event":"skill_run","skill":"ctx-synthesise"}
{"ts":"2026-04-26T22:45:00Z","event":"skill_run","skill":"os-save"}
```

Fields:

- `ts` — UTC timestamp, ISO 8601
- `event` — one of `session_start`, `skill_run`
- `skill` — the skill name (only present on `skill_run` events)

That's it. **No project names, person names, company names, file paths, or content of any kind.** Just timestamps, event types, and skill names.

---

## What you can learn from it

- How many sessions you run per day or week
- Which skills you reach for most
- How your skill mix shifts over time (heavy capture phase vs heavy synthesis phase)
- Gaps in usage that might indicate friction points
- Whether you're a power user

Simple aggregations:

```bash
# Sessions in last 7 days
grep '"event":"session_start"' .os-intel-log/usage.jsonl \
  | awk -F'"' '{print $4}' \
  | sort | uniq -c

# Top 5 skills used
grep '"event":"skill_run"' .os-intel-log/usage.jsonl \
  | grep -oE '"skill":"[^"]*"' \
  | sort | uniq -c | sort -rn | head -5

# Total events ever
wc -l .os-intel-log/usage.jsonl
```

---

## How it works

A Claude Code hook fires after every `Skill` tool call and every session start. The hook runs `scripts/log-event.sh`, which appends one JSONL line to the log file.

The hook is configured in `.claude/settings.json`. The script is at `scripts/log-event.sh`. Both are plain text — read them if you want to see exactly what's being captured.

The script is defensive: any failure exits silently with status 0, so logging can never block Claude Code from doing actual work.

---

## How to disable

Open `.claude/settings.json` and remove the `hooks` block, or remove just the entries you don't want. Save. Done.

To delete the log entirely:

```bash
rm -rf .os-intel-log/
```

You can also run `rm -rf .os-intel-log/` periodically if you'd rather only keep a recent window of activity.

---

## Sharing usage stats (later)

A future skill — `/share-usage` — will summarise the log and offer to copy the summary to your clipboard or share it. **Always opt-in, every time.** The local log is not connected to any sharing mechanism by default. You decide when (or whether) any aggregate ever leaves your machine.

For v0.1.0, just the local log. The sharing skill ships in a later version.

---

## Why we built this

Three reasons:

1. **Self-knowledge.** You should be able to see how you actually use the system. Most software hides this from users; we're not hiding it.
2. **Power-user signal (with consent).** When `/share-usage` ships, users who voluntarily share aggregates can identify themselves as power users — useful for community building and the consulting practice.
3. **No telemetry.** Many tools collect this data invisibly and ship it to a vendor. We won't. The log being local + inspectable is the entire trust model.

If any of this isn't comfortable, disable the hooks and delete the log. The system works the same.
