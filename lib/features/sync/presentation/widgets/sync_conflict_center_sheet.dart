import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_conflict.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_group_enrollment_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:signals_flutter/signals_flutter.dart';

Future<void> showSyncConflictCenter(
  BuildContext context,
  SyncGroupEnrollmentController controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => _SyncConflictCenter(controller: controller),
  );
}

class _SyncConflictCenter extends StatelessWidget {
  const _SyncConflictCenter({required this.controller});

  final SyncGroupEnrollmentController controller;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.55,
      maxChildSize: 0.96,
      builder: (context, scrollController) => SignalBuilder(
        builder: (context) {
          final state = controller.conflictCenterState.value;
          final conflicts = controller.openConflicts.value;
          return Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: context.palette.neutralSoft,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: context.palette.primaryMuted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.merge_type_rounded,
                        color: context.palette.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr(
                              'Resolver conflictos',
                              'Resolve conflicts',
                            ),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            context.tr(
                              '${conflicts.length} decisión(es) pendiente(s)',
                              '${conflicts.length} pending decision(s)',
                            ),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: context.palette.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: context.tr('Cerrar', 'Close'),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: context.palette.neutralSoft),
              Expanded(
                child: switch (state) {
                  SyncConflictCenterState.loading => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  SyncConflictCenterState.failed => _ConflictCenterMessage(
                    icon: Icons.error_outline_rounded,
                    message: context.tr(
                      'No se pudieron cargar los conflictos. Inténtalo nuevamente.',
                      'Conflicts could not be loaded. Try again.',
                    ),
                    action: OutlinedButton.icon(
                      onPressed: controller.loadOpenConflicts,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(context.tr('Reintentar', 'Retry')),
                    ),
                  ),
                  _ when conflicts.isEmpty => _ConflictCenterMessage(
                    icon: Icons.check_circle_outline_rounded,
                    message: context.tr(
                      'No hay conflictos pendientes.',
                      'There are no pending conflicts.',
                    ),
                  ),
                  _ => ListView.separated(
                    key: const ValueKey('sync-conflict-list'),
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                    itemCount: conflicts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) => _ConflictCard(
                      conflict: conflicts[index],
                      resolving: state == SyncConflictCenterState.resolving,
                      onChoose: (choice) => _resolve(
                        context,
                        conflicts[index],
                        choice,
                      ),
                    ),
                  ),
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _resolve(
    BuildContext context,
    SyncConflict conflict,
    SyncConflictChoice choice,
  ) async {
    final candidate = choice == SyncConflictChoice.local
        ? conflict.local
        : conflict.remote;
    final preserveBoth = choice == SyncConflictChoice.preserveBoth;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          preserveBoth
              ? context.tr('Conservar ambas versiones', 'Keep both versions')
              : context.tr('Confirmar elección', 'Confirm choice'),
        ),
        content: Text(
          preserveBoth
              ? context.tr(
                  'MichiFocus conservará una versión en el elemento original y creará una copia independiente con la otra. Ambas decisiones se prepararán para los demás dispositivos.',
                  'MichiFocus will keep one version in the original item and create an independent copy with the other. Both decisions will be prepared for the other devices.',
                )
              : context.tr(
                  'Se conservará la versión de ${candidate.deviceLabel}. La decisión se preparará para los demás dispositivos.',
                  'The version from ${candidate.deviceLabel} will be kept. The decision will be prepared for the other devices.',
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.tr('Cancelar', 'Cancel')),
          ),
          FilledButton(
            key: const ValueKey('confirm-sync-conflict-resolution'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              preserveBoth
                  ? context.tr('Conservar ambas', 'Keep both')
                  : context.tr('Conservar', 'Keep'),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final resolved = await controller.resolveConflict(conflict.id, choice);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resolved
              ? context.tr(
                  'Conflicto resuelto. Prepara los cambios para compartir la decisión.',
                  'Conflict resolved. Prepare changes to share the decision.',
                )
              : context.tr(
                  'No se pudo resolver el conflicto.',
                  'The conflict could not be resolved.',
                ),
        ),
      ),
    );
  }
}

class _ConflictCard extends StatelessWidget {
  const _ConflictCard({
    required this.conflict,
    required this.resolving,
    required this.onChoose,
  });

  final SyncConflict conflict;
  final bool resolving;
  final ValueChanged<SyncConflictChoice> onChoose;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('sync-conflict-${conflict.id}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.palette.neutralSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _entityIcon(conflict.entityType),
                color: context.palette.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _entityLabel(context, conflict.entityType),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      conflict.fieldName == null
                          ? context.tr(
                              'Modificación frente a eliminación',
                              'Change versus deletion',
                            )
                          : context.tr(
                              'Campo: ${_fieldLabel(context, conflict.fieldName!)}',
                              'Field: ${_fieldLabel(context, conflict.fieldName!)}',
                            ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: context.palette.primaryMuted,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  context.tr('Requiere elección', 'Needs a choice'),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.palette.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _CandidateCard(
            key: ValueKey('sync-conflict-local-${conflict.id}'),
            title: context.tr('Versión conservada aquí', 'Version kept here'),
            candidate: conflict.local,
            enabled: !resolving && conflict.local.canApply,
            onPressed: () => onChoose(SyncConflictChoice.local),
          ),
          const SizedBox(height: 10),
          _CandidateCard(
            key: ValueKey('sync-conflict-remote-${conflict.id}'),
            title: context.tr('Cambio recibido', 'Received change'),
            candidate: conflict.remote,
            enabled: !resolving && conflict.remote.canApply,
            onPressed: () => onChoose(SyncConflictChoice.remote),
          ),
          if (conflict.canPreserveBoth) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                key: ValueKey('preserve-both-${conflict.id}'),
                onPressed: resolving
                    ? null
                    : () => onChoose(SyncConflictChoice.preserveBoth),
                icon: const Icon(Icons.copy_all_outlined),
                label: Text(
                  context.tr('Conservar ambas versiones', 'Keep both versions'),
                ),
              ),
            ),
          ],
          if (!conflict.local.canApply || !conflict.remote.canApply) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: context.palette.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.tr(
                      'Una versión no contiene datos suficientes para reconstruirse sin riesgo; MichiFocus no permite elegirla a ciegas.',
                      'One version does not contain enough data for safe reconstruction; MichiFocus will not select it blindly.',
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
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.title,
    required this.candidate,
    required this.enabled,
    required this.onPressed,
    super.key,
  });

  final String title;
  final SyncConflictCandidate candidate;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: context.palette.primaryMuted.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.palette.neutralSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.phone_android_rounded,
                size: 17,
                color: context.palette.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  candidate.deviceLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                _formatDate(candidate.recordedAt),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.palette.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            candidate.isDeletion
                ? context.tr('Elemento eliminado', 'Deleted item')
                : _formatValue(context, candidate.value),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: candidate.isDeletion
                  ? Theme.of(context).colorScheme.error
                  : context.palette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: enabled ? onPressed : null,
              child: Text(
                context.tr('Conservar esta versión', 'Keep this version'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConflictCenterMessage extends StatelessWidget {
  const _ConflictCenterMessage({
    required this.icon,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: context.palette.primary),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 14), action!],
          ],
        ),
      ),
    );
  }
}

IconData _entityIcon(String entityType) => switch (entityType) {
  'goal' => Icons.flag_outlined,
  'task' => Icons.task_alt_rounded,
  'calendarEvent' => Icons.event_outlined,
  'routine' => Icons.repeat_rounded,
  _ => Icons.data_object_rounded,
};

String _entityLabel(BuildContext context, String entityType) =>
    switch (entityType) {
      'goal' => context.tr('Objetivo', 'Goal'),
      'task' => context.tr('Tarea', 'Task'),
      'calendarEvent' => context.tr('Evento del calendario', 'Calendar event'),
      'routine' => context.tr('Rutina', 'Routine'),
      _ => context.tr('Dato sincronizado', 'Synchronized data'),
    };

String _fieldLabel(BuildContext context, String field) => switch (field) {
  'title' => context.tr('título', 'title'),
  'status' => context.tr('estado', 'status'),
  'isCompleted' => context.tr('finalización', 'completion'),
  'scheduledDate' || 'scheduledAt' => context.tr('fecha', 'date'),
  'goalId' => context.tr('objetivo asociado', 'linked goal'),
  'durationMinutes' => context.tr('duración', 'duration'),
  'targetSessions' => context.tr('meta de sesiones', 'session target'),
  'targetDate' => context.tr('fecha objetivo', 'target date'),
  'aggregate' => context.tr('contenido de la rutina', 'routine content'),
  _ => field,
};

String _formatValue(BuildContext context, Object? value) {
  if (value == null) return context.tr('Sin valor', 'No value');
  if (value is bool) {
    return value ? context.tr('Sí', 'Yes') : context.tr('No', 'No');
  }
  if (value is Map) {
    final name = value['name'];
    final title = value['title'];
    if (name is String) return name;
    if (title is String) return title;
    return const JsonEncoder.withIndent('  ').convert(value);
  }
  return value.toString();
}

String _formatDate(DateTime value) {
  if (value.millisecondsSinceEpoch <= 0) return '—';
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year} '
      '${two(local.hour)}:${two(local.minute)}';
}
