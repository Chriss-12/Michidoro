import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/goals/domain/entities/productivity_goal.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/routines/domain/entities/routine.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';

class RoutineEditorPage extends StatefulWidget {
  const RoutineEditorPage({super.key, this.routineId, this.onResult});

  static const routePath = '/routine-editor';
  final String? routineId;
  final ValueChanged<bool>? onResult;

  @override
  State<RoutineEditorPage> createState() => _RoutineEditorPageState();
}

class _RoutineEditorPageState extends State<RoutineEditorPage> {
  final RoutinesController _controller = serviceLocator<RoutinesController>();
  final GoalsController _goalsController = serviceLocator<GoalsController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late RoutineEditorDraft _draft;
  int _step = 0;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  bool _closeDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    Routine? routine;
    final id = widget.routineId;
    if (id != null) {
      routine = _findRoutine(id);
      if (routine == null) {
        await _controller.load();
        routine = _findRoutine(id);
      }
    }
    final draft = routine == null
        ? _controller.newDraft()
        : _controller.draftFor(routine);
    _nameController.text = draft.name;
    _descriptionController.text = draft.description ?? '';
    if (!mounted) return;
    setState(() {
      _draft = draft;
      _loading = false;
    });
  }

  Routine? _findRoutine(String id) {
    for (final routine in _controller.routines.value) {
      if (routine.id == id) return routine;
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateDraft(RoutineEditorDraft draft) {
    setState(() {
      _draft = draft;
      _dirty = true;
    });
  }

  Future<void> _requestClose() async {
    if (_closeDialogOpen || !mounted) return;
    if (!_dirty) {
      _finish(false);
      return;
    }
    _closeDialogOpen = true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          dialogContext.tr('Descartar cambios', 'Discard changes'),
        ),
        content: Text(
          dialogContext.tr(
            'Los cambios de esta rutina todavía no se guardaron.',
            'Changes to this routine have not been saved yet.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              dialogContext.tr('Seguir editando', 'Keep editing'),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.tr('Descartar', 'Discard')),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (discard ?? false) {
      setState(() {
        _dirty = false;
        _closeDialogOpen = false;
      });
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      _finish(false);
      return;
    }
    _closeDialogOpen = false;
  }

  void _finish(bool saved) {
    final onResult = widget.onResult;
    if (onResult != null) {
      onResult(saved);
      return;
    }
    context.pop(saved);
  }

  void _continue() {
    final draft = _draft;
    final issues = _controller.validate(draft);
    final section = switch (_step) {
      0 => RoutineEditorSection.identity,
      1 => RoutineEditorSection.recurrence,
      2 => RoutineEditorSection.items,
      _ => RoutineEditorSection.review,
    };
    final hasErrors = issues.any(
      (issue) => issue.isError && issue.section == section,
    );
    if (hasErrors) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _validationMessage(
              context,
              issues.firstWhere(
                (issue) => issue.isError && issue.section == section,
              ),
            ),
          ),
        ),
      );
      return;
    }
    setState(() => _step++);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final saved = await _controller.saveDraft(_draft);
    if (!mounted) return;
    setState(() => _saving = false);
    if (saved) {
      _dirty = false;
      _finish(true);
      return;
    }
    final issues = _controller.validationIssues.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          issues.isEmpty
              ? context.tr(
                  'No se pudo guardar la rutina',
                  'The routine could not be saved',
                )
              : _validationMessage(context, issues.first),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return PopScope<bool>(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _requestClose();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: palette.background,
        appBar: AppBar(
          backgroundColor: palette.surface,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          leading: IconButton(
            tooltip: context.tr('Volver', 'Back'),
            onPressed: _requestClose,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: Text(
            widget.routineId == null
                ? context.tr('Nueva rutina', 'New routine')
                : context.tr('Editar rutina', 'Edit routine'),
          ),
        ),
        body: DecoratedBox(
          decoration: palette.appBackgroundDecoration,
          child: SafeArea(
            top: false,
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _StepHeader(step: _step),
                      Expanded(child: _stepBody(context, _draft)),
                      _EditorActions(
                        step: _step,
                        saving: _saving,
                        onBack: _step == 0
                            ? _requestClose
                            : () => setState(() => _step--),
                        onNext: _step == 3 ? _save : _continue,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _stepBody(BuildContext context, RoutineEditorDraft draft) {
    return switch (_step) {
      0 => _IdentityStep(
        draft: draft,
        nameController: _nameController,
        descriptionController: _descriptionController,
        onChanged: _updateDraft,
      ),
      1 => _RecurrenceStep(draft: draft, onChanged: _updateDraft),
      2 => _ItemsStep(
        draft: draft,
        goals: _goalsController.goals.value,
        onChanged: _updateDraft,
      ),
      _ => _ReviewStep(
        draft: draft,
        review: _controller.review(draft),
      ),
    };
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    final titles = [
      context.tr('Información', 'Information'),
      context.tr('Días', 'Days'),
      context.tr('Actividades', 'Activities'),
      context.tr('Revisión', 'Review'),
    ];
    final subtitles = [
      context.tr('Identidad de la rutina', 'Routine identity'),
      context.tr('Frecuencia semanal', 'Weekly frequency'),
      context.tr('Orden y horarios', 'Order and times'),
      context.tr('Resumen antes de guardar', 'Summary before saving'),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      decoration: BoxDecoration(
        color: context.palette.glass,
        border: Border(
          bottom: BorderSide(color: context.palette.neutralSoft),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.palette.primaryMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _stepIcons[step],
                  color: context.palette.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(
                        'Paso ${step + 1} de 4',
                        'Step ${step + 1} of 4',
                      ),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.palette.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      titles[step],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: AppDesignTokens.sectionTitleFontSize,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      subtitles[step],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var index = 0; index < 4; index++) ...[
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= step
                          ? context.palette.primary
                          : context.palette.neutralSoft,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                if (index != 3) const SizedBox(width: 6),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _EditorActions extends StatelessWidget {
  const _EditorActions({
    required this.step,
    required this.saving,
    required this.onBack,
    required this.onNext,
  });
  final int step;
  final bool saving;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Material(
    color: context.palette.surface,
    shadowColor: Colors.transparent,
    child: SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.palette.neutralSoft),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: saving ? null : onBack,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                icon: Icon(
                  step == 0 ? Icons.close_rounded : Icons.arrow_back_rounded,
                ),
                label: Text(
                  step == 0
                      ? context.tr('Cancelar', 'Cancel')
                      : context.tr('Atrás', 'Back'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                key: ValueKey(step == 3 ? 'save-routine' : 'continue-routine'),
                onPressed: saving ? null : onNext,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                icon: saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        step == 3
                            ? Icons.save_rounded
                            : Icons.arrow_forward_rounded,
                      ),
                label: Text(
                  step == 3
                      ? context.tr('Guardar', 'Save')
                      : context.tr('Continuar', 'Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _IdentityStep extends StatelessWidget {
  const _IdentityStep({
    required this.draft,
    required this.nameController,
    required this.descriptionController,
    required this.onChanged,
  });
  final RoutineEditorDraft draft;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final ValueChanged<RoutineEditorDraft> onChanged;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey('routine-step-identity'),
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    children: [
      _RoutinePreview(draft: draft),
      const SizedBox(height: 18),
      _SectionLabel(
        icon: Icons.edit_note_rounded,
        label: context.tr('Datos principales', 'Main details'),
      ),
      const SizedBox(height: 10),
      _EditorSurface(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              maxLength: 80,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: context.tr('Nombre', 'Name'),
                hintText: context.tr(
                  'Ej. Mañana productiva',
                  'E.g. Productive morning',
                ),
                prefixIcon: const Icon(Icons.title_rounded),
              ),
              onChanged: (value) => onChanged(draft.copyWith(name: value)),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: descriptionController,
              maxLength: 500,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: context.tr(
                  'Descripción opcional',
                  'Optional description',
                ),
                prefixIcon: const Icon(Icons.notes_rounded),
              ),
              onChanged: (value) => onChanged(
                value.trim().isEmpty
                    ? draft.copyWith(clearDescription: true)
                    : draft.copyWith(description: value),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      _SectionLabel(
        icon: Icons.apps_rounded,
        label: context.tr('Icono', 'Icon'),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final entry in _routineIcons.entries)
            _ChoiceIcon(
              selected: draft.iconKey == entry.key,
              icon: entry.value,
              tooltip: entry.key,
              onPressed: () => onChanged(draft.copyWith(iconKey: entry.key)),
            ),
        ],
      ),
      const SizedBox(height: 20),
      _SectionLabel(
        icon: Icons.palette_outlined,
        label: context.tr('Color', 'Color'),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final key in _routineColors)
            _ColorChoice(
              colorKey: key,
              selected: draft.colorKey == key,
              onPressed: () => onChanged(draft.copyWith(colorKey: key)),
            ),
        ],
      ),
    ],
  );
}

class _RoutinePreview extends StatelessWidget {
  const _RoutinePreview({required this.draft});

  final RoutineEditorDraft draft;

  @override
  Widget build(BuildContext context) {
    final accent = _colorFor(context.palette, draft.colorKey);
    final name = draft.name.trim();
    final description = draft.description?.trim();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withValues(alpha: 0.55)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _routineIcons[draft.iconKey] ?? Icons.event_repeat_rounded,
              color: accent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? context.tr('Tu rutina', 'Your routine') : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  description == null || description.isEmpty
                      ? context.tr('Sin descripción', 'No description')
                      : description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceIcon extends StatelessWidget {
  const _ChoiceIcon({
    required this.selected,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });
  final bool selected;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 52,
    child: IconButton.filledTonal(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: selected
            ? context.palette.primaryMuted
            : context.palette.surface,
        foregroundColor: selected
            ? context.palette.primary
            : context.palette.textSecondary,
        side: BorderSide(
          color: selected
              ? context.palette.primary
              : context.palette.neutralSoft,
          width: selected ? 2 : 1,
        ),
      ),
      icon: Icon(icon),
    ),
  );
}

class _ColorChoice extends StatelessWidget {
  const _ColorChoice({
    required this.colorKey,
    required this.selected,
    required this.onPressed,
  });
  final String colorKey;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(context.palette, colorKey);
    return Semantics(
      label: colorKey,
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 52,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? context.palette.textPrimary
                  : context.palette.surface,
              width: selected ? 3 : 2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.28),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: selected
              ? const Icon(Icons.check_rounded, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}

class _RecurrenceStep extends StatelessWidget {
  const _RecurrenceStep({required this.draft, required this.onChanged});
  final RoutineEditorDraft draft;
  final ValueChanged<RoutineEditorDraft> onChanged;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey('routine-step-recurrence'),
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    children: [
      _EditorSurface(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.palette.primaryMuted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: context.palette.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('Frecuencia semanal', 'Weekly frequency'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    context.tr(
                      '${draft.weekdays.length} días seleccionados',
                      '${draft.weekdays.length} days selected',
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      _SectionLabel(
        icon: Icons.date_range_rounded,
        label: context.tr('Días de la semana', 'Days of the week'),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var day = 1; day <= 7; day++)
            FilterChip(
              key: ValueKey('routine-weekday-$day'),
              label: Text(_dayName(context, day)),
              selected: draft.weekdays.contains(day),
              onSelected: (_) {
                final days = draft.weekdays.toSet();
                days.contains(day) ? days.remove(day) : days.add(day);
                onChanged(draft.copyWith(weekdays: ([...days]..sort())));
              },
            ),
        ],
      ),
      const SizedBox(height: 24),
      _SectionLabel(
        icon: Icons.bolt_rounded,
        label: context.tr('Selección rápida', 'Quick selection'),
      ),
      const SizedBox(height: 10),
      _PresetDaysButton(
        label: context.tr('Lunes a viernes', 'Monday to Friday'),
        onPressed: () => onChanged(
          draft.copyWith(weekdays: const [1, 2, 3, 4, 5]),
        ),
      ),
      const SizedBox(height: 10),
      _PresetDaysButton(
        label: context.tr('Todos los días', 'Every day'),
        onPressed: () => onChanged(
          draft.copyWith(weekdays: const [1, 2, 3, 4, 5, 6, 7]),
        ),
      ),
    ],
  );
}

class _PresetDaysButton extends StatelessWidget {
  const _PresetDaysButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.calendar_month_rounded),
      label: Text(label),
    ),
  );
}

class _ItemsStep extends StatelessWidget {
  const _ItemsStep({
    required this.draft,
    required this.goals,
    required this.onChanged,
  });
  final RoutineEditorDraft draft;
  final List<ProductivityGoal> goals;
  final ValueChanged<RoutineEditorDraft> onChanged;

  Future<void> _editItem(BuildContext context, {int? index}) async {
    final initial = index == null ? null : draft.items[index];
    final result = await showModalBottomSheet<RoutineItemDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: context.palette.surface,
      builder: (context) => _RoutineItemEditor(
        initial: initial,
        position: index ?? draft.items.length,
        goals: goals,
      ),
    );
    if (result == null) return;
    final items = [...draft.items];
    index == null ? items.add(result) : items[index] = result;
    onChanged(draft.copyWith(items: _normalizePositions(items)));
  }

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey('routine-step-items'),
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    children: [
      _SectionLabel(
        icon: Icons.view_timeline_rounded,
        label: context.tr('Secuencia', 'Sequence'),
      ),
      const SizedBox(height: 3),
      Text(
        context.tr(
          '${draft.items.length} actividades',
          '${draft.items.length} activities',
        ),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: context.palette.textSecondary,
        ),
      ),
      const SizedBox(height: 10),
      FilledButton.icon(
        key: const ValueKey('add-routine-item'),
        onPressed: () => _editItem(context),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
        ),
        icon: const Icon(Icons.add_rounded),
        label: Text(context.tr('Agregar actividad', 'Add activity')),
      ),
      const SizedBox(height: 16),
      if (draft.items.isEmpty)
        _InlineMessage(
          icon: Icons.playlist_add_rounded,
          text: context.tr(
            'Agrega al menos una actividad con hora y duración.',
            'Add at least one activity with a time and duration.',
          ),
        )
      else
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: draft.items.length,
          onReorder: (oldIndex, newIndex) {
            final items = [...draft.items];
            if (newIndex > oldIndex) newIndex--;
            final item = items.removeAt(oldIndex);
            items.insert(newIndex, item);
            onChanged(draft.copyWith(items: _normalizePositions(items)));
          },
          itemBuilder: (context, index) {
            final item = draft.items[index];
            return Padding(
              key: ValueKey('routine-item-${item.id}-$index'),
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                decoration: BoxDecoration(
                  color: context.palette.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.palette.neutralSoft),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.palette.primaryMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: context.palette.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 3),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _CompactMeta(
                                icon: Icons.schedule_rounded,
                                label: _formatMinute(
                                  context,
                                  item.scheduledMinute,
                                ),
                              ),
                              _CompactMeta(
                                icon: Icons.timelapse_rounded,
                                label: '${item.durationMinutes} min',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ReorderableDragStartListener(
                      index: index,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.drag_indicator_rounded,
                          color: context.palette.textSecondary,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      tooltip: context.tr('Más opciones', 'More options'),
                      onSelected: (action) {
                        if (action == 'edit') {
                          _editItem(context, index: index);
                        } else {
                          final items = [...draft.items]..removeAt(index);
                          onChanged(
                            draft.copyWith(items: _normalizePositions(items)),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(context.tr('Editar', 'Edit')),
                        ),
                        PopupMenuItem(
                          value: 'remove',
                          child: Text(context.tr('Quitar', 'Remove')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
    ],
  );
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({required this.draft, required this.review});
  final RoutineEditorDraft draft;
  final RoutineReview review;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey('routine-step-review'),
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    children: [
      _EditorSurface(
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _colorFor(
                  context.palette,
                  draft.colorKey,
                ).withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _routineIcons[draft.iconKey] ?? Icons.event_repeat_rounded,
                color: _colorFor(context.palette, draft.colorKey),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    draft.name.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    draft.weekdays
                        .map((day) => _dayName(context, day))
                        .join(' · '),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: context.palette.primaryMuted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                draft.items.length == 1
                    ? context.tr('1 paso', '1 step')
                    : context.tr(
                        '${draft.items.length} pasos',
                        '${draft.items.length} steps',
                      ),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: context.palette.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      _SectionLabel(
        icon: Icons.insights_rounded,
        label: context.tr('Resumen de tiempo', 'Time summary'),
      ),
      const SizedBox(height: 10),
      LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - 10) / 2;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ReviewMetric(
                width: width,
                icon: Icons.center_focus_strong_rounded,
                label: context.tr('Enfoque', 'Focus'),
                value: '${review.totalFocusMinutes} min',
              ),
              _ReviewMetric(
                width: width,
                icon: Icons.free_breakfast_outlined,
                label: context.tr('Descansos', 'Breaks'),
                value: '${review.projectedBreakMinutes} min',
              ),
              _ReviewMetric(
                width: width,
                icon: Icons.schedule_rounded,
                label: context.tr('Tiempo ocupado', 'Occupied time'),
                value: '${review.scheduledSpanMinutes} min',
              ),
              _ReviewMetric(
                width: width,
                icon: Icons.flag_outlined,
                label: context.tr('Final estimado', 'Expected finish'),
                value: review.expectedFinishMinute == null
                    ? '—'
                    : _formatMinute(context, review.expectedFinishMinute!),
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 18),
      if (review.overlaps.isNotEmpty) ...[
        _InlineMessage(
          icon: Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.error,
          text: context.tr(
            '${review.overlaps.length} cruce(s) de horario. Puedes guardar, pero revisa las horas.',
            '${review.overlaps.length} schedule overlap(s). You can save, but review the times.',
          ),
        ),
        const SizedBox(height: 14),
      ],
      _SectionLabel(
        icon: Icons.format_list_numbered_rounded,
        label: context.tr('Actividades programadas', 'Scheduled activities'),
      ),
      const SizedBox(height: 10),
      for (var index = 0; index < draft.items.length; index++) ...[
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.palette.neutralSoft),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.palette.primaryMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: context.palette.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.items[index].title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatMinute(context, draft.items[index].scheduledMinute)} · ${draft.items[index].durationMinutes} min · ${_pomodoroLabel(context, draft.items[index].pomodoroMode)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (index != draft.items.length - 1) const SizedBox(height: 8),
      ],
    ],
  );
}

class _ReviewMetric extends StatelessWidget {
  const _ReviewMetric({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
  });
  final double width;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Container(
      constraints: const BoxConstraints(minHeight: 92),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.palette.neutralSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: context.palette.primary),
          const SizedBox(height: 7),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    ),
  );
}

class _EditorSurface extends StatelessWidget {
  const _EditorSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: context.palette.surface,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: context.palette.neutralSoft),
    ),
    child: child,
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 19, color: context.palette.primary),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    ],
  );
}

class _CompactMeta extends StatelessWidget {
  const _CompactMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: context.palette.primaryMuted.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: context.palette.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.palette.textSecondary,
          ),
        ),
      ],
    ),
  );
}

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({required this.icon, required this.text, this.color});
  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? context.palette.textSecondary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: foreground.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: foreground),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _RoutineItemEditor extends StatefulWidget {
  const _RoutineItemEditor({
    required this.position,
    required this.goals,
    this.initial,
  });
  final RoutineItemDraft? initial;
  final int position;
  final List<ProductivityGoal> goals;

  @override
  State<_RoutineItemEditor> createState() => _RoutineItemEditorState();
}

class _RoutineItemEditorState extends State<_RoutineItemEditor> {
  late final TextEditingController _title;
  late final TextEditingController _duration;
  late final TextEditingController _focus;
  late final TextEditingController _break;
  late int _minute;
  String? _goalId;
  bool _optional = false;
  int? _reminder;
  RoutinePomodoroMode _mode = RoutinePomodoroMode.none;
  String? _error;

  @override
  void initState() {
    super.initState();
    final item = widget.initial;
    _title = TextEditingController(text: item?.title ?? '');
    _duration = TextEditingController(text: '${item?.durationMinutes ?? 30}');
    _focus = TextEditingController(text: '${item?.customFocusMinutes ?? 25}');
    _break = TextEditingController(text: '${item?.customBreakMinutes ?? 5}');
    _minute = item?.scheduledMinute ?? 8 * 60;
    _goalId = item?.goalId;
    _optional = item?.isOptional ?? false;
    _reminder = item?.reminderMinutesBefore;
    _mode = item?.pomodoroMode ?? RoutinePomodoroMode.none;
  }

  @override
  void dispose() {
    _title.dispose();
    _duration.dispose();
    _focus.dispose();
    _break.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _minute ~/ 60, minute: _minute % 60),
    );
    if (picked != null) {
      setState(() => _minute = picked.hour * 60 + picked.minute);
    }
  }

  void _save() {
    final duration = int.tryParse(_duration.text);
    final focus = int.tryParse(_focus.text);
    final rest = int.tryParse(_break.text);
    if (_title.text.trim().isEmpty ||
        duration == null ||
        duration < 1 ||
        duration > 1440) {
      setState(
        () => _error = context.tr(
          'Revisa el título y la duración.',
          'Check the title and duration.',
        ),
      );
      return;
    }
    if (_mode == RoutinePomodoroMode.custom &&
        (focus == null ||
            focus < 1 ||
            focus > 240 ||
            rest == null ||
            rest < 1 ||
            rest > 60)) {
      setState(
        () => _error = context.tr(
          'Revisa los minutos personalizados.',
          'Check the custom minutes.',
        ),
      );
      return;
    }
    final initial = widget.initial;
    Navigator.pop(
      context,
      RoutineItemDraft(
        id: initial?.id ?? '',
        position: widget.position,
        title: _title.text.trim(),
        scheduledMinute: _minute,
        durationMinutes: duration,
        goalId: _goalId,
        isOptional: _optional,
        reminderMinutesBefore: _reminder,
        pomodoroMode: _mode,
        customFocusMinutes: _mode == RoutinePomodoroMode.custom ? focus : null,
        customBreakMinutes: _mode == RoutinePomodoroMode.custom ? rest : null,
        createdAt: initial?.createdAt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: Material(
      color: context.palette.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.initial == null
                        ? context.tr('Nueva actividad', 'New activity')
                        : context.tr('Editar actividad', 'Edit activity'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: context.tr('Cerrar', 'Close'),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionLabel(
              icon: Icons.edit_calendar_outlined,
              label: context.tr('Planificación', 'Planning'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _title,
              maxLength: 160,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: context.tr('Título', 'Title'),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _pickTime,
              icon: const Icon(Icons.schedule_rounded),
              label: Text(
                '${context.tr('Hora', 'Time')}: ${_formatMinute(context, _minute)}',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _duration,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: context.tr(
                  'Duración en minutos',
                  'Duration in minutes',
                ),
                prefixIcon: const Icon(Icons.timelapse_rounded),
              ),
            ),
            const SizedBox(height: 12),
            _SectionLabel(
              icon: Icons.tune_rounded,
              label: context.tr('Seguimiento', 'Tracking'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String?>(
              value: _goalId,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: context.tr('Objetivo opcional', 'Optional goal'),
              ),
              items: [
                DropdownMenuItem(
                  child: Text(
                    context.tr('Sin objetivo', 'No goal'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                for (final goal in widget.goals)
                  DropdownMenuItem(
                    value: goal.id,
                    child: Text(goal.title, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (value) => setState(() => _goalId = value),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: context.palette.primaryMuted.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.palette.neutralSoft),
              ),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                secondary: const Icon(Icons.low_priority_rounded),
                title: Text(
                  context.tr('Actividad opcional', 'Optional activity'),
                ),
                value: _optional,
                onChanged: (value) => setState(() => _optional = value),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              value: _reminder,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: context.tr('Recordatorio', 'Reminder'),
              ),
              items: [
                DropdownMenuItem(
                  child: Text(context.tr('Sin recordatorio', 'No reminder')),
                ),
                for (final value in const [0, 5, 10, 15, 30, 60])
                  DropdownMenuItem(
                    value: value,
                    child: Text(
                      value == 0
                          ? context.tr('A la hora', 'At start time')
                          : context.tr('$value min antes', '$value min before'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) => setState(() => _reminder = value),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RoutinePomodoroMode>(
              value: _mode,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Pomodoro',
                prefixIcon: Icon(Icons.timer_outlined),
              ),
              items: [
                for (final mode in RoutinePomodoroMode.values)
                  DropdownMenuItem(
                    value: mode,
                    child: Text(
                      _pomodoroLabel(context, mode),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _mode = value);
              },
            ),
            if (_mode == RoutinePomodoroMode.custom) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _focus,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: context.tr('Enfoque', 'Focus'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _break,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: context.tr('Descanso', 'Break'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
              key: const ValueKey('save-routine-item'),
              onPressed: _save,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              icon: const Icon(Icons.check_rounded),
              label: Text(context.tr('Guardar actividad', 'Save activity')),
            ),
          ],
        ),
      ),
    ),
  );
}

List<RoutineItemDraft> _normalizePositions(List<RoutineItemDraft> items) => [
  for (var index = 0; index < items.length; index++)
    items[index].copyWith(position: index),
];

String _formatMinute(BuildContext context, int minute) {
  final normalized = minute % (24 * 60);
  final base = MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60),
  );
  if (minute >= 24 * 60) return context.tr('$base (+1 día)', '$base (+1 day)');
  return base;
}

String _dayName(BuildContext context, int day) {
  const es = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return context.tr(es[day - 1], en[day - 1]);
}

String _pomodoroLabel(BuildContext context, RoutinePomodoroMode mode) =>
    switch (mode) {
      RoutinePomodoroMode.none => context.tr('Sin Pomodoro', 'No Pomodoro'),
      RoutinePomodoroMode.recommended => context.tr(
        'Recomendado 25/5',
        'Recommended 25/5',
      ),
      RoutinePomodoroMode.custom => context.tr('Personalizado', 'Custom'),
    };

String _validationMessage(BuildContext context, RoutineValidationIssue issue) =>
    switch (issue.code) {
      'name.required' => context.tr(
        'Escribe un nombre para la rutina.',
        'Enter a routine name.',
      ),
      'name.tooLong' => context.tr(
        'El nombre es demasiado largo.',
        'The name is too long.',
      ),
      'weekdays.required' => context.tr(
        'Selecciona al menos un día.',
        'Select at least one day.',
      ),
      'items.required' => context.tr(
        'Agrega al menos una actividad.',
        'Add at least one activity.',
      ),
      'items.overlap' => context.tr(
        'Hay actividades que se cruzan.',
        'Some activities overlap.',
      ),
      _ => context.tr(
        'Revisa la información ingresada.',
        'Review the entered information.',
      ),
    };

const _routineIcons = <String, IconData>{
  'routine': Icons.event_repeat_rounded,
  'sun': Icons.wb_sunny_outlined,
  'work': Icons.work_outline_rounded,
  'fitness': Icons.fitness_center_rounded,
  'book': Icons.menu_book_rounded,
};
const _stepIcons = <IconData>[
  Icons.badge_outlined,
  Icons.calendar_month_rounded,
  Icons.view_timeline_rounded,
  Icons.fact_check_outlined,
];
const _routineColors = ['primary', 'secondary', 'tertiary', 'peach', 'neutral'];

Color _colorFor(AppPalette palette, String key) => switch (key) {
  'secondary' => palette.secondary,
  'tertiary' => palette.tertiary,
  'peach' => palette.accentPeach,
  'neutral' => palette.neutral,
  _ => palette.primary,
};
