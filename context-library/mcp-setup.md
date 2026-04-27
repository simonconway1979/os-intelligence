---
name: mcp-setup
description: MCP routing and setup. Paste your own MCP block here.
type: reference
tags:
  - type/reference
  - status/synthesised
---

# MCP Setup

This is a stub. Paste your own MCP routing logic and config here.

[MCP](https://modelcontextprotocol.io/) (Model Context Protocol) lets Claude Code connect to external services: Gmail, Google Calendar, Google Drive, Slack, GitHub, your own internal APIs. OS-Intelligence doesn't ship with MCP servers configured — that's per-user.

---

## What to put here

Two things, ideally:

1. **Routing logic.** When should Claude reach for which MCP? "Use Gmail MCP for inbox actions, Calendar MCP for scheduling, Drive MCP for shared documents." A short list keeps Claude from guessing.
2. **The MCP block itself.** The JSON or whatever format your MCP harness expects.

---

## Example structure

```markdown
## Routing

- **Email** → Gmail MCP. Read, draft, send.
- **Calendar** → Google Calendar MCP. Create events, find conflicts.
- **Files** → Google Drive MCP. Search, fetch, attach.
- **Project tracker** → [your tool]. Create issues, update status.

## Config

[paste your MCP config block here]
```

---

## Connecting MCPs

Claude Code's `/connect-mcps` command (or the equivalent in your harness) handles authentication. Once connected, the routing list above tells Claude which to reach for in which situation.
