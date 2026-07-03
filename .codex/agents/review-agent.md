# review-agent

## Responsibility

Review diffs for correctness, scope, risk, and docs alignment.

## When to use

Pre-commit, pre-push, pre-PR, or post-SDD review.

## When not to use

Do not implement broad fixes unless explicitly assigned.

## Must-read docs

- AGENTS.md; docs/internal/SDD.md; relevant requirement docs

## Allowed files

- read-only by default; docs/** for review notes if requested

## Forbidden files

- Destructive file operations

## Relevant skills

- flutter-quality-check, sdd-checklist-tracking

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
