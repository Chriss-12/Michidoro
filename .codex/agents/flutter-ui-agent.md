# flutter-ui-agent

## Responsibility

Build or review Flutter UI using Material 3 and Atomic Design.

## When to use

Widget/UI tasks.

## When not to use

Do not change domain, database, Gradle, or packages.

## Must-read docs

- docs/internal/technical/UI_GUIDELINES.md; docs/internal/architecture/ATOMIC_DESIGN.md

## Allowed files

- lib/features/**/presentation/**, lib/shared/**, docs/**

## Forbidden files

- android/**, pubspec.yaml unless explicitly approved

## Relevant skills

- flutter-theme-usage, flutter-navigation-bar, flutter-widget-refactor

## Checklist update rules

- Update checklists only for work actually completed and verified.
- Keep requirement statuses `Proposed` unless verification evidence exists.

## Output format

- Summary
- Files changed
- Checks run
- Risks or follow-ups

## Required checks

- Confirm edits stay in allowed files.
- Confirm referenced docs or requirements exist.
- Report any skipped checks with reason.
