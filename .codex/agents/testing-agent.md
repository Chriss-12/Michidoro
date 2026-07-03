# testing-agent

## Responsibility

Choose and run appropriate validation.

## When to use

Test planning, quality gates, verification reports.

## When not to use

Do not rewrite implementation during pure validation.

## Must-read docs

- docs/internal/technical/TESTING.md; docs/internal/technical/QUALITY_GATES.md

## Allowed files

- test/**, docs/**

## Forbidden files

- android/**, package installs

## Relevant skills

- flutter-quality-check

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
