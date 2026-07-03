# Reusable checklists

Only mark an item as `[x]` when it has been verified in code, docs, or checks. If implementation is partial, leave the item as `[ ]` and add a note.

## SDD planning checklist

- [ ] Problem statement documented
- [ ] Target users and situations documented
- [ ] Scope and non-goals documented
- [ ] Relevant requirement file selected
- [ ] Acceptance criteria drafted
- [ ] Traceability impact identified

## Requirement approval checklist

- [ ] Requirement ID is stable
- [ ] Objective is clear
- [ ] Acceptance criteria are testable
- [ ] Dependencies are known
- [ ] User or product owner approved implementation
- [ ] Traceability matrix updated

## Feature planning checklist

- [ ] Feature slice is small
- [ ] Architecture impact reviewed
- [ ] UI/state/domain/data responsibilities identified
- [ ] Required checks selected
- [ ] Risks and blockers documented
- [ ] Docs to update identified

## UI implementation checklist

- [ ] Material 3 behavior preserved
- [ ] Theme/palette values used
- [ ] Responsive behavior considered
- [ ] Accessibility basics checked
- [ ] No business logic added to widgets
- [ ] UI guidelines updated if a new rule was introduced

## signals_flutter state checklist

- [ ] No signals created inside build methods
- [ ] Derived state uses computed when appropriate
- [ ] Effects are justified and scoped
- [ ] Controller/view model placement reviewed
- [ ] Widgets do not own business rules
- [ ] Provider/Bloc/Riverpod not introduced

## get_it dependency injection checklist

- [ ] Registration location reviewed
- [ ] Repositories/use cases/controllers registered as needed
- [ ] Pages do not manually build dependencies unnecessarily
- [ ] Deep widgets avoid scattered service locator calls
- [ ] DI docs updated when wiring changes

## go_router routing checklist

- [ ] go_router remains the only routing solution
- [ ] Route paths are intentionally changed or preserved
- [ ] Shell/bottom navigation behavior remains consistent
- [ ] Route constants stay consistent
- [ ] ROUTING.md updated when routes change

## Drift persistence checklist

- [ ] Tables belong in data layer
- [ ] DAOs stay out of UI
- [ ] Repositories abstract Drift from domain/presentation
- [ ] Schema docs updated
- [ ] build_runner command run when schema changes
- [ ] flutter analyze run after generated code changes

## Testing/quality checklist

- [ ] Required checks selected by task type
- [ ] flutter analyze run when code changes
- [ ] flutter test run when behavior/tests are affected
- [ ] dart format run when formatting is needed
- [ ] Failures documented before handoff
- [ ] Verified status used only after checks pass

## Documentation update checklist

- [ ] Relevant SDD/requirement docs updated
- [ ] Traceability matrix updated for status changes
- [ ] Milestones updated when progress changes
- [ ] Client docs avoid internal Codex details
- [ ] Docs remain concise and linked

## Client delivery checklist

- [ ] Manual usuario reviewed
- [ ] Manual instalacion reviewed
- [ ] Manual tecnico reviewed
- [ ] Guia rapida reviewed
- [ ] Changelog updated
- [ ] Entrega final prepared with verified behavior only
