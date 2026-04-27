# Writing Styles — Global

> **Edit these files to match your own tone of voice.** The five style guides below are starting points (customer / executive / internal / social / technical). Replace the defaults with the specific words, structures, and constraints that make your writing recognisable. The system loads whatever you put here when generating content for that audience.

## Files

- `writing-style-customer.md` — for product marketing, help docs, customer communications
- `writing-style-executive.md` — for board updates, exec memos, decision docs
- `writing-style-internal.md` — for team docs, design docs, internal comms
- `writing-style-social.md` — for LinkedIn, Twitter, social media posts
- `writing-style-technical.md` — for API docs, technical specs, engineering writeups

## How to use

When you want a specific style applied to generated content, reference the file in your prompt: `@context-library/writing-styles-global/writing-style-executive.md`.

Skills you build on top of os-intelligence (e.g. blog drafting, status updates, social posts) can load the relevant style file directly so output matches the audience.
