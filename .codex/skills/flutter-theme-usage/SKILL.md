---
name: flutter-theme-usage
description: Use when modifying Flutter UI colors, selected states, backgrounds, text colors, typography, theme values, context.palette usage, or replacing hardcoded colors.
---

# Flutter Theme Usage

## Purpose

Guide repeatable work for modifying Flutter UI colors, selected states, backgrounds, text colors, typography, theme values, context.palette usage, or replacing hardcoded colors in `pomodoro_app_v1`.

## When to use

Use this skill when the task mentions or affects modifying Flutter UI colors, selected states, backgrounds, text colors, typography, theme values, context.palette usage, or replacing hardcoded colors.

## Triggers

- Direct mention of `flutter-theme-usage`.
- Requests involving modifying Flutter UI colors, selected states, backgrounds, text colors, typography, theme values, context.palette usage, or replacing hardcoded colors.
- Review findings related to this area.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- `lib/app/theme/app_theme.dart`
- `lib/app/theme/app_typography.dart`
- `docs/internal/technical/UI_GUIDELINES.md`

## Rules

- Prefer `context.palette` or `Theme.of(context)`.
- Avoid hardcoded colors when palette values exist.
- Use `palette.textSecondary` for inactive/secondary text.
- Use `palette.primary` or a darker brand tone for selected states.
- Use `palette.primaryMuted` or equivalent for soft selected backgrounds.
- Update `docs/internal/technical/UI_GUIDELINES.md` if a new visual rule is introduced.

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
