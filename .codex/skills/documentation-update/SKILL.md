---
name: documentation-update
description: Use when updating docs, SDD, requirements, ADRs, workflow docs, client docs, AGENTS.md, ORCHESTRATOR.md, agent profiles, or project skills.
---

# Documentation Update

## Purpose

Guide repeatable work for updating docs, SDD, requirements, ADRs, workflow docs, client docs, AGENTS.md, ORCHESTRATOR.md, agent profiles, or project skills in `pomodoro_app_v1`.

## When to use

Use this skill when the task mentions or affects updating docs, SDD, requirements, ADRs, workflow docs, client docs, AGENTS.md, ORCHESTRATOR.md, agent profiles, or project skills.

## Triggers

- Direct mention of `documentation-update`.
- Requests involving updating docs, SDD, requirements, ADRs, workflow docs, client docs, AGENTS.md, ORCHESTRATOR.md, agent profiles, or project skills.
- Review findings related to this area.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- `AGENTS.md`
- `docs/internal/**`
- `docs/client/**`
- `.codex/**`

## Rules

- Keep docs concise and actionable.
- Client docs must be written as UTF-8 and may use Spanish with real accents/tildes.
- Client docs must not include internal Codex instructions.
- Internal docs may reference `AGENTS.md`, `ORCHESTRATOR.md`, agents, and skills.
- Update only relevant docs.

## Preferred patterns

- Keep changes small and reviewable.
- Preserve current app behavior unless the task explicitly changes it.
- Keep feature-first boundaries visible.
- Prefer project conventions over new abstractions.

## Client documentation language rules

For files under `docs/client/`:

- Use formal, clear and client-facing Spanish.
- Use correct spelling, accents and tildes.
- Avoid technical jargon unless the document is `MANUAL_TECNICO.md`.
- Do not expose internal Codex workflow, agents, skills or prompts.

## Checklist update rules

- Mark `[x]` only for actions completed and verified in the current task.
- Leave partial work as `[ ]` with a note.
- Update traceability when a requirement status changes.

## Output/checklist

- Selected mode, agent profile, and skills.
- Files inspected and files changed.
- Checks run or skipped with reason.
- Risks, follow-ups, and documentation updates.
