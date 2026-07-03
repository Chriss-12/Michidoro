---
name: go-router-navigation
description: Use for go_router route definitions, ShellRoute, redirects, route constants, and navigation behavior.
---

# Go Router Navigation

## Purpose

Guide repeatable work for Use for go_router route definitions, ShellRoute, redirects, route constants, and navigation behavior in `pomodoro_app_v1`.

## When to use

Use this skill when the task mentions or affects Use for go_router route definitions, ShellRoute, redirects, route constants, and navigation behavior.

## Triggers

- Direct mention of `go-router-navigation`.
- Requests involving Use for go_router route definitions, ShellRoute, redirects, route constants, and navigation behavior.
- Review findings related to this area.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- `lib/app/router/app_router.dart`
- Page files with `routePath` constants
- `docs/internal/technical/ROUTING.md`

## Rules

- `go_router` is the only routing solution.
- Do not change route paths without updating `ROUTING.md`.
- Preserve bottom navigation/shell behavior.
- Keep route constants consistent.

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
