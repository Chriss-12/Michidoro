---
name: flutter-quality-check
description: Use for flutter analyze, flutter test, linting, formatting, review, verification, and quality gates.
---

# Flutter Quality Check

## Purpose

Guide repeatable work for Use for flutter analyze, flutter test, linting, formatting, review, verification, and quality gates in `pomodoro_app_v1`.

## When to use

Use this skill when the task mentions or affects Use for flutter analyze, flutter test, linting, formatting, review, verification, and quality gates.

## Triggers

- Direct mention of `flutter-quality-check`.
- Requests involving Use for flutter analyze, flutter test, linting, formatting, review, verification, and quality gates.
- Review findings related to this area.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- `analysis_options.yaml`
- `docs/internal/technical/TESTING.md`
- `docs/internal/technical/QUALITY_GATES.md`

## Rules

- Prefer `flutter analyze`.
- Run `flutter test` when tests are affected.
- Use `dart format .` if formatting is needed.
- Respect `very_good_analysis`.
- Do not mark `Verified` unless checks pass or inability to run checks is clearly documented.

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
