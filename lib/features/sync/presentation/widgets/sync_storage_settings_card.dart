import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_data_folder_validator.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_storage_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class SyncStorageSettingsCard extends StatefulWidget {
  const SyncStorageSettingsCard({required this.controller, super.key});

  final SyncStorageController controller;

  @override
  State<SyncStorageSettingsCard> createState() =>
      _SyncStorageSettingsCardState();
}

class _SyncStorageSettingsCardState extends State<SyncStorageSettingsCard> {
  bool _isChanging = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller.hasSelectedFolder) {
      unawaited(widget.controller.validateSelectedFolder());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final mode = widget.controller.mode.value;
        final folderLabel = widget.controller.folderLabel.value;
        final hasFolder = widget.controller.hasSelectedFolder;
        final isMultiple = mode == SyncStorageMode.multipleDevices;

        return GlassCard(
          key: const ValueKey('sync-storage-settings-card'),
          padding: AppCardPaddings.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.folder_shared_outlined,
                    color: context.palette.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.tr('Datos y dispositivos', 'Data and devices'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                context.tr(
                  'La base de datos activa siempre permanece privada dentro de '
                      'MichiFocus. La carpeta elegida se usará para copias '
                      'seguras y, más adelante, para intercambio cifrado.',
                  'The active database always remains private inside MichiFocus. '
                      'The selected folder will be used for safe backups and, '
                      'later, encrypted exchange.',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              SegmentedButton<SyncStorageMode>(
                key: const ValueKey('sync-storage-mode'),
                segments: [
                  ButtonSegment(
                    value: SyncStorageMode.singleDevice,
                    icon: const Icon(Icons.smartphone_rounded),
                    label: Text(context.tr('Un dispositivo', 'One device')),
                  ),
                  ButtonSegment(
                    value: SyncStorageMode.multipleDevices,
                    icon: const Icon(Icons.devices_rounded),
                    label: Text(context.tr('Varios', 'Multiple')),
                  ),
                ],
                selected: {mode},
                onSelectionChanged: _isChanging
                    ? null
                    : (selection) => _changeMode(selection.single),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.palette.primaryMuted.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.palette.neutralSoft),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasFolder
                          ? context.tr(
                              'Carpeta seleccionada',
                              'Selected folder',
                            )
                          : context.tr(
                              'Sin carpeta seleccionada',
                              'No folder selected',
                            ),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (hasFolder) ...[
                      const SizedBox(height: 4),
                      Text(
                        folderLabel,
                        key: const ValueKey('sync-storage-folder-label'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.palette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _FolderAccessStatus(
                        state: widget.controller.folderAccessState.value,
                        onRetry: _isChanging ? null : _validateFolder,
                      ),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        key: const ValueKey('sync-storage-select-folder'),
                        onPressed: _isChanging ? null : _selectFolder,
                        icon: const Icon(Icons.create_new_folder_outlined),
                        label: Text(
                          hasFolder
                              ? context.tr('Cambiar carpeta', 'Change folder')
                              : context.tr(
                                  'Seleccionar carpeta',
                                  'Select folder',
                                ),
                        ),
                      ),
                    ),
                    if (hasFolder)
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          key: const ValueKey('sync-storage-disconnect-folder'),
                          onPressed: _isChanging ? null : _disconnectFolder,
                          icon: const Icon(Icons.link_off_rounded),
                          label: Text(
                            context.tr(
                              'Desconectar carpeta',
                              'Disconnect folder',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (isMultiple) ...[
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: context.palette.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.tr(
                          'El modo de varios dispositivos está preparado, pero '
                              'todavía no comparte datos. El siguiente paso será '
                              'crear un grupo o unirse a uno con contraseña.',
                          'Multiple-device mode is prepared but does not share '
                              'data yet. The next step will be creating or joining '
                              'a password-protected group.',
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.palette.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _changeMode(SyncStorageMode nextMode) async {
    if (nextMode == widget.controller.mode.value) return;
    if (nextMode == SyncStorageMode.multipleDevices) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          key: const ValueKey('enable-multiple-devices-dialog'),
          title: Text(
            context.tr(
              'Preparar varios dispositivos',
              'Prepare multiple devices',
            ),
          ),
          content: Text(
            context.tr(
              'La base de datos activa no se moverá a la carpeta. Activar esta '
                  'opción solo mostrará la preparación; nada se compartirá hasta '
                  'crear o unir un grupo cifrado.',
              'The active database will not move to the folder. Enabling this '
                  'option only shows setup; nothing will be shared until an '
                  'encrypted group is created or joined.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.tr('Cancelar', 'Cancel')),
            ),
            FilledButton(
              key: const ValueKey('confirm-multiple-devices'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.tr('Continuar', 'Continue')),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }

    await _runChange(() => widget.controller.setMode(nextMode));
  }

  Future<void> _selectFolder() async {
    final successMessage = context.tr('Carpeta guardada.', 'Folder saved.');
    await _runChange(() async {
      final selected = await widget.controller.selectFolder();
      if (!selected) return;
      _showMessage(successMessage);
    });
  }

  Future<void> _disconnectFolder() async {
    final successMessage = context.tr(
      'La carpeta se desconectó. Tus datos locales siguen disponibles.',
      'The folder was disconnected. Your local data remains available.',
    );
    await _runChange(() async {
      await widget.controller.disconnectFolder();
      _showMessage(successMessage);
    });
  }

  Future<void> _validateFolder() async {
    final availableMessage = context.tr(
      'La carpeta permite guardar y recuperar datos.',
      'The folder can store and retrieve data.',
    );
    final unavailableMessage = context.tr(
      'Android ya no permite usar esta carpeta. Selecciónala otra vez.',
      'Android no longer allows this folder. Select it again.',
    );
    await _runChange(() async {
      final available = await widget.controller.validateSelectedFolder();
      _showMessage(available ? availableMessage : unavailableMessage);
    });
  }

  Future<void> _runChange(Future<void> Function() change) async {
    final failureMessage = context.tr(
      'No se pudo guardar esta configuración.',
      'This setting could not be saved.',
    );
    final unavailableFolderMessage = context.tr(
      'No se pudo escribir, leer y retirar el archivo de prueba. Elige otra carpeta.',
      'The test file could not be written, read, and removed. Choose another folder.',
    );
    setState(() => _isChanging = true);
    try {
      await change();
    } on SyncDataFolderUnavailableException {
      _showMessage(unavailableFolderMessage);
    } on Object {
      _showMessage(failureMessage);
    } finally {
      if (mounted) setState(() => _isChanging = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _FolderAccessStatus extends StatelessWidget {
  const _FolderAccessStatus({required this.state, required this.onRetry});

  final SyncFolderAccessState state;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final isChecking = state == SyncFolderAccessState.checking;
    final isAvailable = state == SyncFolderAccessState.available;
    final isUnavailable = state == SyncFolderAccessState.unavailable;
    final color = isUnavailable
        ? Theme.of(context).colorScheme.error
        : context.palette.textSecondary;
    final label = switch (state) {
      SyncFolderAccessState.checking => context.tr(
        'Comprobando acceso…',
        'Checking access…',
      ),
      SyncFolderAccessState.available => context.tr(
        'Acceso comprobado',
        'Access verified',
      ),
      SyncFolderAccessState.unavailable => context.tr(
        'Acceso perdido: vuelve a seleccionar la carpeta',
        'Access lost: select the folder again',
      ),
      _ => context.tr('Acceso pendiente de comprobar', 'Access check pending'),
    };

    return Row(
      key: const ValueKey('sync-folder-access-status'),
      children: [
        if (isChecking)
          const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          Icon(
            isAvailable
                ? Icons.verified_outlined
                : isUnavailable
                ? Icons.warning_amber_rounded
                : Icons.help_outline_rounded,
            size: 20,
            color: color,
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
        if (!isChecking)
          TextButton(
            key: const ValueKey('validate-sync-folder'),
            onPressed: onRetry,
            child: Text(context.tr('Comprobar', 'Check')),
          ),
      ],
    );
  }
}
