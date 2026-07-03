---
name: sdd-checklist-tracking
description: Use when a task touches milestones, requirements, acceptance criteria, Definition of Done, status, traceability, or progress tracking.
---

# Sdd Checklist Tracking

## Purpose

Guide repeatable work for a task touches milestones, requirements, acceptance criteria, Definition of Done, status, traceability, or progress tracking in `pomodoro_app_v1`.

## When to use

Use this skill when the task mentions or affects a task touches milestones, requirements, acceptance criteria, Definition of Done, status, traceability, or progress tracking.

## Triggers

- Direct mention of `sdd-checklist-tracking`.
- Requests involving a task touches milestones, requirements, acceptance criteria, Definition of Done, status, traceability, or progress tracking.
- Review findings related to this area.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- `docs/internal/tracking/CHECKLISTS.md`
- `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- `docs/internal/tracking/MILESTONES.md`
- Relevant `docs/internal/requirements/REQ-*.md`

## Rules

- Never mark `- [x]` unless verified.
- If implementation is partial, leave item as `- [ ]` and add a note.
- Use requirement IDs consistently.
- Update `TRACEABILITY_MATRIX.md` when requirement status changes.
- Update `CHECKLISTS.md` only when a reusable checklist changes.
- Update `SDD.md` when master SDD links or lifecycle rules change.
- Update requirement files when requirement progress changes.
- Update `MILESTONES.md` when feature or milestone status changes.

## Preferred patterns

- Keep changes small and reviewable.
- Preserve current app behavior unless the task explicitly changes it.
- Keep feature-first boundaries visible.
- Prefer project conventions over new abstractions.

## Checklist update rules

- Mark `[x]` only for actions completed and verified in the current task.
- Leave partial work as `[ ]` with a note.
- Update traceability when a requirement status changes.

## Output/checklist

- Selected mode, agent profile, and skills.
- Files inspected and files changed.
- Checks run or skipped with reason.
- Risks, follow-ups, and documentation updates.
