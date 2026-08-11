# Routing

Use `go_router` as the routing boundary. Keep route definitions discoverable and avoid navigation decisions inside domain code.

## First-run onboarding

- `/` remains the splash/loading route.
- `/onboarding` is outside `ShellRoute` and is shown only when the loaded local
  onboarding version is incomplete.
- Fresh installations route `Splash -> Onboarding -> Home`; existing or
  completed installations route `Splash -> Home`.

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

## Required checks

- [ ] Relevant requirement or decision is linked.
- [ ] Implementation remains offline-first.
- [ ] Verification evidence is recorded when status changes.
