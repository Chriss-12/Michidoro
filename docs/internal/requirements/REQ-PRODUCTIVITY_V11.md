# Productivity V11 requirements

## Summary

Productivity V11 proposes optional, user-controlled synchronization between
Android phones through a folder transported by Syncthing. Single-device mode
remains the default. Every phone keeps one private, live `michifocus.sqlite`;
the selected external folder contains consistent backups in single-device mode
and immutable exchange files plus recovery snapshots in multi-device mode.

Status: Approved on 2026-08-13. V11-M0 is In Progress; authenticated
application-level encryption with password and recovery key is required.

## Product decisions

| Decision | Contract |
|---|---|
| Default mode | Single device, with no synchronization work or extra permissions. |
| Selected location | A user-controlled data folder; never the live SQLite file. |
| Transport | Syncthing moves files; MichiFocus creates, validates, applies, and resolves them. |
| Network promise | Eventual synchronization only. Both Syncthing services must overlap online for phone-to-phone transfer. |
| Identity | Generated installation ID plus an editable, user-facing device name. |
| Conflict detection | Logical counters and causal versions, never wall-clock timestamps alone. |
| Active timer | Runs only on its origin phone in V11; completed results synchronize. |
| Source of truth | Each phone's private SQLite database after validated local application. |
| Data protection | Encrypt and authenticate every exchange payload and recovery snapshot; protect the random group data key with a password-derived key and an independent recovery key. |
| Local unlock | Optional on both storage modes and disabled by default. After one group-password enrollment per phone, Android biometrics or the registered device credential may unlock the locally protected key without revealing that credential to MichiFocus. |

## Existing data policy

| Existing table/data | V11 policy |
|---|---|
| `goals`, `tasks`, `calendar_events` | Synchronize create, field updates, status changes, and tombstones. |
| `routines`, `routine_days`, `routine_items` | Synchronize as one validated routine aggregate. |
| `pomodoro_sessions`, `task_completion_events` | Append immutable completed history; never overwrite a different event. |
| `routine_runs`, `routine_item_runs` | Synchronize immutable snapshots and state transitions with idempotent occurrence keys. |
| `reporting_metadata` | Derive a conservative local trust boundary from synchronized history; do not accept an unvalidated remote overwrite. |
| `pomodoro_runtime` | Device-local in V11; publish only a last-known informational ownership marker. |
| Settings JSON | Device-local, except the explicit sync-mode, folder-access, group, and device-identity configuration. |

## REQ-V11-001 - Storage mode and selected data folder

Status: In Progress

Objective:
Let the user choose single-device or multi-device operation while protecting
the live SQLite database from external replacement and Android document-tree
limitations.

Checklist:
- [x] Requirement approved by the user on 2026-08-13.
- [x] Single-device mode remains the default for new and existing installs.
- [x] A selected data folder can be granted, changed, tested, and disconnected.
- [ ] Mode transitions create a verified recovery snapshot first.
- [x] Folder-access loss leaves the private database usable.

Acceptance criteria:
- [x] Single-device mode works with no selected folder and no behavior change.
- [ ] In single-device mode, the selected folder stores only consistent,
      versioned recovery snapshots.
- [ ] In multi-device mode, the selected folder stores exchange data and
      recovery snapshots, never the open `michifocus.sqlite`.
- [x] The UI explains the difference between the private live database and the
      selected data folder before enabling multi-device mode.
- [x] Revoked or unavailable folder permission produces an actionable warning
      without blocking local task, routine, calendar, report, or Focus flows.
- [ ] Returning to single-device mode retains all locally applied data and
      stops producing exchange files without deleting remote data.

## REQ-V11-002 - Automatic device and sync-group identity

Status: In Progress

Objective:
Identify installations and one shared MichiFocus group without asking the user
to create technical identifiers or folder structures manually.

Checklist:
- [x] Requirement approved by the user on 2026-08-13.
- [x] Secure random group, installation, operation, and entity ID formats are specified.
- [x] Existing local IDs receive a collision-safe compatibility strategy.
- [x] Device rename and retirement behavior is specified.

Acceptance criteria:
- [x] The first phone creates a stable group ID and installation ID automatically.
- [ ] A joining phone creates a different installation ID even when it has the
      same model or friendly name.
- [x] MichiFocus proposes a friendly device name from locally available model
      information and permits editing it.
- [x] Renaming a device never changes its installation ID or duplicates data.
- [ ] Duplicate friendly names are disambiguated in the UI.
- [ ] Reinstallation cannot silently reuse an old installation identity; the
      user must join as a new device or complete an explicit identity recovery.
- [ ] Entity and operation IDs remain unique across at least four offline phones
      without relying on synchronized clocks.

## REQ-V11-003 - Immutable causal exchange protocol

Status: In Progress

Objective:
Exchange changes through files that Syncthing can copy independently while
allowing MichiFocus to detect duplicates, causal order, concurrency, damage,
and unsupported versions.

Checklist:
- [x] Requirement approved by the user on 2026-08-13.
- [x] Envelope schema and protocol version are documented.
- [x] Logical counter and causal-version rules are documented.
- [ ] Atomic publication, validation, quarantine, and retry behavior are documented.
- [x] No mutable file is shared by two devices.

Acceptance criteria:
- [x] Every operation filename includes its owner installation ID, counter, and
      operation ID in a bounded hexadecimal form, so two devices never share one
      mutable final path and Android providers with shorter filename limits work.
- [x] Every operation includes group ID, operation ID, origin device ID,
      monotonically increasing origin counter, entity type and ID, causal parent
      version, changed fields, operation kind, protocol version, and integrity data.
- [x] Timestamps are used for display and diagnostics only, not as the sole
      conflict or winning-version rule.
- [x] Publishing uses a temporary file followed by an atomic finalization when
      supported; readers ignore temporary or unstable files.
- [x] Reprocessing the same operation is idempotent at the persistence boundary.
- [x] Missing dependencies remain pending and are retried after related files arrive.
- [ ] Invalid, truncated, foreign-group, future-protocol, or inconsistent files
      are quarantined and never partially applied.
- [x] Unsupported exchange data cannot modify the live database.
- [x] Exchange payloads and recovery snapshots contain no plaintext task,
      objective, routine, Pomodoro, mood, or calendar data.
- [x] Every encrypted artifact is authenticated so modified or incorrect-key
      data is rejected before parsing or database application.
- [x] Cryptographic suite and parameters are versioned for future migration.

## REQ-V11-004 - Transactional synchronization of application data

Status: In Progress

Objective:
Synchronize the existing 12-table model without breaking foreign keys,
materializing duplicate routine occurrences, or trusting derived data as a new
source of truth.

Checklist:
- [x] Requirement approved by the user on 2026-08-13.
- [ ] Every existing table has an explicit synchronization or local-only policy.
- [ ] Repository-level local mutations produce exchange operations atomically.
      Goal, task, calendar creation/mutation, and routine template/lifecycle
      paths are wired; immutable history and remaining calendar behavior are pending.
- [x] Remote aggregate application uses dependency-safe SQLite transactions.
- [x] Initial bootstrap and merge behavior are specified. Existing mutable goals,
      routine aggregates, tasks, and calendar events now enter the normal causal
      outbox when the user prepares changes; empty restore and replace-local
      execution remain pending.

Acceptance criteria:
- [x] Local data is committed successfully before its exchange operation is exposed.
- [x] Failed exchange publication remains visibly pending and retryable without
      rolling back valid local work.
- [x] Goals are applied before dependent tasks and routine items.
- [x] Routine templates, weekdays, and ordered items apply as one aggregate.
- [ ] Completed Pomodoro sessions and completion events are append-only and deduplicated.
- [ ] Existing unique routine occurrence and materialization rules prevent two
      phones from creating duplicate logical tasks for the same routine item/day.
- [x] A remote aggregate either commits completely or leaves the database unchanged.
- [ ] Joining with an empty database restores the current group state and then
      replays later operations.
- [x] Joining with existing local data creates a recovery snapshot and requires
      an explicit merge or replace-local decision.
- [ ] Reports derived after convergence produce the same totals on all phones,
      subject only to explicitly device-local active runtime state.

## REQ-V11-005 - Deterministic merge, deletion, and conflict resolution

Status: In Progress

Objective:
Automatically combine compatible concurrent changes and request user input only
when causally concurrent operations cannot be resolved without losing intent.

Checklist:
- [x] Requirement approved by the user on 2026-08-13.
- [x] Field-level causal merge rules are specified for mutable entities.
- [x] Tombstone lifecycle and resurrection prevention are specified.
- [x] Resolution operations converge across active devices that receive them.

Acceptance criteria:
- [x] Causally newer operations apply without prompting.
- [x] Concurrent changes to different mergeable fields combine automatically.
- [x] Concurrent different values for the same field create one visible conflict.
- [x] Concurrent modification versus deletion creates a durable conflict and
      never silently destroys the modification.
- [ ] Immutable-history ID collisions with different payloads are treated as
      integrity conflicts, not overwritten.
- [x] Conflict UI identifies this phone and the originating friendly device,
      shows both values and dates, and offers use-local, use-remote, or preserve-both
      only when the entity supports duplication safely.
- [x] Resolving a conflict creates a new causal operation; other devices consume
      that resolution instead of asking independently after receiving it.
- [x] Tombstones prevent a long-offline phone from reviving deleted data.
- [ ] Applying the same operations in different arrival orders reaches the same
      final non-conflicted state.

## REQ-V11-006 - Safe Pomodoro and routine execution semantics

Status: Approved

Objective:
Synchronize confirmed task, routine, and focus results without pretending that
file transport provides an instantaneous distributed timer lock.

Checklist:
- [x] Requirement approved by the user on 2026-08-13.
- [ ] Active runtime remains device-local in V11.
- [ ] Last-known origin-device presentation is specified.
- [ ] Simultaneous offline execution resolution is specified.

Acceptance criteria:
- [ ] Starting Focus commits local task status and publishes a last-known origin marker.
- [ ] Other phones may show that a task was last reported in progress elsewhere,
      but do not run or reconstruct its countdown automatically.
- [ ] V11 does not promise global mutual exclusion while phones are disconnected.
- [ ] Finishing Focus synchronizes the immutable session, task progress,
      completion event, mood data, and linked routine outcome as one logical result.
- [ ] Two valid sessions created offline are preserved; no focused time is silently lost.
- [ ] Contradictory task or routine state transitions become deterministic merges
      or visible conflicts without deleting immutable history.
- [ ] Timer transfer, remote stop, and cross-device live countdown are explicit non-goals.

## REQ-V11-007 - Honest sync status and guided Syncthing setup

Status: In Progress

Objective:
Make the boundary between MichiFocus processing and Syncthing transport clear,
especially when Android has stopped Syncthing or devices have not overlapped online.

Checklist:
- [x] Requirement approved by the user on 2026-08-13.
- [ ] Settings information architecture is designed for both modes.
- [ ] Status vocabulary avoids promising network completion.
- [ ] Bilingual setup and troubleshooting copy is prepared.

Acceptance criteria:
- [ ] Multi-device settings show this device, known devices, folder access,
      locally pending publications, received operations, unresolved conflicts,
      last local processing time, and last observed remote activity.
- [ ] Normal successful processing is summarized without interrupting the user.
- [ ] Conflict and device-management screens always identify friendly device origins.
- [x] The primary local action is named `Preparar y revisar cambios` or equivalent,
      not `Sincronizar ahora` unless actual transport completion can be proven.
- [x] A separate action opens Syncthing-Fork or classic Syncthing when Android
      supports it, and reports honestly when neither app is available.
- [ ] The UI states that MichiFocus cannot guarantee Syncthing is running or that
      another phone is currently reachable.
- [ ] Setup guidance covers background execution, battery optimization, Syncthing
      run conditions, same shared folder, and the need for devices to overlap online.
- [ ] Single-device users do not see device, conflict, or transport controls.

## REQ-V11-008 - Recovery, retention, and device retirement

Status: Approved

Objective:
Keep the exchange history bounded without discarding changes still needed by an
offline phone, and make recovery possible after damage or device replacement.

Checklist:
- [x] Requirement approved by the user on 2026-08-13.
- [ ] Snapshot, acknowledgement, compaction, and retention rules are specified.
- [ ] Device retirement includes a clear data-loss warning.
- [ ] Recovery never replaces an open database directly.

Acceptance criteria:
- [ ] Consistent SQLite recovery snapshots use the existing validated snapshot path.
- [ ] Snapshot import is staged, migrated, integrity checked, foreign-key checked,
      and applied only while the live database is closed.
- [ ] Each active device publishes acknowledgement progress per origin device.
- [ ] Operations and tombstones are compacted only after every active device has
      acknowledged them or the user explicitly retires a missing device.
- [ ] Retiring a device prevents it from silently rejoining with stale authority.
- [ ] Removing a device or leaving multi-device mode never deletes another phone's files automatically.
- [ ] Lost folder access, deleted exchange files, duplicate snapshots, and stale
      devices have guided recovery paths.
- [ ] The selected folder's privacy implications are explained; its data remains
      user-controlled and no MichiFocus server or account is introduced.

## REQ-V11-009 - Multi-device verification and release gate

Status: In Progress

Objective:
Prove convergence, preservation, recovery, and understandable Android behavior
before advertising multi-device synchronization as stable.

Checklist:
- [x] Requirement approved by the user on 2026-08-13.
- [ ] Two-, three-, and four-device simulations are implemented.
- [ ] Physical Android-to-Android Syncthing verification is completed.
- [ ] Security, privacy, performance, accessibility, and localization reviews pass.
- [ ] Client documentation is updated only after verified behavior exists.

Acceptance criteria:
- [ ] Automated permutation tests deliver the same operation set in different
      orders, with duplicates and delays, and prove convergence.
- [ ] Tests cover concurrent create/update/delete, disjoint-field merge,
      same-field conflict, delete/update conflict, missing parents, corrupt files,
      interrupted publication, stale devices, clock skew, reinstall, and group mismatch.
- [ ] Migration fixtures preserve every existing row when synchronization tables
      and globally safe ID behavior are introduced.
- [ ] High-volume exchange and compaction remain bounded and do not block normal UI use.
- [ ] Full Drift generation, formatting, analyzer, focused tests, and complete
      Flutter test suite pass.
- [ ] At least two physical Android phones verify onboarding, background Syncthing
      transfer, delayed/offline delivery, conflict resolution, completed Pomodoro,
      routine materialization, restart, folder permission loss, and recovery.
- [ ] No existing single-device workflow regresses when multi-device mode remains off.
- [ ] Database, architecture, UI, routing, requirements, traceability, client manual,
      quick-start guide, troubleshooting, and changelog reflect verified behavior.

## REQ-V11-010 - Local biometric or device-credential unlock

Status: In Progress

Objective:
Protect access to MichiFocus and to the locally cached synchronization key with
Android's system authentication, while requiring the synchronization-group
password only during enrollment, recovery, or secure-key rebind.

Checklist:
- [x] Requirement approved by the user on 2026-08-13.
- [x] Mandatory cold-start authentication before bootstrap approved by the user
      on 2026-08-15.
- [x] Local lock policy and lifecycle behavior are implemented and unit-tested.
- [x] The selected policy is persisted without storing any authentication secret.
- [x] Android capability, Keystore, and system-authentication bridges are implemented.
- [ ] Locked UI, unlock, recovery, and secure-key invalidation flows are implemented.
- [ ] Physical Android verification passes with biometrics and device credential.

Acceptance criteria:
- [ ] Background relocking is opt-in, is available in single- and multi-device
      modes, and is disabled by default.
- [ ] The user can choose `Never`, `Immediately`, `After 1 minute`, or
      `After 5 minutes`; enabling the feature recommends five minutes.
- [x] Every cold application start requests the Android system authentication
      configured on the phone before database migration, dependency setup, or
      application bootstrap begins.
- [x] The MichiFocus percentage/loading screen starts once only after successful
      authentication; cancellation, failure, or unavailable device security
      leaves bootstrap unstarted and exposes only the retryable lock surface.
      After bootstrap, routing starts directly at onboarding or Home instead of
      replaying the same percentage animation.
- [x] After successful authentication, the percentage/loading screen reads the
      saved local theme once before its first frame and uses the selected
      palette and light/dark appearance instead of a fixed startup color.
- [x] Background timeout uses monotonic elapsed time, begins only when the app
      is actually hidden/paused, ignores transient `inactive` states, cannot be
      extended by repeated lifecycle events, and fails closed for invalid elapsed
      state.
- [x] With local protection enabled, Android recent-app previews are protected
      from the moment the app leaves the foreground, while a Flutter privacy
      shield removes routed content before the snapshot can expose it.
- [x] Returning after the configured timeout requests Android authentication
      automatically without first revealing routed application content; returning
      inside the grace period restores the app without an unnecessary prompt.
- [ ] MichiFocus uses the Android system prompt and never receives, stores, logs,
      validates, or synchronizes the device PIN, pattern, password, or biometric.
- [ ] Supported devices permit a strong biometric or the already registered
      Android device credential as the system-controlled fallback.
- [ ] Enrolling a phone in a synchronization group requires the group password
      or recovery key once; ordinary later unlocks use local system authentication.
- [ ] The locally cached group data key is usable only through a device-bound
      Android Keystore key configured for user authentication.
- [ ] While locked, sensitive content and actions remain unavailable. Syncthing
      may transport ciphertext, but MichiFocus defers decryption and application
      of incoming changes until successful local unlock.
- [ ] Authentication cancellation or failure cannot reveal content or bypass the lock.
- [ ] If Android invalidates the protected key, MichiFocus explains the condition
      and requires the group password or recovery key to bind a new local key.
- [ ] There is no offline bypass or MichiFocus master credential.
- [ ] Unit, widget, lifecycle, native integration, restart, invalidation, and two
      physical-phone tests pass before the requirement becomes Verified.

Implementation evidence on 2026-09-07:
- Added a theme-aware privacy shield for every protected lifecycle transition and
  retained the original monotonic timeout semantics.
- Added a theme-aware blurred recent-app surface plus native Android 12+ render
  blur. Android can retain the protected preview without replacing it with a
  black frame, while task, note, routine, and objective text remains unreadable.
- A timed lock now launches the existing Android biometric/device-credential
  prompt automatically on resume. Cancellation remains fail-closed and leaves the
  manual retry action available.
- Twenty-six focused privacy/lock checks, scoped analysis, all 510 project tests,
  and the debug Android build pass. Physical recent-preview and prompt validation
  on the connected Realme remains required before this requirement is Verified.

## Non-goals for V11

- Hosting a MichiFocus backend, account system, or cloud database.
- Opening the live SQLite database from the Syncthing folder.
- Bundling, modifying, or silently configuring Syncthing.
- Guaranteeing instant delivery or availability of another phone.
- Live cross-device countdown, timer transfer, or remote timer control.
- Silently choosing a winner by device clock or friendly device name.
- Synchronizing notification permissions, vibration capability, report output
  folders, or other hardware/device-specific preferences.
- Automatically deleting another device's exchange files or backups.

## Approval record

Approved by the user on 2026-08-13:

- V11 is optional Android-to-Android functionality; single-device remains default.
- The selected folder stores backups/exchange data, never the live database.
- Completed results synchronize while active timers stay local.
- The phased roadmap and two-physical-phone release gate are approved.

Final privacy decision approved by the user on 2026-08-13, superseding the
earlier plaintext choice:

- Every exchange payload and recovery snapshot must use authenticated
  application-level encryption.
- The first phone generates a random group data-encryption key. A password-derived
  key wraps that group key; the password itself is never stored.
- An independent high-entropy recovery key wraps the same group key and must be
  shown once with an explicit save/confirm flow.
- Joining another phone requires the password or recovery key. Losing both makes
  encrypted shared-folder data unrecoverable; the local private database remains
  usable on a phone that is already unlocked.
- A locally cached group key must be protected by Android secure key storage.
- The optional local app lock must use Android's system biometric/device-credential
  prompt. The group password is entered once per enrolled phone and is not the
  credential requested on every normal app opening.
- The final algorithms, parameters, library/native boundary, rotation, and
  recovery UX require a dedicated security design and approval before coding.

## V11-M0 implementation evidence

Evidence on 2026-08-13:

- Added an isolated causal-version prototype with equal, before, after, and
  concurrent classification based only on per-device logical counters.
- Added field-candidate normalization that removes repeated operations, prunes
  causally superseded values, combines compatible disjoint-field changes, and
  retains concurrent same-field values as conflicts.
- Added scoped 128-bit identifier generation backed by `Random.secure` in
  production and deterministic injection in tests; no new package was added.
- Nine focused tests pass, including every delivery permutation for a
  four-device compatible merge, stable conflict candidates across permutations,
  repeated-operation idempotency, and 4,000 generated-ID uniqueness checks.
- The complete Flutter suite passes with 266 tests, including all existing
  database migration, import, routine, Pomodoro, settings, and UI coverage.
- Added an isolated local-unlock policy and reactive lifecycle controller. Ten
  focused tests verify disabled/default state, locked cold start, immediate and
  timed policies, exact timeout boundaries, repeated lifecycle events,
  authentication cancellation, disabling, and fail-closed monotonic behavior.
- Added a separate local-security settings file containing only the policy enum;
  malformed or unknown values safely return to disabled until a trusted setup
  flow exists. Startup loads it before `MyApp`, and the real application lifecycle
  now drives the controller.
- Added a themed lock gate that removes routed sensitive content from the mounted
  widget tree. Its unlock action was kept disabled until the following trusted
  native-authenticator slice, so no simulated bypass was introduced.
- Added a dependency-free Android authentication bridge. Android 10 and later
  use the system biometric/device-credential prompt; Android 6-9 use the system
  device-credential confirmation. Dart receives only availability and a boolean
  authentication result, with missing/failed native calls failing closed.
- All 36 focused sync tests and the complete 283-test Flutter suite pass. The
  debug APK compiles successfully with Java 17, without a new package or Gradle
  change. Physical authentication and Keystore binding remain pending.
- Added a user-facing local-security card in Settings. Protection remains off by
  default; enabling selects the recommended five-minute timeout, while immediate
  and one-minute alternatives remain available. Enabling, changing the timeout,
  and disabling each require a fresh successful Android authentication. A
  cancellation or persistence failure leaves the previous policy unchanged.
- Four focused settings tests bring sync coverage to 40 passing tests and the
  complete Flutter suite to 287 passing tests. Keystore-wrapped group-key access
  cannot be completed until the real group DEK lifecycle exists.
- Added persisted storage mode and folder configuration with single device as the
  fail-safe default. A Settings card lets either mode select, change, or disconnect
  an Android document-tree folder while explaining that the live SQLite database
  never moves there.
- Multiple-device selection requires an explanatory confirmation and is labelled
  as preparation only: no group, exchange file, or synchronization process starts.
  Switching modes preserves the folder grant, and disconnecting a folder preserves
  the selected mode and all private local data.
- Four repository, six controller, and three UI tests bring focused sync coverage
  to 53 passing tests and the complete Flutter suite to 300 passing tests. The APK
  compiles. Real folder write validation and recovery snapshots remain pending.
- The new V11 feature is clean under analysis. Repository-wide analysis reaches
  one pre-existing `depend_on_referenced_packages` info in
  `tmp/verify_physical_database_round_trip.dart`, outside V11.
- No database schema, app wiring, settings, Android files, live IDs, or user data
  changed in this slice.
- Added a typed Dart boundary and native Android Keystore bridge for a
  non-exportable, per-group AES-256 key that requires system user authentication.
  It wraps the group DEK with AES-GCM and maps authentication, invalidation,
  availability, and integrity failures without exposing the device credential.
- Six bridge tests bring focused sync coverage to 85 passing tests and the full
  Flutter suite to 332. The debug APK compiles, installs over the current
  application while preserving data, and launches on the connected Android phone.
- At that bridge-only slice, enrollment was not yet wired and physical Keystore
  wrap/unwrap, recovery confirmation, and two-phone verification remained pending.
- Added the first-phone enrollment flow in multi-device Settings. It requires a
  validated selected folder, a matching password of at least 12 characters, and
  successful Android system authentication before the group DEK is wrapped.
- The recovery key is displayed only while setup is pending. The encrypted local
  enrollment is created atomically only after the user confirms the recovery key
  was saved; cancellation deletes the provisional Android alias and persists no
  group. Password fields are cleared when the dialog closes.
- Three repository, five controller, and three widget tests bring focused sync
  coverage to 96 passing tests and the complete suite to 343. Scoped V11 analysis
  is clean; the APK compiles, installs preserving data, and launches physically.
- A dedicated physical RMX3301 diagnostic measured the production Argon2id
  profile at 1,670 ms to create group material and 1,000 ms to unlock it, without
  an out-of-memory failure. Real biometric/device-credential confirmation and
  Keystore wrap/unwrap still require user interaction in the installed flow.
- Added immutable group-manifest publication through the selected Android
  document tree. Only the versioned password/recovery-wrapped key manifest is
  exposed; the device-bound envelope never leaves private app storage.
- Android writes and verifies a unique temporary document, atomically renames it
  when supported, and otherwise uses a verified copy fallback. Identical final
  bytes are idempotent; different bytes for the same group fail as a visible
  conflict and are never overwritten.
- A failed publication keeps the locally enrolled group and exposes retry state.
  Four bridge tests plus one controller retry test bring focused sync coverage to
  101 and the complete Flutter suite to 348; scoped analysis and APK compilation
  pass. Physical folder publication awaits a reconnected Android phone.

Evidence on 2026-08-14:

- Added read-only discovery of canonical finalized group manifests for a joining
  phone. Android ignores unrelated/temporary names and enforces a 64 KiB read
  ceiling; Dart independently validates the filename/group match and the exact
  versioned cryptographic structure before any password KDF can run.
- Settings can now search the selected folder and show short identifiers for all
  valid groups plus an invalid-file count. This step deliberately cannot enroll,
  decrypt, import, merge, replace, or modify the private SQLite database.
- Seven new service/controller/widget checks bring focused sync coverage to 108
  and the complete Flutter suite to 355. Scoped analysis is clean; repository
  analysis retains only the unrelated pre-existing temporary `sqlite3` notice.
  The native APK compiles, installs preserving data, and launches on the
  wirelessly connected RMX3301.
- Added second-phone secure linking for any validated discovered group. The user
  may enter either the group password or independent recovery key once; only a
  correct credential proceeds to Android biometric/device-credential approval.
- Linking reuses the discovered group ID, wraps the recovered DEK with this
  phone's Android Keystore key, persists only the encrypted local enrollment,
  clears the mutable plaintext-key buffer, and removes a provisional alias if
  persistence fails. Wrong credentials and cancelled Android authentication
  persist nothing.
- The UI explicitly states that this prepares only the secure relationship and
  does not import, merge, replace, or synchronize local tasks yet. Seven new
  crypto/controller/widget checks bring focused sync coverage to 115 and the
  complete Flutter suite to 362. Scoped analysis is clean; the APK compiles,
  installs preserving data, and launches on the connected RMX3301.
- Added read-only inspection of the joining phone's seven user-data categories.
  An empty database records an empty-bootstrap intent; existing data blocks
  enrollment until the user chooses merge or replace, and the decision is stored
  with the encrypted local enrollment so it survives restart.
- This slice intentionally performs no merge, replacement, deletion, import, or
  publication. Replacement remains blocked until a recovery snapshot is created
  and verified. Five new checks bring focused sync coverage to 120 and the full
  suite to 367; scoped analysis is clean and repository analysis retains only the
  unrelated existing temporary `sqlite3` notice. The debug APK compiles, installs
  preserving app data, and launches as the resumed activity on RMX3301.
- The user explicitly authorized encrypted full-database recovery artifacts in
  the selected folder. MichiFocus now creates a consistent `VACUUM INTO` copy,
  validates the isolated 12-table database, encrypts and authenticates every
  byte with the group DEK, and asks Android SAF to verify the finalized artifact.
- A populated new join cannot persist until that recovery copy succeeds. Phones
  enrolled by an earlier build can create it after Android authentication without
  leaving the group or re-entering the group password. Failure preserves the live
  database and enrollment; private plaintext/ciphertext temporaries are removed.
- Nine new crypto, persistence, service, controller, and widget checks bring sync
  coverage to 129 and the complete suite to 376. Drift generation, scoped
  analysis, and debug APK compilation pass. Full analysis retains only the
  unrelated existing temporary `sqlite3` notice. The APK installs preserving app
  data and launches as the resumed activity on RMX3301; user-confirmed physical
  SAF snapshot creation remains pending.
- Added schema version 6 with seven private synchronization-metadata tables for
  local counter state, durable outbox, applied-operation idempotency, per-field
  versions, tombstones, conflicts, and acknowledgement watermarks. The existing
  12 application tables and their identifiers remain unchanged.
- Added a transactional Drift exchange boundary: a local application mutation,
  logical-counter increment, and outbox insert either commit together or all
  roll back. Remote application and its ledger entry have the same guarantee;
  exact repeats are no-ops and inconsistent reused identities fail closed.
- Schema 1-5 migration, validator, reset, rollback, counter, and deduplication
  coverage passes in 21 focused checks. Drift generation succeeds, scoped
  analysis is clean, and the complete suite passes with 381 tests. Full analysis
  retains only the unrelated existing temporary `sqlite3` dependency notice.
  The debug APK builds, installs over the existing app without clearing data,
  opens on RMX3301, and has SHA-256
  `BCC6333D6C3E489E4B9CF74D45D37D6F99428881A170F4AC520C38E1399EE724`.
  Actual encrypted operation files and task/routine repository wiring remain
  intentionally inactive.
- Existing mutable goals, routine aggregates, tasks, and calendar events are now
  converted into normal causal create operations before encrypted publication.
  Preparation is dependency ordered and idempotent: records with local causal
  history, a tombstone, or an existing outbox operation are not duplicated.
- The bootstrap, mutable key-buffer, bounded operation-name, publisher/discovery,
  and enrollment controller checks pass with the complete 404-test suite, Drift
  generation, formatting, and clean `lib`/`test` analysis.
  Immutable history, empty-device snapshot restore, replace-local execution, and
  the physical two-phone exchange remain open.
- Physical diagnosis found a populated Poco persisted as `restoreIntoEmpty` and
  four retryable Realme operations blocked by nested SAF directory publication.
  Bootstrap now runs for every enrollment except explicit `replaceLocal`, safely
  skipping remote baselines and repairing local-only update history with one full
  create baseline. Operation artifacts use collision-safe flat root names because
  both phones already prove root-level manifest and recovery publication works.
- Realme diagnostics also found an unmodifiable Android key byte list and a flat
  operation filename of about 137 characters. MichiFocus now copies the key into
  a mutable short-lived buffer for guaranteed erasure and uses a roughly
  108-character hexadecimal operation filename retaining owner/counter/operation
  identity. Final release installation succeeds on both phones without data loss;
  authenticated publication and Syncthing transport remained the physical gate.

Evidence on 2026-08-21:

- Physical publication exposed that Drift persisted outbox `DateTime` values at
  Unix-second precision while an earlier build hashed their original
  milliseconds. The publisher now recovers an older timestamp only when one of
  the 1,000 candidates matches the stored SHA-256 digest; an unrelated or altered
  digest still fails closed. New operation timestamps are normalized before both
  hashing and persistence, without a schema migration or discarded outbox rows.
- The release APK installed with `adb install -r` on Poco 2201117PG and Realme
  RMX3301 without clearing data. Authenticated preparation published all 18 Poco
  and 11 Realme operations as distinct immutable encrypted files. Syncthing then
  transported the complete 29-file set bidirectionally into the same selected
  folder on both phones without filename collisions or overwrites.
- Authenticated incoming review applied the other phone's complete batch:
  Realme reported 18 applied and Poco reported 11 applied, each with zero
  conflicts, zero deferred dependencies, and zero rejected files. Drift
  generation, focused regression coverage, clean `lib`/`test` analysis, and the
  complete 405-test suite passed. Background transport, delayed/offline cases,
  conflict resolution, immutable history, and broader convergence gates remain.

Evidence on 2026-08-24:

- Added a theme-aware conflict center in multi-device Settings. Each supported
  conflict shows the entity and field, both values, recorded dates, and device
  label or stable installation suffix. Choosing a candidate requires explicit
  confirmation; incomplete legacy or partial delete/update candidates remain
  visible but cannot be selected blindly.
- Same-field and delete/update detection now stores complete structured
  candidates when available. A user choice commits the local mutation, logical
  counter, merged causal parent, outbox operation, field version or tombstone,
  and resolved-conflict state in one Drift transaction.
- A received operation whose parent dominates both stored candidates closes the
  corresponding conflict on another phone rather than prompting independently.
  Focused persistence and widget tests cover local/remote presentation, chosen
  value application, dominating parent construction, and third-device
  consumption.
- Schema 7 keeps the friendly device name and a complete entity snapshot inside
  each authenticated encrypted operation. New delete tombstones retain that
  encrypted restoration context locally, so a concurrent remote edit can be
  restored without guessing missing fields. Existing schema-6 databases migrate
  forward without changing application rows.
- Safe goal and calendar-event conflicts offer `preserve both`: the original
  resolution and an independently identified duplicate are committed as two
  causal outbox operations inside one transaction. Tasks and routines do not
  expose this action because duplication could detach execution/history links.
- Clean `lib`/`test` analysis, all 162 sync tests, and all 423 project tests
  pass. Arrival-order
  permutations for the complete Drift path, accessibility matrices, immutable
  history conflicts, and physical Poco/Realme conflict creation remain before
  REQ-V11-005 can be Verified.
