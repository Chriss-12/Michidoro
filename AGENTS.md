# AGENTS.md - pomodoro_app_v1

## Project identity

`pomodoro_app_v1` is an offline-first Flutter Pomodoro productivity app focused on daily tasks, goals, Pomodoro sessions, calendar planning, local settings, future reports, and future PDF export.

## Current stack

- Flutter / Dart SDK `^3.8.1`
- Clean Architecture, Feature First, Atomic Design, Material 3
- `go_router` for navigation
- `get_it` for dependency injection
- `signals_flutter` for state management
- `drift` + SQLite for local persistence when needed
- `flex_color_scheme`, `google_fonts`, `flutter_animate`, `lottie`, `toastification`, `responsive_framework`
- `very_good_analysis` for linting

## Product constraints

- Offline-first by default.
- Do not use Firebase, Supabase, backend services, or internet-dependent features.
- Do not use Provider, Bloc, or Riverpod.
- Do not add packages unless explicitly requested.
- Do not modify Android Gradle unless explicitly requested.

## Mandatory workflow before modifying code

1. Read `.codex/ORCHESTRATOR.md`.
2. Read `docs/internal/SDD.md`.
3. Read the relevant requirement file under `docs/internal/requirements/`.
4. Read `docs/internal/tracking/CHECKLISTS.md` when the task touches a milestone, requirement, acceptance criteria, or progress tracking.
5. Select the correct mode:
   - Direct Skill Mode
   - Agent + Skills Mode
   - SDD Planning Only
   - SDD Approval
   - Review and Verification
6. Select the relevant agent profile if needed.
7. Select only the relevant skills.
8. Inspect existing files before editing.
9. Before coding, state: selected mode, selected agent profile or `None`, selected skills, files to inspect, files likely to modify, and checks to run.
10. Propose a small plan.
11. Implement the smallest safe change.
12. Run required checks when possible.
13. Update SDD, requirements, traceability, and documentation only for verified progress.

## Safety rules

- Do not delete files unless explicitly requested.
- Do not overwrite files without reading them first.
- Do not modify unrelated files.
- Do not move working files without explaining why.
- Do not modify Android Gradle unless explicitly requested.
- Do not install new packages unless explicitly requested.
- Do not implement requirements with `Status: Proposed`.
- Do not mark checklist items as `[x]` unless verified.
- Do not move requirements to `Verified` unless required checks passed.
- Keep the app compiling after each implementation change.

## SDD lifecycle

Requirement statuses are:

- `Proposed`: captured but not approved for implementation.
- `Approved`: accepted by the user/team and ready for implementation planning.
- `In Progress`: currently being implemented.
- `Implemented`: code/docs were changed but final verification is pending.
- `Verified`: required checks passed and traceability was updated.
- `Blocked`: cannot proceed without a decision or dependency.
- `Rejected`: explicitly not part of the product.

Non-trivial feature work must move through planning, approval, implementation, verification, and traceability updates.

## Documentation update rules

- Keep `AGENTS.md` concise; detailed rules live in docs and `.codex/` files.
- Detailed requirements live in `docs/internal/requirements/`.
- Architecture details live in `docs/internal/architecture/`.
- Technical rules live in `docs/internal/technical/`.
- Progress tracking lives in `docs/internal/tracking/`.
- Codex workflow lives in `docs/internal/workflow/`.
- Client-facing docs live in `docs/client/`, must be written as UTF-8, may use Spanish with real accents/tildes, and must not include internal Codex orchestration details.
- Update `docs/internal/tracking/TRACEABILITY_MATRIX.md` whenever requirement status changes.

## Checks

- Docs-only: verify requested files exist and markdown/skill frontmatter is valid.
- Flutter UI/state/routing changes: run `flutter analyze`; run `flutter test` when behavior or tests are affected.
- Drift changes: run `dart run build_runner build --delete-conflicting-outputs`, then `flutter analyze`.
- Formatting changes: run `dart format .` or the smallest relevant format scope.

## Client documentation rules

When updating `docs/client/`, use clear Spanish with correct spelling, punctuation and required tildes. Do not include internal Codex instructions, agents, skills or prompts in client-facing documentation.

## References

- `.codex/ORCHESTRATOR.md`
- `docs/internal/SDD.md`
- `docs/internal/requirements/`
- `docs/internal/tracking/CHECKLISTS.md`
- `docs/internal/tracking/TRACEABILITY_MATRIX.md`
- `docs/internal/workflow/SDD_LIFECYCLE.md`
- `.codex/agents/`
- `.codex/skills/`
