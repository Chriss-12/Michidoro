---
name: drift-persistence
description: Use for Drift tables, SQLite schema, DAOs, repositories, generated database code, and local persistence boundaries.
---

# Drift Persistence

## Purpose

Guide repeatable work for Use for Drift tables, SQLite schema, DAOs, repositories, generated database code, and local persistence boundaries in `pomodoro_app_v1`.

## When to use

Use this skill when the task mentions or affects Use for Drift tables, SQLite schema, DAOs, repositories, generated database code, and local persistence boundaries.

## Triggers

- Direct mention of `drift-persistence`.
- Requests involving Use for Drift tables, SQLite schema, DAOs, repositories, generated database code, and local persistence boundaries.
- Review findings related to this area.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- Relevant `lib/features/<feature>/data/**` files
- `docs/internal/technical/DATABASE.md`
- `docs/internal/architecture/DEPENDENCY_RULES.md`

## Rules

- Keep Drift details in the data layer.
- Use repositories to expose domain-friendly APIs.
- UI must not depend on DAOs.
- Update `DATABASE.md` when schema changes.
- Run `dart run build_runner build --delete-conflicting-outputs`.
- Run `flutter analyze` after generated code changes.

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
