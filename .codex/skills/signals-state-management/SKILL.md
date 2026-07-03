---
name: signals-state-management
description: Use for signals_flutter state, signal, computed, effect, controllers, view models, and reactive Flutter UI state.
---

# Signals State Management

## Purpose

Guide repeatable work for Use for signals_flutter state, signal, computed, effect, controllers, view models, and reactive Flutter UI state in `pomodoro_app_v1`.

## When to use

Use this skill when the task mentions or affects Use for signals_flutter state, signal, computed, effect, controllers, view models, and reactive Flutter UI state.

## Triggers

- Direct mention of `signals-state-management`.
- Requests involving Use for signals_flutter state, signal, computed, effect, controllers, view models, and reactive Flutter UI state.
- Review findings related to this area.

## Required files

- `AGENTS.md`
- `.codex/ORCHESTRATOR.md`
- `lib/app/state/**`
- Relevant `lib/features/<feature>/presentation/controllers/**`
- `docs/internal/technical/STATE_MANAGEMENT.md`

## Rules

- Do not create signals inside build methods.
- Prefer controllers/view models inside `presentation/controllers`.
- Use `computed` for derived state.
- Use `effect` carefully.
- Keep business rules out of widgets.
- Do not introduce Provider, Bloc, or Riverpod.

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
