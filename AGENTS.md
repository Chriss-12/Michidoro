# AGENTS.md — pomodoro_app_v1

## Project

This is a Flutter app called `pomodoro_app_v1`.

The app is an offline Pomodoro productivity app focused on:

- daily tasks
- goals
- Pomodoro sessions
- calendar planning
- local settings
- reports later
- PDF export later

The app must work offline first.

## Architecture

Use:

- Clean Architecture
- Feature First
- Atomic Design
- Material 3

Do not use:

- Firebase
- Supabase
- Backend
- Internet-dependent features
- Provider
- Bloc
- Riverpod

Use:

- `go_router` for navigation
- `get_it` for dependency injection
- `signals_flutter` for state management
- `drift` + SQLite for local database when needed
- `flex_color_scheme` for themes
- `google_fonts` for typography
- `flutter_animate` and `lottie` for animations
- `toastification` for toasts
- `responsive_framework` for responsive UI
- `very_good_analysis` for linting

## Safety Rules

Before modifying code:

1. Read the current folder structure.
2. Read existing files before editing them.
3. Do not delete files unless explicitly requested.
4. Do not overwrite existing files without checking them first.
5. Do not move working files without explaining why.
6. Do not modify Android Gradle unless explicitly requested.
7. Do not install new packages unless explicitly requested.
8. Keep the app compiling after each change.

## Folder Strategy

Use feature-first folders:

```txt
lib/features/<feature>/
  data/
  domain/
  presentation/