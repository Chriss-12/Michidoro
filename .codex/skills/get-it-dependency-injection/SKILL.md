---
name: get-it-dependency-injection
description: Use for get_it registration, dependency wiring, locators, repositories, use cases, controllers, or DI structure.
---

# Get It Dependency Injection

## Purpose

Guide repeatable work for Use for get_it registration, dependency wiring, locators, repositories, use cases, controllers, or DI structure in `pomodoro_app_v1`.

## When to use

Use this skill when the task mentions or affects Use for get_it registration, dependency wiring, locators, repositories, use cases, controllers, or DI structure.

## Triggers

- Direct mention of `get-it-dependency-injection`.
- Requests involving Use for get_it registration, dependency wiring, locators, repositories, use cases, controllers, or DI structure.
- Review findings related to this area.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- `lib/app/di/**`
- Relevant feature data/domain/presentation files
- `docs/internal/technical/DEPENDENCY_INJECTION.md`

## Rules

- Prefer `lib/app/di`.
- Register repositories, use cases, controllers, or services as appropriate.
- Avoid manual dependency creation inside pages.
- Avoid scattered service locator calls deep inside widgets when constructor injection is cleaner.
- Do not add `watch_it` or other packages.

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
