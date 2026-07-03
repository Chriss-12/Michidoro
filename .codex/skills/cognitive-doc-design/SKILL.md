---
name: cognitive-doc-design
description: Use when creating or editing documentation that must be easy to scan, review, understand, retain, or use for onboarding, architecture, workflow, SDD, README, PR, or client-facing docs.
---

# Cognitive Doc Design

## Purpose

Reduce cognitive load in project documentation so future work is faster, safer, and easier to review.

## When to use

Use this skill when writing or improving:

- SDD, requirements, workflow, architecture, or technical docs.
- Client-facing manuals and delivery docs.
- README-style onboarding or handoff docs.
- Review-facing summaries, PR descriptions, or decision records.

## Triggers

- documentation, docs, manual, guide, README, onboarding, workflow, SDD, architecture docs.
- "make it clearer", "organize", "summarize", "explain", "for review", "for client".
- Any document that feels long, dense, repetitive, or hard to scan.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- Relevant `docs/internal/**` or `docs/client/**` file.
- `docs/internal/tracking/CHECKLISTS.md` when documentation affects progress tracking.

## Rules

- Lead with the answer: put the decision, action, or outcome first.
- Use progressive disclosure: quick path first, details after.
- Chunk related ideas into short sections.
- Prefer tables, checklists, templates, and examples over dense prose.
- Make review intent explicit: what changed, what is out of scope, and how to verify.
- Write `docs/client/**` as UTF-8 and preserve real Spanish accents/tildes when Spanish is used.
- Do not put internal Codex orchestration details in `docs/client/**`.
- Keep docs concise; remove duplication instead of adding more text.

## Preferred patterns

- Start with a one-paragraph summary.
- Add a `Quick path` section for the happy path.
- Use tables for decisions and ownership.
- Use checklists only for verifiable actions.
- End with the next step or related document.

## Checklist update rules

- Mark `[x]` only when verified in the current task.
- Leave partial documentation or partial implementation as `[ ]` with a note.
- Update traceability only when a requirement status or evidence changes.

## Output/checklist

- State what documentation was improved.
- List files changed.
- Mention how cognitive load was reduced.
- Report validation performed or intentionally skipped.
