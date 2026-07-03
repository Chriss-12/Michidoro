---
name: flutter-navigation-bar
description: Use when editing NavigationBar, NavigationDestination, bottomNavigationBar, AppShell, selected icons, selected labels, or selected navigation styling.
---

# Flutter Navigation Bar

## Purpose

Guide repeatable work for editing NavigationBar, NavigationDestination, bottomNavigationBar, AppShell, selected icons, selected labels, or selected navigation styling in `pomodoro_app_v1`.

## When to use

Use this skill when the task mentions or affects editing NavigationBar, NavigationDestination, bottomNavigationBar, AppShell, selected icons, selected labels, or selected navigation styling.

## Triggers

- Direct mention of `flutter-navigation-bar`.
- Requests involving editing NavigationBar, NavigationDestination, bottomNavigationBar, AppShell, selected icons, selected labels, or selected navigation styling.
- Review findings related to this area.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- `lib/shared/templates/app_shell.dart`
- `lib/app/router/app_router.dart`
- `docs/internal/technical/ROUTING.md`
- `docs/internal/technical/UI_GUIDELINES.md`

## Rules

- Do not change route paths unless requested.
- Prefer `NavigationBarTheme`.
- Prefer `WidgetStateProperty.resolveWith` for selected/unselected states.
- Use `context.palette`.
- Keep all destinations visually consistent.
- Run `flutter analyze`.

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
