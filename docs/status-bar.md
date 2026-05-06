# Status bar setup

Your Claude Code status bar is the always-visible dashboard at the bottom of your terminal. By default, it's empty.

Set up well, it stops you from breaking flow to ask "what model am I on?" or "how full is my context?" The answer is just there.

This guide is the OS-Intelligence-specific recommendation. For the comprehensive walkthrough, see [Hannah Stulberg's article on status lines](https://hannahstulberg.substack.com/p/claude-code-for-everything-your-status-line-is-empty). Most of the patterns below come from her work.

---

## What we recommend for OS-Intelligence

Five essentials:

1. **Current folder** so you always know which project you're in
2. **Current model** (Opus, Sonnet, or Haiku)
3. **Context usage progress bar**, color-coded so you see when to compact (green under 50%, yellow 50–70%, red above 70%)
4. **Session cost** if you're on API billing
5. **Active session** the project name from `.current-session` so you know which OS-Intelligence project Claude is working in

---

## Set it up

Run Claude Code in any project folder, then ask:

> *"Set up my status line to show my current folder, model, a color-coded context window progress bar (green under 50%, yellow 50–70%, red above 70%), session cost in USD, and the contents of `.current-session` from the workspace root. Test it and show me how it looks."*

Claude writes the configuration into `~/.claude/settings.json` (or, on Windows, into a Node.js script at `~/.claude/statusline.js`).

**Mac / Linux:** restart Claude Code for changes to take effect (`exit`, then `claude`).

**Windows:** ask Claude to write your status line as a Node.js script at `~/.claude/statusline.js`. Inline commands in `settings.json` often break on Windows. The script auto-reloads, no restart needed.

---

## Going further

Hannah's article walks through everything else you can put on a status line:

- Git branch and uncommitted file count
- GitHub PR count
- Weather, air quality, sunrise / sunset
- Next calendar event, unread Gmail (one-time Google Workspace MCP setup)
- Time in another timezone, countdown to a date, public transit
- Stock prices, sports scores, moon phase
- Anything Claude can fetch from the web, a CLI tool, an API, or an MCP

The pattern is always the same: tell Claude what you want to see and Claude figures out how to get it.

Read the [full article](https://hannahstulberg.substack.com/p/claude-code-for-everything-your-status-line-is-empty) and add what fits how you actually work.

---

## Credit

This guide is adapted from [Hannah Stulberg's "Claude Code for Everything: Your Status Line Is Empty (Let's Fix That)"](https://hannahstulberg.substack.com/p/claude-code-for-everything-your-status-line-is-empty), the sixth article in her Claude Code for Everything series. Most of the patterns here come directly from her work; the OS-Intelligence-specific defaults are ours.

Hannah's full series: [hannahstulberg.substack.com](https://hannahstulberg.substack.com).
