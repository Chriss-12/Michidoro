# Architecture requirements

Statuses remain `Proposed` until user approval and verification evidence exist.

### REQ-ARCH-001 - Clean Architecture

Status: Proposed

Objective:
Preserve presentation, domain, and data boundaries.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-ARCH-002 - Feature First

Status: Proposed

Objective:
Keep feature code organized under lib/features/<feature>/ when implemented.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-ARCH-003 - Dependency direction

Status: Proposed

Objective:
Dependencies must point inward toward domain rules, not outward toward frameworks.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-ARCH-004 - Presentation/domain/data boundaries

Status: Proposed

Objective:
Do not mix UI widgets, business rules, and persistence details in the same layer.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-ARCH-005 - App layer

Status: Proposed

Objective:
Use lib/app for routing, theme, global state, and app-level composition.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-ARCH-006 - Shared layer

Status: Proposed

Objective:
Use lib/shared for reusable UI building blocks that are not feature-specific.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.

### REQ-ARCH-007 - No business logic inside large widgets

Status: Proposed

Objective:
Move non-trivial behavior into controllers, use cases, or domain services as appropriate.

Checklist:
- [ ] Requirement approved
- [ ] UI planned or implemented if applicable
- [ ] State planned or implemented if applicable
- [ ] Domain planned or implemented if applicable
- [ ] Data/persistence planned or implemented if applicable
- [ ] Checks passed
- [ ] Documentation updated
- [ ] Traceability updated

Acceptance criteria:
- [ ] The requirement has a clear user or architecture outcome.
- [ ] The implementation approach respects offline-first behavior and project architecture.
- [ ] Required checks are documented before moving to Verified.

Notes:
- Keep incomplete work as [ ].
- Only mark [x] after verification.
