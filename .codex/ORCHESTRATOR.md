# Codex Orchestrator

Lightweight router for choosing how Codex should work in `pomodoro_app_v1`. This file routes work; detailed standards live in `docs/internal/` and task skills live in `.codex/skills/`.

## Routing modes

### 1. Direct Skill Mode

Use for small, clear, low-risk tasks:

- color changes
- spacing changes
- `NavigationBar` styling
- checklist updates
- docs formatting
- quality checks

Flow:

`AGENTS.md -> ORCHESTRATOR.md -> selected skills -> files`

### 2. Agent + Skills Mode

Use for medium or large tasks:

- new feature planning
- feature implementation across layers
- architecture changes
- persistence/database work
- routing changes
- state architecture
- refactors
- bug investigations

Flow:

`AGENTS.md -> ORCHESTRATOR.md -> selected agent profile -> selected skills -> files`

## Routing table

| Task type | Mode | Triggers | Agent profile | Skills |
|---|---|---|---|---|
| UI/design | Direct Skill Mode | color, palette, spacing, typography, selected state, visual | None | `flutter-theme-usage` |
| Bottom navigation | Direct Skill Mode | `NavigationBar`, `NavigationDestination`, `selectedIndex`, `bottomNavigationBar` | None | `flutter-navigation-bar`, `flutter-theme-usage` |
| Widget/page change | Agent + Skills Mode if medium; Direct Skill Mode if tiny | widget, page, screen, `AppShell`, component | `.codex/agents/flutter-ui-agent.md` when needed | `flutter-widget-refactor`, `flutter-theme-usage` |
| SDD planning | Agent + Skills Mode | SDD, requirement, milestone, acceptance criteria, plan feature | `.codex/agents/documentation-agent.md` | `sdd-feature-planning`, `sdd-checklist-tracking`, `cognitive-doc-design` |
| Checklist/progress update | Direct Skill Mode | checklist, tick, status, traceability, requirement status | None | `sdd-checklist-tracking` |
| State management | Agent + Skills Mode | signal, computed, effect, controller, reactive | `.codex/agents/state-agent.md` | `signals-state-management` |
| Dependency injection | Agent + Skills Mode | `get_it`, locator, register, dependency, DI | `.codex/agents/architecture-agent.md` | `get-it-dependency-injection` |
| Routing | Agent + Skills Mode | `go_router`, route, `ShellRoute`, redirect, navigation | `.codex/agents/routing-agent.md` | `go-router-navigation` |
| Persistence | Agent + Skills Mode | drift, SQLite, DAO, table, repository, schema | `.codex/agents/persistence-agent.md` | `drift-persistence`, `get-it-dependency-injection` |
| Quality/review | Direct Skill Mode or Agent + Skills Mode depending scope | analyze, test, lint, review, bug | `.codex/agents/review-agent.md` when broad | `flutter-quality-check` |
| Client docs | Direct Skill Mode | manual, client docs, entrega, instalacion, guia rapida | None or `.codex/agents/documentation-agent.md` if broad | `documentation-update`, `cognitive-doc-design` |

## Selection rule

Codex may choose the mode, agent profile, and skills automatically based on task triggers.

Before editing code, Codex must report:

- selected mode
- selected agent profile or `None`
- selected skills
- reason for selection
- files to inspect
- files likely to modify
- checks to run

If the task is small and clear, prefer Direct Skill Mode. If the task involves architecture, multiple layers, database, state design, routing design, or broad review, prefer Agent + Skills Mode. If uncertain, choose SDD Planning Only or ask for confirmation before editing code.

## Safety boundary

Never route work that violates `AGENTS.md`. Docs-only tasks stay in `AGENTS.md`, `docs/**`, and `.codex/**`. App code changes require reading the relevant requirement, architecture, technical, agent, and skill docs first.
