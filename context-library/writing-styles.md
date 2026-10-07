---
tags:
  - type/context
  - status/validated
---

# Writing Styles

> **Edit this file to match your own tone of voice.** The defaults below are starting points — replace them with the specific words, structures, and constraints that make writing sound like *you*. The system loads whatever you put here and applies it to generated content.

Full style guides for each audience type. Load this file with `@context-library/writing-styles.md` when you need a specific style applied.

---

## Internal

Conversational but professional. Use "we" not "I." Direct and action-oriented. Bullets over paragraphs where possible.

---

## Technical

Precise terminology. Include edge cases explicitly. Technical constraints upfront. API/integration details where relevant.

---

## Executive

Start with the "so what." Numbers and impact first. Strategic rationale clear. End with a clear ask — what decision do you need?

---

## User-facing

Simple language (8th grade reading level). Benefits before features. Concrete examples over abstractions. Empathetic tone.

---

## Simple English

For pages people read cold, often in a second language: Confluence pages, onboarding guides, FAQs, status updates, announcements. Not for chat messages to named people, meeting notes, or working files. Those follow the Voice section in `CLAUDE.md`.

Based on ASD-STE100 Simplified Technical English, rewritten as house rules. The core rules and the self-check below are the working version.

Core rules:

- Two kinds of text. Procedure: imperative, one instruction per sentence, 20 words max, condition before command. Description: present or past simple, 25 words max, one topic per paragraph, name the actor.
- One word, one meaning. No synonym rotation. The short common word: "use" not "utilise", "start" not "initiate".
- Verbs over noun phrases. "We decided", not "a decision was made".
- Define a concept term at first use, in under ten words, in the same sentence.
- Modals: can, will, must. Never should, would, may, might, could. Keep uncertainty in plain words; never upgrade a hedge to a fact.
- No contractions. No semicolons. No em dashes. No "-ing" clause after a comma. No sets of three for rhythm.
- Headings are a noun phrase or a question, one line. Lists for three or more items only. No bold lead-ins, no emoji.
- British spelling. Numbers as digits. Dates as "15 September 2026".

Self-check before publishing: split the three longest sentences over the limit; search for `'`, `has been`, `should`, `may`, `might`, `could`, `;`, `—`, `, making`, `, allowing`, `, ensuring`; check every heading; read the first sentence as a stranger.

---

## Anti-AI patterns to avoid

Independent of audience, generated text tends to drift into recognisable AI patterns. Watch for:

- Inflated vocabulary ("leverage", "utilize", "robust", "cutting-edge", "delve")
- Hedging phrases ("perhaps", "might be worth considering")
- Symmetrical bullet structures (every bullet exactly the same shape)
- Unearned confidence (stating opinions as facts)
- Missing specificity (no real names, numbers, or quotes)
- Over-explanation (re-stating what the code already shows)

Fix by writing the way *you* actually write — contractions, varied sentence length, occasional fragments, specific details only a human in context would know.
