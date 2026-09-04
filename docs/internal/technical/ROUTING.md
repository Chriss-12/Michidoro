# Routing

Use `go_router` as the routing boundary. Keep route definitions discoverable and avoid navigation decisions inside domain code.

## Startup and first-run onboarding

- Cold start authenticates first and then shows one `SplashPage` loading pass
  while application dependencies and local data initialize.
- After that pass, the router starts directly at `/onboarding` when the loaded
  local onboarding version is incomplete, or at `/home` otherwise. It must not
  replay the percentage animation.
- `/` remains the explicit splash route for compatibility, but is not the
  router's automatic startup location after bootstrap.
- `/onboarding` remains outside `ShellRoute`; completing it navigates to Home.

## Settings utility routes

- `/settings/directory-picker` opens the in-app local folder selector used as a
  fallback when Android/system folder selection is unavailable.
- `/settings/local-image-picker` opens the in-app local image selector used as a
  fallback when Android gallery or system file selection is unavailable.

## Routine editor

- `/tasks` remains the only bottom-navigation destination for both Tasks and
  Routines through an in-page `Tareas | Rutinas` selector.
- Creating a routine from `/tasks` opens the four-step editor in a centered,
  keyboard-safe modal over the current page. The blurred barrier preserves the
  user's location, and a dirty draft requires explicit discard confirmation.
- `/routine-editor` is outside `ShellRoute`, uses an optional `id` query
  parameter for edits, and remains the full-screen route for existing routines
  and direct links without adding another navigation destination.

## Unified planning

- `/goals` is the only bottom-navigation destination for planning. It composes
  the calendar, goal-period filtering, and the selected-day agenda for goals,
  tasks, routine occurrences, and events.
- `/goals?goalId=<id>&taskId=<id>` is the contextual notification entry. The
  planning page forces the universal goal filter, expands the matching goal,
  scrolls it into view, and highlights the task when it still exists.
- Home does not expose a separate Planning route or card.
- `/calendar` remains as a compatibility route and redirects to `/goals` so
  existing internal links and local notifications keep working.

## Persistent main navigation

- The five bottom destinations use an indexed stateful shell. A branch is kept
  alive after its first visit, preserving local selections, drafts, and scroll
  position while switching destinations.
- Selecting another destination changes branches without reloading application
  repositories. Shared Signals continue to propagate local mutations.
- Home, Tasks, and Goals expose pull-to-refresh through one deduplicated
  application-data refresh operation. The same operation is reused after
  synchronized changes are applied.
- After startup authentication, Tasks, Routines, and Quick Notes warm in
  parallel during the single bootstrap pass. Only the Tasks branch is eagerly
  built when the main shell opens, so its first selection avoids route-build
  latency without preloading every destination.
- Contextual goal/task URLs continue to target the Goals branch, while utility
  pages remain root-level routes and keep their existing bottom navigation.

## Required checks

- [ ] Relevant requirement or decision is linked.
- [ ] Implementation remains offline-first.
- [ ] Verification evidence is recorded when status changes.
