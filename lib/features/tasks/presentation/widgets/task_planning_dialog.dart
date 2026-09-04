import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';

class TaskPlanningDialog extends StatefulWidget {
  const TaskPlanningDialog({
    required this.task,
    required this.goals,
    required this.onSave,
    required this.onUnschedule,
    super.key,
  });

  final Task task;
  final List<ProductivityGoal> goals;
  final Future<String?> Function({
    required String? goalId,
    required int durationMinutes,
  })
  onSave;
  final Future<void> Function() onUnschedule;

  @override
  State<TaskPlanningDialog> createState() => _TaskPlanningDialogState();
}

class _TaskPlanningDialogState extends State<TaskPlanningDialog> {
  late String? _selectedGoalId = widget.task.goalId;
  late final TextEditingController _durationController;
  String? _validationMessage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController(
      text: '${widget.task.durationMinutes ?? 25}',
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) return;
    final durationMinutes = int.tryParse(_durationController.text.trim());
    if (durationMinutes == null ||
        durationMinutes <= 0 ||
        durationMinutes > 24 * 60) {
      setState(() {
        _validationMessage = context.tr(
          'Escribe una duración entre 1 y 1440 minutos.',
          'Enter a duration between 1 and 1440 minutes.',
        );
      });
      return;
    }

    setState(() => _isSaving = true);
    final validationMessage = await widget.onSave(
      goalId: _selectedGoalId,
      durationMinutes: durationMinutes,
    );
    if (!mounted) return;
    if (validationMessage != null) {
      setState(() {
        _isSaving = false;
        _validationMessage = context.localizeMessage(validationMessage);
      });
      return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _unschedule() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    await widget.onUnschedule();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      title: Text(context.tr('Planificación de tarea', 'Task planning')),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.task_alt_rounded),
              title: Text(widget.task.title),
              subtitle: Text(context.tr('Tarea planificada', 'Planned task')),
            ),
            DropdownButtonFormField<String?>(
              value: _selectedGoalId,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: context.tr('Objetivo', 'Goal'),
                prefixIcon: const Icon(Icons.flag_rounded),
              ),
              items: [
                DropdownMenuItem<String?>(
                  child: Text(context.tr('Sin objetivo', 'No goal')),
                ),
                ...widget.goals.map(
                  (goal) => DropdownMenuItem<String?>(
                    value: goal.id,
                    child: Text(
                      goal.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: _isSaving
                  ? null
                  : (value) => setState(() => _selectedGoalId = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _durationController,
              enabled: !_isSaving,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: context.tr(
                  'Duración en minutos',
                  'Duration in minutes',
                ),
                prefixIcon: const Icon(Icons.timer_outlined),
                errorText: _validationMessage,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final minutes in const [25, 30, 45, 60, 90, 120])
                  ChoiceChip(
                    label: Text('$minutes min'),
                    selected: int.tryParse(_durationController.text) == minutes,
                    onSelected: _isSaving
                        ? null
                        : (_) {
                            setState(() {
                              _durationController.text = '$minutes';
                              _validationMessage = null;
                            });
                          },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : () => unawaited(_submit()),
                icon: const Icon(Icons.save_rounded),
                label: Text(context.tr('Guardar', 'Save')),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                child: Text(context.tr('Cancelar', 'Cancel')),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _isSaving ? null : () => unawaited(_unschedule()),
                icon: const Icon(Icons.event_busy_rounded),
                label: Text(context.tr('Quitar del día', 'Remove from day')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
