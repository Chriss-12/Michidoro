import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_group_enrollment.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_local_data_summary.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_group_manifest_discovery.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_group_enrollment_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_storage_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/sync_conflict_center_sheet.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class SyncGroupEnrollmentSettingsCard extends StatelessWidget {
  const SyncGroupEnrollmentSettingsCard({
    required this.controller,
    required this.storageController,
    super.key,
  });

  final SyncGroupEnrollmentController controller;
  final SyncStorageController storageController;

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        if (storageController.mode.value != SyncStorageMode.multipleDevices) {
          return const SizedBox.shrink();
        }

        final state = controller.state.value;
        final publicationState = controller.publicationState.value;
        final outboxState = controller.outboxPublicationState.value;
        final incomingState = controller.incomingApplicationState.value;
        final discoveryState = controller.discoveryState.value;
        final enrollmentSource = controller.enrollmentSource.value;
        final bootstrapPreference = controller.bootstrapPreference.value;
        final localDataState = controller.localDataState.value;
        final recoverySnapshotPath = controller.recoverySnapshotPath.value;
        final hasEnrollment =
            state == SyncGroupEnrollmentState.enrolled ||
            state == SyncGroupEnrollmentState.rebindRequired;
        final needsRebind = state == SyncGroupEnrollmentState.rebindRequired;
        final hasFolder =
            storageController.hasSelectedFolder &&
            storageController.folderAccessState.value ==
                SyncFolderAccessState.available;
        final shortGroupId = controller.groupId.value.length > 8
            ? controller.groupId.value.substring(
                controller.groupId.value.length - 8,
              )
            : controller.groupId.value;

        return Padding(
          padding: const EdgeInsets.only(top: 26),
          child: GlassCard(
            key: const ValueKey('sync-group-enrollment-card'),
            padding: AppCardPaddings.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.key_rounded, color: context.palette.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.tr(
                          'Grupo seguro de sincronización',
                          'Secure synchronization group',
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  hasEnrollment
                      ? context.tr(
                          needsRebind
                              ? 'El grupo sigue guardado, pero Android ya no puede '
                                    'abrir su clave local. La recuperación se añadirá '
                                    'en el siguiente bloque.'
                              : 'Este teléfono ya protege la clave del grupo con la '
                                    'seguridad de Android. La contraseña no está guardada.',
                          needsRebind
                              ? 'The group remains stored, but Android can no longer '
                                    'open its local key. Recovery will be added in the '
                                    'next slice.'
                              : 'This phone already protects the group key with Android '
                                    'security. The password is not stored.',
                        )
                      : context.tr(
                          'Crea una contraseña para enlazar tus teléfonos. La '
                              'escribirás una sola vez en cada dispositivo nuevo.',
                          'Create a password to link your phones. You will enter '
                              'it once on each new device.',
                        ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.textSecondary,
                  ),
                ),
                if (hasEnrollment && shortGroupId.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    context.tr(
                      'Grupo interno: …$shortGroupId',
                      'Internal group: …$shortGroupId',
                    ),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: context.palette.primary,
                    ),
                  ),
                  if (enrollmentSource ==
                      SyncGroupEnrollmentSource.joinedExisting) ...[
                    const SizedBox(height: 10),
                    _BootstrapPreparationStatus(
                      preference: bootstrapPreference,
                      summary: controller.localDataSummary.value,
                    ),
                  ],
                  if (localDataState ==
                      SyncLocalDataInspectionState.populated) ...[
                    const SizedBox(height: 10),
                    if (recoverySnapshotPath.isNotEmpty)
                      _RecoverySnapshotStatus(path: recoverySnapshotPath)
                    else
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          key: const ValueKey(
                            'create-encrypted-recovery-snapshot',
                          ),
                          onPressed: hasFolder && !controller.isBusy
                              ? () => _createRecoverySnapshot(context)
                              : null,
                          icon: const Icon(Icons.shield_outlined),
                          label: Text(
                            context.tr(
                              'Crear copia cifrada de recuperación',
                              'Create encrypted recovery copy',
                            ),
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 12),
                  _SyncGroupPublicationStatus(
                    state: publicationState,
                    path: controller.publishedManifestPath.value,
                    onRetry: hasFolder
                        ? () => controller.ensureManifestPublished(
                            storageController.folderUri.value,
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const ValueKey('prepare-and-review-sync-changes'),
                      onPressed: hasFolder && !controller.isBusy
                          ? () => _prepareAndReviewChanges(context)
                          : null,
                      icon:
                          outboxState ==
                                  SyncOutboxPublicationState.publishing ||
                              incomingState ==
                                  SyncIncomingApplicationState.processing
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.sync_rounded),
                      label: Text(
                        context.tr(
                          'Preparar y revisar cambios',
                          'Prepare and review changes',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      key: const ValueKey('open-syncthing'),
                      onPressed: controller.isBusy
                          ? null
                          : () => _openSyncthing(context),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: Text(
                        context.tr('Abrir Syncthing', 'Open Syncthing'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _OutboxPublicationStatus(
                    state: outboxState,
                    published: controller.publishedOperationCount.value,
                    remaining: controller.remainingOperationCount.value,
                  ),
                  const SizedBox(height: 12),
                  _IncomingApplicationStatus(
                    state: incomingState,
                    applied: controller.receivedOperationCount.value,
                    conflicts: controller.incomingConflictCount.value,
                    deferred: controller.deferredOperationCount.value,
                    rejected: controller.rejectedOperationCount.value,
                  ),
                  if (controller.openConflicts.value.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        key: const ValueKey('open-sync-conflict-center'),
                        onPressed: controller.isBusy
                            ? null
                            : () => showSyncConflictCenter(
                                context,
                                controller,
                              ),
                        icon: const Icon(Icons.merge_type_rounded),
                        label: Text(
                          context.tr(
                            'Resolver conflictos (${controller.openConflicts.value.length})',
                            'Resolve conflicts (${controller.openConflicts.value.length})',
                          ),
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const ValueKey('create-secure-sync-group'),
                      onPressed: hasFolder && !controller.isBusy
                          ? () => _startEnrollment(context)
                          : null,
                      icon: const Icon(Icons.add_moderator_outlined),
                      label: Text(
                        context.tr(
                          'Crear grupo seguro',
                          'Create secure group',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      key: const ValueKey('discover-secure-sync-groups'),
                      onPressed:
                          hasFolder &&
                              !controller.isBusy &&
                              discoveryState !=
                                  SyncGroupDiscoveryState.searching
                          ? () => controller.discoverGroups(
                              storageController.folderUri.value,
                            )
                          : null,
                      icon: discoveryState == SyncGroupDiscoveryState.searching
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.folder_open_rounded),
                      label: Text(
                        context.tr(
                          'Buscar grupo existente',
                          'Find existing group',
                        ),
                      ),
                    ),
                  ),
                  if (discoveryState == SyncGroupDiscoveryState.complete) ...[
                    const SizedBox(height: 12),
                    _DiscoveredGroupsSummary(
                      groups: controller.discoveredGroups.value,
                      rejectedFiles: controller.rejectedManifestFiles.value,
                      onJoin: (group) => _startJoining(context, group),
                    ),
                  ] else if (discoveryState ==
                      SyncGroupDiscoveryState.failed) ...[
                    const SizedBox(height: 10),
                    Text(
                      context.tr(
                        'No se pudo revisar la carpeta. Comprueba su permiso e inténtalo otra vez.',
                        'The folder could not be checked. Verify its permission and try again.',
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  if (!hasFolder) ...[
                    const SizedBox(height: 8),
                    Text(
                      context.tr(
                        'Primero selecciona y valida la carpeta que compartirás.',
                        'First select and validate the folder you will share.',
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createRecoverySnapshot(BuildContext context) async {
    final created = await controller.ensureRecoverySnapshot(
      storageController.folderUri.value,
    );
    if (!context.mounted || created) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_failureMessage(context, controller.failure.value)),
      ),
    );
  }

  Future<void> _prepareAndReviewChanges(BuildContext context) async {
    final completed = await controller.prepareAndReviewChanges(
      storageController.folderUri.value,
    );
    if (!context.mounted || completed) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_failureMessage(context, controller.failure.value)),
      ),
    );
  }

  Future<void> _openSyncthing(BuildContext context) async {
    final opened = await controller.openSyncthing();
    if (!context.mounted || opened) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_failureMessage(context, controller.failure.value)),
      ),
    );
  }

  Future<void> _startEnrollment(BuildContext context) async {
    final password = TextEditingController();
    final confirmation = TextEditingController();
    var isPreparing = false;
    String? error;

    final prepared = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                context.tr(
                  'Contraseña del grupo',
                  'Group password',
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.tr(
                        'Usa al menos 12 caracteres. MichiFocus no guardará la '
                            'contraseña ni podrá recuperarla.',
                        'Use at least 12 characters. MichiFocus will not store '
                            'the password and cannot recover it.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      key: const ValueKey('sync-group-password'),
                      controller: password,
                      obscureText: true,
                      enabled: !isPreparing,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: context.tr('Contraseña', 'Password'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const ValueKey('sync-group-password-confirmation'),
                      controller: confirmation,
                      obscureText: true,
                      enabled: !isPreparing,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: context.tr(
                          'Repetir contraseña',
                          'Repeat password',
                        ),
                        errorText: error,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isPreparing
                      ? null
                      : () => Navigator.of(dialogContext).pop(false),
                  child: Text(context.tr('Cancelar', 'Cancel')),
                ),
                FilledButton(
                  key: const ValueKey('prepare-secure-sync-group'),
                  onPressed: isPreparing
                      ? null
                      : () async {
                          setDialogState(() {
                            isPreparing = true;
                            error = null;
                          });
                          final succeeded = await controller.prepareNewGroup(
                            password: password.text,
                            passwordConfirmation: confirmation.text,
                          );
                          if (!dialogContext.mounted) return;
                          if (succeeded) {
                            Navigator.of(dialogContext).pop(true);
                            return;
                          }
                          setDialogState(() {
                            isPreparing = false;
                            error = _failureMessage(
                              dialogContext,
                              controller.failure.value,
                            );
                          });
                        },
                  child: isPreparing
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.tr('Continuar', 'Continue')),
                ),
              ],
            );
          },
        );
      },
    );
    password.clear();
    confirmation.clear();
    if ((prepared ?? false) && context.mounted) {
      await _showRecoveryKey(context);
    }
  }

  Future<void> _showRecoveryKey(BuildContext context) async {
    var confirmed = false;
    var isSaving = false;
    String? error;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              final recoveryKey = controller.recoveryKey.value;
              return AlertDialog(
                title: Text(
                  context.tr(
                    'Guarda tu clave de recuperación',
                    'Save your recovery key',
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr(
                          'Guárdala ahora en Buttercup. Solo se mostrará durante '
                              'esta configuración y permite recuperar el grupo si '
                              'olvidas la contraseña.',
                          'Save it in Buttercup now. It is shown only during this '
                              'setup and can recover the group if you forget the '
                              'password.',
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.palette.primaryMuted,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          recoveryKey,
                          key: const ValueKey('sync-recovery-key'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        key: const ValueKey('copy-sync-recovery-key'),
                        onPressed: isSaving
                            ? null
                            : () async {
                                await Clipboard.setData(
                                  ClipboardData(text: recoveryKey),
                                );
                              },
                        icon: const Icon(Icons.copy_rounded),
                        label: Text(context.tr('Copiar', 'Copy')),
                      ),
                      CheckboxListTile(
                        key: const ValueKey('confirm-sync-recovery-saved'),
                        contentPadding: EdgeInsets.zero,
                        value: confirmed,
                        onChanged: isSaving
                            ? null
                            : (value) => setDialogState(
                                () => confirmed = value ?? false,
                              ),
                        title: Text(
                          context.tr(
                            'Ya la guardé en un lugar seguro',
                            'I saved it in a safe place',
                          ),
                        ),
                      ),
                      if (error != null)
                        Text(
                          error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            await controller.cancelPendingEnrollment();
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                            }
                          },
                    child: Text(
                      context.tr('Cancelar configuración', 'Cancel setup'),
                    ),
                  ),
                  FilledButton(
                    key: const ValueKey('finish-sync-group-enrollment'),
                    onPressed: !confirmed || isSaving
                        ? null
                        : () async {
                            setDialogState(() {
                              isSaving = true;
                              error = null;
                            });
                            final saved = await controller.confirmRecoverySaved(
                              folderUri: storageController.folderUri.value,
                            );
                            if (!dialogContext.mounted) return;
                            if (saved) {
                              Navigator.of(dialogContext).pop();
                              return;
                            }
                            setDialogState(() {
                              isSaving = false;
                              error = context.tr(
                                'No se pudo guardar el grupo. Inténtalo otra vez.',
                                'The group could not be saved. Try again.',
                              );
                            });
                          },
                    child: isSaving
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(context.tr('Finalizar', 'Finish')),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _startJoining(
    BuildContext context,
    DiscoveredSyncGroupManifest group,
  ) async {
    final inspected = await controller.assessLocalData();
    if (!context.mounted) return;
    if (!inspected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr(
              'No se pudo revisar la base local. No se realizará la vinculación.',
              'The local database could not be checked. Linking will not continue.',
            ),
          ),
        ),
      );
      return;
    }

    final localSummary = controller.localDataSummary.value;
    final credential = TextEditingController();
    var useRecoveryKey = false;
    var isJoining = false;
    SyncGroupBootstrapPreference? selectedBootstrapPreference;
    String? error;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                context.tr(
                  'Vincular este teléfono',
                  'Link this phone',
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(
                        'Elige cómo abrir el grupo. Después Android pedirá tu huella o PIN para protegerlo en este teléfono.',
                        'Choose how to open the group. Android will then request your fingerprint or PIN to protect it on this phone.',
                      ),
                    ),
                    const SizedBox(height: 14),
                    _LocalDataDecision(
                      summary: localSummary,
                      selectedPreference: selectedBootstrapPreference,
                      enabled: !isJoining,
                      onSelected: (preference) {
                        setDialogState(() {
                          selectedBootstrapPreference = preference;
                          error = null;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<bool>(
                        key: const ValueKey('join-sync-group-method'),
                        segments: [
                          ButtonSegment(
                            value: false,
                            icon: const Icon(Icons.password_rounded),
                            label: Text(
                              context.tr('Contraseña', 'Password'),
                            ),
                          ),
                          ButtonSegment(
                            value: true,
                            icon: const Icon(Icons.key_rounded),
                            label: Text(
                              context.tr('Recuperación', 'Recovery'),
                            ),
                          ),
                        ],
                        selected: {useRecoveryKey},
                        onSelectionChanged: isJoining
                            ? null
                            : (selection) {
                                setDialogState(() {
                                  useRecoveryKey = selection.single;
                                  credential.clear();
                                  error = null;
                                });
                              },
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      key: const ValueKey('join-sync-group-credential'),
                      controller: credential,
                      obscureText: true,
                      enabled: !isJoining,
                      autofillHints: useRecoveryKey
                          ? null
                          : const [AutofillHints.password],
                      decoration: InputDecoration(
                        labelText: useRecoveryKey
                            ? context.tr(
                                'Clave de recuperación',
                                'Recovery key',
                              )
                            : context.tr('Contraseña', 'Password'),
                        errorText: error,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.tr(
                        'Este paso no importa ni reemplaza datos de este teléfono.',
                        'This step does not import or replace data on this phone.',
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isJoining
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(context.tr('Cancelar', 'Cancel')),
                ),
                FilledButton(
                  key: const ValueKey('confirm-join-sync-group'),
                  onPressed:
                      isJoining ||
                          (localSummary.hasUserData &&
                              selectedBootstrapPreference == null)
                      ? null
                      : () async {
                          setDialogState(() {
                            isJoining = true;
                            error = null;
                          });
                          final joined = await controller.joinExistingGroup(
                            group: group,
                            credential: credential.text,
                            useRecoveryKey: useRecoveryKey,
                            folderUri: storageController.folderUri.value,
                            selectedBootstrapPreference:
                                selectedBootstrapPreference,
                          );
                          if (!dialogContext.mounted) return;
                          if (joined) {
                            Navigator.of(dialogContext).pop();
                            return;
                          }
                          setDialogState(() {
                            isJoining = false;
                            error = _failureMessage(
                              dialogContext,
                              controller.failure.value,
                            );
                          });
                        },
                  child: isJoining
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.tr('Vincular', 'Link')),
                ),
              ],
            );
          },
        );
      },
    );
    credential.clear();
  }

  String _failureMessage(
    BuildContext context,
    SyncGroupEnrollmentFailure? failure,
  ) {
    return switch (failure) {
      SyncGroupEnrollmentFailure.passwordTooShort => context.tr(
        'Usa al menos 12 caracteres.',
        'Use at least 12 characters.',
      ),
      SyncGroupEnrollmentFailure.passwordsDoNotMatch => context.tr(
        'Las contraseñas no coinciden.',
        'The passwords do not match.',
      ),
      SyncGroupEnrollmentFailure.authenticationCancelled => context.tr(
        'Debes confirmar con la seguridad de Android.',
        'Confirm with Android security.',
      ),
      SyncGroupEnrollmentFailure.deviceSecurityUnavailable => context.tr(
        'Este teléfono no tiene seguridad compatible configurada.',
        'This phone has no compatible security configured.',
      ),
      SyncGroupEnrollmentFailure.invalidCredential => context.tr(
        'La contraseña o clave de recuperación no es correcta.',
        'The password or recovery key is incorrect.',
      ),
      SyncGroupEnrollmentFailure.alreadyEnrolled => context.tr(
        'Este teléfono ya tiene un grupo configurado.',
        'This phone already has a configured group.',
      ),
      SyncGroupEnrollmentFailure.localDataCheckFailed => context.tr(
        'No se pudo revisar la base local de forma segura.',
        'The local database could not be checked safely.',
      ),
      SyncGroupEnrollmentFailure.bootstrapChoiceRequired => context.tr(
        'Elige combinar o reemplazar antes de continuar.',
        'Choose merge or replace before continuing.',
      ),
      SyncGroupEnrollmentFailure.recoverySnapshotFailed => context.tr(
        'No se pudo crear y verificar la copia cifrada. No se modificó ningún dato.',
        'The encrypted recovery copy could not be created and verified. No data was changed.',
      ),
      SyncGroupEnrollmentFailure.externalSyncAppUnavailable => context.tr(
        'No se encontró Syncthing en este teléfono. Instálalo o ábrelo manualmente.',
        'Syncthing was not found on this phone. Install it or open it manually.',
      ),
      _ => context.tr(
        'No se pudo preparar el grupo de forma segura.',
        'The group could not be prepared securely.',
      ),
    };
  }
}

class _OutboxPublicationStatus extends StatelessWidget {
  const _OutboxPublicationStatus({
    required this.state,
    required this.published,
    required this.remaining,
  });

  final SyncOutboxPublicationState state;
  final int published;
  final int remaining;

  @override
  Widget build(BuildContext context) {
    final message = switch (state) {
      SyncOutboxPublicationState.idle => context.tr(
        'El envío cifrado de tareas, objetivos, calendario y rutinas está activo. Pulsa el botón cuando quieras entregar los cambios a Syncthing.',
        'Encrypted sending for tasks, goals, calendar, and routines is active. Press the button when you want to hand changes to Syncthing.',
      ),
      SyncOutboxPublicationState.publishing => context.tr(
        'Cifrando y preparando los cambios pendientes…',
        'Encrypting and preparing pending changes…',
      ),
      SyncOutboxPublicationState.complete =>
        published == 0
            ? context.tr(
                'No había cambios pendientes. El envío cifrado está al día.',
                'There were no pending changes. Encrypted sending is up to date.',
              )
            : context.tr(
                '$published cambios cifrados preparados. Syncthing puede transportarlos sin sobrescribir los de otros teléfonos.',
                '$published encrypted changes prepared. Syncthing can transport them without overwriting changes from other phones.',
              ),
      SyncOutboxPublicationState.failed => context.tr(
        remaining > 0
            ? 'No se pudieron preparar todos los cambios. Quedan $remaining pendientes para reintentar.'
            : 'No se pudieron preparar los cambios. Revisa la carpeta e inténtalo nuevamente.',
        remaining > 0
            ? 'Not all changes could be prepared. $remaining remain pending for retry.'
            : 'Changes could not be prepared. Check the folder and try again.',
      ),
    };
    return Text(
      message,
      key: const ValueKey('sync-outbox-publication-status'),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: state == SyncOutboxPublicationState.failed
            ? Theme.of(context).colorScheme.error
            : context.palette.textSecondary,
      ),
    );
  }
}

class _IncomingApplicationStatus extends StatelessWidget {
  const _IncomingApplicationStatus({
    required this.state,
    required this.applied,
    required this.conflicts,
    required this.deferred,
    required this.rejected,
  });

  final SyncIncomingApplicationState state;
  final int applied;
  final int conflicts;
  final int deferred;
  final int rejected;

  @override
  Widget build(BuildContext context) {
    final message = switch (state) {
      SyncIncomingApplicationState.idle => context.tr(
        'La recepción segura de tareas, objetivos, calendario y rutinas está activa. Revísala después de que Syncthing transporte archivos.',
        'Secure receiving for tasks, goals, calendar, and routines is active. Review it after Syncthing transports files.',
      ),
      SyncIncomingApplicationState.processing => context.tr(
        'Validando, descifrando y combinando los cambios recibidos…',
        'Validating, decrypting, and merging received changes…',
      ),
      SyncIncomingApplicationState.complete => context.tr(
        '$applied cambios aplicados; $conflicts conflictos; $deferred esperando dependencias; $rejected archivos rechazados.',
        '$applied changes applied; $conflicts conflicts; $deferred awaiting dependencies; $rejected files rejected.',
      ),
      SyncIncomingApplicationState.failed => context.tr(
        'No se pudieron revisar los cambios recibidos. Ningún archivo inválido modificó tus datos.',
        'Received changes could not be reviewed. No invalid file modified your data.',
      ),
    };
    return Text(
      message,
      key: const ValueKey('sync-incoming-application-status'),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: state == SyncIncomingApplicationState.failed
            ? Theme.of(context).colorScheme.error
            : context.palette.textSecondary,
      ),
    );
  }
}

class _RecoverySnapshotStatus extends StatelessWidget {
  const _RecoverySnapshotStatus({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('encrypted-recovery-snapshot-ready'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.palette.primaryMuted.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.palette.neutralSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr(
              'Copia cifrada y verificada preparada. Syncthing puede transportarla.',
              'Encrypted and verified recovery copy prepared. Syncthing can transport it.',
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            path,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: context.palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocalDataDecision extends StatelessWidget {
  const _LocalDataDecision({
    required this.summary,
    required this.selectedPreference,
    required this.enabled,
    required this.onSelected,
  });

  final SyncLocalDataSummary summary;
  final SyncGroupBootstrapPreference? selectedPreference;
  final bool enabled;
  final ValueChanged<SyncGroupBootstrapPreference> onSelected;

  @override
  Widget build(BuildContext context) {
    if (!summary.hasUserData) {
      return Text(
        context.tr(
          'Este teléfono no tiene datos de productividad. Se preparará para recibir el grupo sin reemplazar nada.',
          'This phone has no productivity data. It will be prepared to receive the group without replacing anything.',
        ),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: context.palette.textSecondary,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(
            'Hay ${summary.totalRecords} registros locales: ${summary.tasks} tareas, ${summary.goals} objetivos, ${summary.routines} rutinas y ${summary.focusSessions} sesiones de enfoque.',
            'There are ${summary.totalRecords} local records: ${summary.tasks} tasks, ${summary.goals} goals, ${summary.routines} routines, and ${summary.focusSessions} focus sessions.',
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              key: const ValueKey('join-bootstrap-merge'),
              selected:
                  selectedPreference == SyncGroupBootstrapPreference.mergeLocal,
              onSelected: enabled
                  ? (_) => onSelected(
                      SyncGroupBootstrapPreference.mergeLocal,
                    )
                  : null,
              label: Text(context.tr('Combinar', 'Merge')),
            ),
            ChoiceChip(
              key: const ValueKey('join-bootstrap-replace'),
              selected:
                  selectedPreference ==
                  SyncGroupBootstrapPreference.replaceLocal,
              onSelected: enabled
                  ? (_) => onSelected(
                      SyncGroupBootstrapPreference.replaceLocal,
                    )
                  : null,
              label: Text(context.tr('Reemplazar después', 'Replace later')),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          context.tr(
            'No se modificará nada ahora. Antes de reemplazar, MichiFocus deberá crear y verificar una copia de recuperación.',
            'Nothing will be changed now. Before replacing, MichiFocus must create and verify a recovery copy.',
          ),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.palette.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _BootstrapPreparationStatus extends StatelessWidget {
  const _BootstrapPreparationStatus({
    required this.preference,
    required this.summary,
  });

  final SyncGroupBootstrapPreference? preference;
  final SyncLocalDataSummary summary;

  @override
  Widget build(BuildContext context) {
    final message = switch (preference) {
      SyncGroupBootstrapPreference.mergeLocal => context.tr(
        'Decisión guardada: combinar los datos locales cuando el intercambio esté disponible.',
        'Saved decision: merge local data when exchange becomes available.',
      ),
      SyncGroupBootstrapPreference.replaceLocal => context.tr(
        'Decisión guardada: reemplazar más adelante, solo después de crear una copia de recuperación verificada.',
        'Saved decision: replace later, only after creating a verified recovery copy.',
      ),
      SyncGroupBootstrapPreference.restoreIntoEmpty => context.tr(
        'Este teléfono se preparó como base vacía para recibir los datos del grupo.',
        'This phone was prepared as an empty database to receive group data.',
      ),
      null => context.tr(
        'La preparación de datos todavía está pendiente.',
        'Data preparation is still pending.',
      ),
    };
    return Container(
      key: const ValueKey('sync-bootstrap-preparation-status'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.palette.primaryMuted.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.palette.neutralSoft),
      ),
      child: Text(
        summary.hasUserData
            ? '$message ${context.tr('Datos detectados: ${summary.totalRecords}.', 'Detected data: ${summary.totalRecords}.')}'
            : message,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _DiscoveredGroupsSummary extends StatelessWidget {
  const _DiscoveredGroupsSummary({
    required this.groups,
    required this.rejectedFiles,
    required this.onJoin,
  });

  final List<DiscoveredSyncGroupManifest> groups;
  final int rejectedFiles;
  final ValueChanged<DiscoveredSyncGroupManifest> onJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('discovered-sync-groups-summary'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.palette.primaryMuted.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.palette.neutralSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            groups.isEmpty
                ? context.tr(
                    'Todavía no llegó ningún grupo válido a esta carpeta.',
                    'No valid group has arrived in this folder yet.',
                  )
                : context.tr(
                    groups.length == 1
                        ? 'Se encontró 1 grupo seguro.'
                        : 'Se encontraron ${groups.length} grupos seguros.',
                    groups.length == 1
                        ? '1 secure group was found.'
                        : '${groups.length} secure groups were found.',
                  ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          for (final group in groups) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '…${group.manifest.groupId.substring(group.manifest.groupId.length - 8)}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: context.palette.primary,
                    ),
                  ),
                ),
                OutlinedButton(
                  key: ValueKey(
                    'join-existing-sync-group-${group.manifest.groupId}',
                  ),
                  onPressed: () => onJoin(group),
                  child: Text(context.tr('Vincular', 'Link')),
                ),
              ],
            ),
          ],
          if (rejectedFiles > 0) ...[
            const SizedBox(height: 6),
            Text(
              context.tr(
                'MichiFocus ignoró $rejectedFiles archivo(s) no válido(s).',
                'MichiFocus ignored $rejectedFiles invalid file(s).',
              ),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.palette.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SyncGroupPublicationStatus extends StatelessWidget {
  const _SyncGroupPublicationStatus({
    required this.state,
    required this.path,
    required this.onRetry,
  });

  final SyncGroupPublicationState state;
  final String path;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final (icon, message) = switch (state) {
      SyncGroupPublicationState.published => (
        Icons.check_circle_outline_rounded,
        context.tr(
          'Archivo cifrado preparado en la carpeta. Syncthing ya puede transportarlo.',
          'Encrypted file prepared in the folder. Syncthing can now transport it.',
        ),
      ),
      SyncGroupPublicationState.publishing => (
        Icons.hourglass_top_rounded,
        context.tr(
          'Preparando el archivo cifrado del grupo…',
          'Preparing the encrypted group file…',
        ),
      ),
      SyncGroupPublicationState.conflict => (
        Icons.report_problem_outlined,
        context.tr(
          'La carpeta contiene otro archivo para este mismo grupo. MichiFocus no lo sobrescribió.',
          'The folder contains another file for this group. MichiFocus did not overwrite it.',
        ),
      ),
      _ => (
        Icons.cloud_upload_outlined,
        context.tr(
          'El grupo está protegido localmente, pero falta preparar su archivo en la carpeta.',
          'The group is protected locally, but its folder file is still pending.',
        ),
      ),
    };
    final isPublished = state == SyncGroupPublicationState.published;
    final isPublishing = state == SyncGroupPublicationState.publishing;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.palette.primaryMuted.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.palette.neutralSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: context.palette.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          if (isPublished && path.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              path,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.palette.textSecondary,
              ),
            ),
          ],
          if (!isPublished && !isPublishing) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              key: const ValueKey('retry-sync-group-publication'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.tr('Reintentar', 'Retry')),
            ),
          ],
        ],
      ),
    );
  }
}
