# Settings requirements

Statuses remain `Proposed` until user approval and verification evidence exist.

### REQ-SET-001 - Local settings

Status: Verified

Objective:
Keep user settings local to the device.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Timer settings are saved locally on the device without backend services.
- [x] Settings are loaded before the app starts so Pomodoro uses the persisted focus duration.
- [x] Required checks passed before moving to Verified.

Notes:
- M6 verified: timer preferences persist through a local JSON settings repository in the app documents directory.
- Verification evidence: `dart format lib test`, `flutter analyze`, targeted settings/Pomodoro tests, and full `flutter test` passed.

### REQ-SET-002 - Timer preferences

Status: Verified

Objective:
Allow timer duration and behavior preferences.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] Focus, short break, long break, long break frequency, completion sound, completion vibration, and auto-start preferences are represented in timer settings.
- [x] Timer preference values are clamped to supported ranges before use or persistence.
- [x] Pomodoro receives the persisted focus duration before the user starts a session.

Notes:
- M6 verified: existing settings controls now persist timer preferences locally and restore them at app startup.
- Theme and notification preference persistence remain out of scope for this slice.

### REQ-SET-003 - Theme preferences later

Status: Proposed

Objective:
Plan theme preference persistence.

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

### REQ-SET-004 - Notification preferences later

Status: Proposed

Objective:
Plan local notification preference support.

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

### REQ-SET-005 - Reports export folder

Status: Verified

Objective:
Allow the user to choose where report exports are saved locally.

Checklist:
- [x] Requirement approved
- [x] UI planned or implemented if applicable
- [x] State planned or implemented if applicable
- [x] Domain planned or implemented if applicable
- [x] Data/persistence planned or implemented if applicable
- [x] Checks passed
- [x] Documentation updated
- [x] Traceability updated

Acceptance criteria:
- [x] PDF reports are saved to the configured reports folder when one is set.
- [x] PDF reports default to the platform Downloads folder when possible.
- [x] Settings exposes a local reports folder path control.
- [x] The reports folder preference is persisted locally with the existing settings file.

Verification:
- 2026-07-11: Settings added a Reports card with an editable folder path and a `Usar Descargas` action.
- 2026-07-11: `AppSettingsController` saves PDF/TXT reports to the configured folder or the platform Downloads/default folder.
- 2026-07-11: `dart format lib test`, `flutter analyze`, and focused Settings/widget tests passed with 10 tests.
