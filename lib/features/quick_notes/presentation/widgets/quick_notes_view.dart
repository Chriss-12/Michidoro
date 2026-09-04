import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/quick_notes/domain/entities/quick_note.dart';
import 'package:pomodoro_app_v1/features/quick_notes/presentation/controllers/quick_notes_controller.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_mutation_failure.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/models/date_period_filter.dart';
import 'package:pomodoro_app_v1/shared/molecules/date_period_filter_control.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:pomodoro_app_v1/shared/molecules/speech_dictation_button.dart';
import 'package:signals_flutter/signals_flutter.dart';

class QuickNotesView extends StatelessWidget {
  const QuickNotesView({
    required this.controller,
    this.initialDate,
    super.key,
  });

  final QuickNotesController controller;
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final notes = controller.filteredNotes.value;
        final selectedSort = controller.sort.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    key: const ValueKey('create-quick-note-button'),
                    onPressed: () => _openEditor(context),
                    icon: const Icon(Icons.note_add_rounded),
                    label: Text(context.tr('Nueva nota', 'New note')),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<QuickNoteSort>(
                  tooltip: context.tr('Ordenar notas', 'Sort notes'),
                  initialValue: selectedSort,
                  onSelected: (value) => controller.sort.value = value,
                  itemBuilder: (context) => [
                    for (final sort in QuickNoteSort.values)
                      PopupMenuItem(
                        value: sort,
                        child: Row(
                          children: [
                            Icon(_sortIcon(sort), size: 20),
                            const SizedBox(width: 10),
                            Text(_sortLabel(context, sort)),
                          ],
                        ),
                      ),
                  ],
                  icon: const Icon(Icons.sort_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            DatePeriodFilterControl(
              value: controller.selectedDateFilter,
              onChanged: (value) => controller.selectedDateFilter = value,
            ),
            const SizedBox(height: 14),
            if (controller.isLoading.value)
              const Center(child: CircularProgressIndicator())
            else if (notes.isEmpty)
              const _EmptyQuickNotes()
            else
              GlassCard(
                child:
                    selectedSort == QuickNoteSort.manual &&
                        controller.selectedDateFilter.kind ==
                            DatePeriodFilterKind.all
                    ? ReorderableListView.builder(
                        key: const ValueKey('quick-notes-reorderable-list'),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        buildDefaultDragHandles: false,
                        itemCount: notes.length,
                        onReorder: (oldIndex, newIndex) {
                          final target = newIndex > oldIndex
                              ? newIndex - 1
                              : newIndex;
                          controller.move(notes[oldIndex].id, target);
                        },
                        itemBuilder: (context, index) => Padding(
                          key: ValueKey(notes[index].id),
                          padding: EdgeInsets.only(
                            bottom: index == notes.length - 1 ? 0 : 10,
                          ),
                          child: _QuickNoteTile(
                            note: notes[index],
                            dragIndex: index,
                            onToggle: () => controller.toggle(notes[index].id),
                            onEdit: () => _openEditor(
                              context,
                              note: notes[index],
                            ),
                            onDelete: () => _confirmDelete(
                              context,
                              notes[index],
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          for (
                            var index = 0;
                            index < notes.length;
                            index++
                          ) ...[
                            _QuickNoteTile(
                              note: notes[index],
                              onToggle: () =>
                                  controller.toggle(notes[index].id),
                              onEdit: () => _openEditor(
                                context,
                                note: notes[index],
                              ),
                              onDelete: () => _confirmDelete(
                                context,
                                notes[index],
                              ),
                            ),
                            if (index < notes.length - 1)
                              const SizedBox(height: 10),
                          ],
                        ],
                      ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _openEditor(BuildContext context, {QuickNote? note}) async {
    controller.clearValidation();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => _QuickNoteEditor(
        controller: controller,
        note: note,
        initialDate: initialDate,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, QuickNote note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('Eliminar nota', 'Delete note')),
        content: Text(
          dialogContext.tr(
            'Esta nota se eliminará de forma permanente.',
            'This note will be permanently deleted.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.tr('Cancelar', 'Cancel')),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.delete_outline_rounded),
            label: Text(dialogContext.tr('Eliminar', 'Delete')),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await controller.delete(note.id);
  }
}

class _EmptyQuickNotes extends StatelessWidget {
  const _EmptyQuickNotes();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: context.palette.primaryMuted,
            child: Icon(
              Icons.sticky_note_2_rounded,
              color: context.palette.primary,
              size: 38,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('Sin notas rápidas', 'No quick notes'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr(
              'Anota una idea, un pendiente o algo que quieras recordar.',
              'Write down an idea, a pending item, or something to remember.',
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickNoteTile extends StatelessWidget {
  const _QuickNoteTile({
    required this.note,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.dragIndex,
  });

  final QuickNote note;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int? dragIndex;

  @override
  Widget build(BuildContext context) {
    final color = Color(note.colorArgb);
    return Material(
      color: Color.alphaBlend(
        color.withValues(alpha: 0.13),
        context.palette.surface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.55)),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 6, color: color),
            SizedBox.square(
              dimension: 40,
              child: Checkbox(
                value: note.isCompleted,
                onChanged: (_) => onToggle(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        decoration: note.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: note.isCompleted
                            ? context.palette.textSecondary
                            : context.palette.textPrimary,
                      ),
                    ),
                    if (note.localDate != null || note.priority != null) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          if (note.localDate != null)
                            _Metadata(
                              icon: Icons.event_rounded,
                              label: _shortDate(note.localDate!),
                            ),
                          if (note.priority != null)
                            _Metadata(
                              icon: _priorityIcon(note.priority!),
                              label: _priorityLabel(context, note.priority!),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PopupMenuButton<_NoteAction>(
                    tooltip: context.tr('Opciones de nota', 'Note options'),
                    padding: EdgeInsets.zero,
                    onSelected: (action) {
                      if (action == _NoteAction.edit) onEdit();
                      if (action == _NoteAction.delete) onDelete();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: _NoteAction.edit,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.edit_rounded),
                          title: Text(context.tr('Editar', 'Edit')),
                        ),
                      ),
                      PopupMenuItem(
                        value: _NoteAction.delete,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.delete_outline_rounded),
                          title: Text(context.tr('Eliminar', 'Delete')),
                        ),
                      ),
                    ],
                    child: const SizedBox.square(
                      dimension: 40,
                      child: Icon(Icons.more_vert_rounded),
                    ),
                  ),
                  if (dragIndex != null)
                    ReorderableDragStartListener(
                      index: dragIndex!,
                      child: SizedBox.square(
                        dimension: 40,
                        child: Icon(
                          Icons.drag_indicator_rounded,
                          color: context.palette.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _NoteAction { edit, delete }

class _Metadata extends StatelessWidget {
  const _Metadata({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: context.palette.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: context.palette.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _QuickNoteEditor extends StatefulWidget {
  const _QuickNoteEditor({
    required this.controller,
    required this.initialDate,
    this.note,
  });

  final QuickNotesController controller;
  final QuickNote? note;
  final DateTime? initialDate;

  @override
  State<_QuickNoteEditor> createState() => _QuickNoteEditorState();
}

class _QuickNoteEditorState extends State<_QuickNoteEditor> {
  late final TextEditingController _textController;
  late HSVColor _color;
  late DateTime? _localDate;
  late QuickNotePriority? _priority;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _textController = TextEditingController(text: note?.text ?? '');
    _color = HSVColor.fromColor(Color(note?.colorArgb ?? 0xFF6F8F68));
    final initialDate = widget.initialDate ?? DateTime.now();
    _localDate = note == null
        ? DateTime(initialDate.year, initialDate.month, initialDate.day)
        : note.localDate;
    _priority = note?.priority;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    bool saved;
    try {
      final note = widget.note;
      saved = note == null
          ? await widget.controller.create(
              rawText: _textController.text,
              colorArgb: _color.toColor().toARGB32(),
              localDate: _localDate,
              priority: _priority,
            )
          : await widget.controller.update(
              id: note.id,
              rawText: _textController.text,
              colorArgb: _color.toColor().toARGB32(),
              localDate: _localDate,
              priority: _priority,
            );
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      final failure = error is SyncMutationFailure ? error : null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.tr(
              'No se pudo guardar la nota.',
              'The note could not be saved.',
            )} ${_syncFailureMessage(context, failure?.stage)}',
          ),
        ),
      );
      return;
    }
    if (!mounted) return;
    if (saved) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      _saving = false;
      _error = switch (widget.controller.validationCode.value) {
        'tooLong' => context.tr(
          'La nota no puede superar 500 caracteres.',
          'The note cannot exceed 500 characters.',
        ),
        _ => context.tr(
          'Escribe algo para guardar la nota.',
          'Write something to save the note.',
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + keyboard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.note == null
                ? context.tr('Nueva nota rápida', 'New quick note')
                : context.tr('Editar nota', 'Edit note'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('quick-note-text-field'),
            controller: _textController,
            autofocus: widget.note == null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: 1,
            maxLines: 2,
            maxLength: 500,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              labelText: context.tr('Nota', 'Note'),
              hintText: context.tr(
                'Escribe una idea o recordatorio…',
                'Write an idea or reminder…',
              ),
              errorText: _error,
              suffixIcon: SpeechDictationFieldActions(
                fieldId: 'quick-note-text',
                textController: _textController,
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
              ),
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const SizedBox(height: 8),
          _EditorSection(
            title: context.tr('Color de la nota', 'Note color'),
            child: _PaintColorPicker(
              color: _color,
              onChanged: (value) => setState(() => _color = value),
            ),
          ),
          const SizedBox(height: 12),
          _EditorSection(
            title: context.tr('Organización opcional', 'Optional organization'),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.event_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _localDate == null
                            ? context.tr('Sin fecha', 'No date')
                            : _shortDate(_localDate!),
                      ),
                    ),
                    if (_localDate != null)
                      SizedBox.square(
                        dimension: 40,
                        child: IconButton(
                          tooltip: context.tr('Quitar fecha', 'Remove date'),
                          onPressed: () => setState(() => _localDate = null),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ),
                    SizedBox.square(
                      dimension: 40,
                      child: IconButton(
                        tooltip: context.tr('Elegir fecha', 'Choose date'),
                        onPressed: _pickDate,
                        icon: const Icon(Icons.edit_calendar_rounded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<QuickNotePriority?>(
                  value: _priority,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.tr('Prioridad', 'Priority'),
                    prefixIcon: const Icon(Icons.flag_rounded),
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text(context.tr('Sin prioridad', 'No priority')),
                    ),
                    for (final priority in QuickNotePriority.values)
                      DropdownMenuItem(
                        value: priority,
                        child: Text(_priorityLabel(context, priority)),
                      ),
                  ],
                  onChanged: (value) => setState(() => _priority = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            key: const ValueKey('save-quick-note-button'),
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(context.tr('Guardar nota', 'Save note')),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _localDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100, 12, 31),
    );
    if (selected != null && mounted) setState(() => _localDate = selected);
  }
}

String _syncFailureMessage(
  BuildContext context,
  SyncMutationFailureStage? stage,
) => switch (stage) {
  SyncMutationFailureStage.storageConfiguration => context.tr(
    'Falló la configuración de almacenamiento (S1).',
    'Storage configuration failed (S1).',
  ),
  SyncMutationFailureStage.enrollment => context.tr(
    'Falló el grupo seguro (S2).',
    'The secure group failed (S2).',
  ),
  SyncMutationFailureStage.deviceIdentity => context.tr(
    'Falló la identidad del dispositivo (S3).',
    'The device identity failed (S3).',
  ),
  SyncMutationFailureStage.localState => context.tr(
    'La identidad no coincide con el estado local (S4).',
    'The identity does not match local state (S4).',
  ),
  SyncMutationFailureStage.currentSnapshot => context.tr(
    'No se pudo leer el estado actual (S5).',
    'The current state could not be read (S5).',
  ),
  SyncMutationFailureStage.localCommit => context.tr(
    'No se pudo confirmar el cambio local (S6).',
    'The local change could not be committed (S6).',
  ),
  null => context.tr(
    'Ocurrió un error local inesperado (N1).',
    'An unexpected local error occurred (N1).',
  ),
};

class _EditorSection extends StatelessWidget {
  const _EditorSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.palette.neutralSoft.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _PaintColorPicker extends StatelessWidget {
  const _PaintColorPicker({required this.color, required this.onChanged});

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;

  @override
  Widget build(BuildContext context) {
    final selectedColor = color.toColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 54,
              height: 42,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.palette.neutral),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _hexColor(selectedColor),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    context.tr(
                      'Toca el cuadro como en Paint',
                      'Tap the field like in Paint',
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
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            const height = 156.0;
            final size = Size(constraints.maxWidth, height);
            void update(Offset position) {
              final saturation = (position.dx / size.width).clamp(0.0, 1.0);
              final value = (1 - position.dy / size.height).clamp(0.0, 1.0);
              onChanged(
                color.withSaturation(saturation).withValue(value),
              );
            }

            return Semantics(
              label: context.tr(
                'Mezclador de intensidad y claridad',
                'Saturation and brightness mixer',
              ),
              hint: context.tr(
                'Arrastra para elegir el color',
                'Drag to choose a color',
              ),
              child: GestureDetector(
                key: const ValueKey('quick-note-color-field'),
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => update(details.localPosition),
                onPanUpdate: (details) => update(details.localPosition),
                child: CustomPaint(
                  size: size,
                  painter: _SaturationValuePainter(color: color),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            const height = 30.0;
            final size = Size(constraints.maxWidth, height);
            void update(double dx) {
              final hue = (dx / size.width * 360).clamp(0.0, 360.0);
              onChanged(color.withHue(hue));
            }

            return Semantics(
              label: context.tr('Tono del color', 'Color hue'),
              value: '${color.hue.round()}°',
              increasedValue: '${(color.hue + 10).clamp(0, 360).round()}°',
              decreasedValue: '${(color.hue - 10).clamp(0, 360).round()}°',
              onIncrease: () => onChanged(
                color.withHue((color.hue + 10).clamp(0, 360)),
              ),
              onDecrease: () => onChanged(
                color.withHue((color.hue - 10).clamp(0, 360)),
              ),
              child: GestureDetector(
                key: const ValueKey('quick-note-hue-strip'),
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => update(details.localPosition.dx),
                onPanUpdate: (details) => update(details.localPosition.dx),
                child: CustomPaint(
                  size: size,
                  painter: _HueStripPainter(hue: color.hue),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final preset in _quickNoteColorPresets)
              Tooltip(
                message: _hexColor(preset),
                child: InkResponse(
                  key: ValueKey('quick-note-color-${preset.toARGB32()}'),
                  radius: 22,
                  onTap: () => onChanged(HSVColor.fromColor(preset)),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: preset,
                      border: Border.all(
                        color: preset.toARGB32() == selectedColor.toARGB32()
                            ? context.palette.textPrimary
                            : context.palette.neutral,
                        width: preset.toARGB32() == selectedColor.toARGB32()
                            ? 3
                            : 1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SaturationValuePainter extends CustomPainter {
  const _SaturationValuePainter({required this.color});

  final HSVColor color;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final shape = RRect.fromRectAndRadius(bounds, const Radius.circular(10));
    canvas
      ..save()
      ..clipRRect(shape)
      ..drawRect(
        bounds,
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.white,
              HSVColor.fromAHSV(1, color.hue, 1, 1).toColor(),
            ],
          ).createShader(bounds),
      )
      ..drawRect(
        bounds,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black],
          ).createShader(bounds),
      )
      ..restore();
    final center = Offset(
      color.saturation * size.width,
      (1 - color.value) * size.height,
    );
    canvas
      ..drawCircle(center, 8, Paint()..color = Colors.black54)
      ..drawCircle(
        center,
        6,
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.fill,
      )
      ..drawCircle(
        center,
        6,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
  }

  @override
  bool shouldRepaint(_SaturationValuePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _HueStripPainter extends CustomPainter {
  const _HueStripPainter({required this.hue});

  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final shape = RRect.fromRectAndRadius(bounds, const Radius.circular(999));
    canvas
      ..save()
      ..clipRRect(shape)
      ..drawRect(
        bounds,
        Paint()
          ..shader = LinearGradient(
            colors: [
              for (var value = 0; value <= 360; value += 60)
                HSVColor.fromAHSV(1, value.toDouble(), 1, 1).toColor(),
            ],
          ).createShader(bounds),
      )
      ..restore();
    final center = Offset((hue / 360) * size.width, size.height / 2);
    canvas
      ..drawCircle(center, 10, Paint()..color = Colors.black45)
      ..drawCircle(
        center,
        8,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
  }

  @override
  bool shouldRepaint(_HueStripPainter oldDelegate) => oldDelegate.hue != hue;
}

const _quickNoteColorPresets = [
  Color(0xFFE76F51),
  Color(0xFFF4A261),
  Color(0xFFE9C46A),
  Color(0xFF6F8F68),
  Color(0xFF2A9D8F),
  Color(0xFF457B9D),
  Color(0xFF7251B5),
];

String _hexColor(Color color) {
  final value = color.toARGB32() & 0xFFFFFF;
  return '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

IconData _sortIcon(QuickNoteSort sort) => switch (sort) {
  QuickNoteSort.manual => Icons.drag_indicator_rounded,
  QuickNoteSort.priority => Icons.flag_rounded,
  QuickNoteSort.date => Icons.event_rounded,
  QuickNoteSort.recent => Icons.update_rounded,
  QuickNoteSort.color => Icons.palette_rounded,
};

String _sortLabel(BuildContext context, QuickNoteSort sort) => switch (sort) {
  QuickNoteSort.manual => context.tr('Orden manual', 'Manual order'),
  QuickNoteSort.priority => context.tr('Prioridad', 'Priority'),
  QuickNoteSort.date => context.tr('Fecha', 'Date'),
  QuickNoteSort.recent => context.tr('Más recientes', 'Most recent'),
  QuickNoteSort.color => context.tr('Color', 'Color'),
};

IconData _priorityIcon(QuickNotePriority priority) => switch (priority) {
  QuickNotePriority.high => Icons.keyboard_double_arrow_up_rounded,
  QuickNotePriority.medium => Icons.drag_handle_rounded,
  QuickNotePriority.low => Icons.keyboard_arrow_down_rounded,
};

String _priorityLabel(BuildContext context, QuickNotePriority priority) =>
    switch (priority) {
      QuickNotePriority.high => context.tr('Alta', 'High'),
      QuickNotePriority.medium => context.tr('Media', 'Medium'),
      QuickNotePriority.low => context.tr('Baja', 'Low'),
    };

String _shortDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/${date.year}';
