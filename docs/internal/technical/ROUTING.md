# Routing

Use `go_router` as the routing boundary. Keep route definitions discoverable and avoid navigation decisions inside domain code.

## Settings utility routes

- `/settings/directory-picker` opens the in-app local folder selector used as a
  fallback when Android/system folder selection is unavailable.
- `/settings/local-image-picker` opens the in-app local image selector used as a
  fallback when Android gallery or system file selection is unavailable.

## Required checks

- [ ] Relevant requirement or decision is linked.
- [ ] Implementation remains offline-first.
- [ ] Verification evidence is recorded when status changes.
