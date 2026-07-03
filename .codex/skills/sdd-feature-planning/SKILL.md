---
name: sdd-feature-planning
description: Use before implementing non-trivial features, creating requirements, milestones, acceptance criteria, or SDD planning artifacts.
---

# Sdd Feature Planning

## Purpose

Guide repeatable work for Use before implementing non-trivial features, creating requirements, milestones, acceptance criteria, or SDD planning artifacts in `pomodoro_app_v1`.

## When to use

Use this skill when the task mentions or affects Use before implementing non-trivial features, creating requirements, milestones, acceptance criteria, or SDD planning artifacts.

## Triggers

- Direct mention of `sdd-feature-planning`.
- Requests involving Use before implementing non-trivial features, creating requirements, milestones, acceptance criteria, or SDD planning artifacts.
- Review findings related to this area.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- `docs/internal/SDD.md`
- `docs/internal/requirements/`
- `docs/internal/tracking/MILESTONES.md`
- `docs/internal/tracking/TRACEABILITY_MATRIX.md`

## Rules

- Create requirements with `Status: Proposed`.
- Add objective, checklist, and acceptance criteria.
- Update the relevant requirement file.
- Update `MILESTONES.md` when needed.
- Update `TRACEABILITY_MATRIX.md`.
- Do not implement code in planning mode.

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
