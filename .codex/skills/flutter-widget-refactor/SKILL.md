---
name: flutter-widget-refactor
description: Use when splitting big widgets, improving UI structure, creating reusable widgets, or applying Atomic Design to Flutter pages/components.
---

# Flutter Widget Refactor

## Purpose

Guide repeatable work for splitting big widgets, improving UI structure, creating reusable widgets, or applying Atomic Design to Flutter pages/components in `pomodoro_app_v1`.

## When to use

Use this skill when the task mentions or affects splitting big widgets, improving UI structure, creating reusable widgets, or applying Atomic Design to Flutter pages/components.

## Triggers

- Direct mention of `flutter-widget-refactor`.
- Requests involving splitting big widgets, improving UI structure, creating reusable widgets, or applying Atomic Design to Flutter pages/components.
- Review findings related to this area.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- Relevant `lib/features/<feature>/presentation/**` files
- `lib/shared/` widgets
- `docs/internal/architecture/ATOMIC_DESIGN.md`

## Rules

- Preserve behavior.
- Keep widgets small.
- Follow Atomic Design only when it helps.
- Do not over-abstract too early.
- Avoid business logic inside widgets.

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
