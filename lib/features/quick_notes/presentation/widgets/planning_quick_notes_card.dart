import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/quick_notes/domain/entities/quick_note.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';

class PlanningQuickNotesCard extends StatelessWidget {
  const PlanningQuickNotesCard({
    required this.notes,
    required this.onToggle,
    super.key,
  });

  final List<QuickNote> notes;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      key: const ValueKey('planning-quick-notes-card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sticky_note_2_rounded, color: context.palette.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.tr('Notas del día', 'Notes for the day'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.palette.primaryMuted,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Text(
                    '${notes.length}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: context.palette.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < notes.length; index++) ...[
            _PlanningNoteRow(
              note: notes[index],
              onToggle: () => onToggle(notes[index].id),
            ),
            if (index < notes.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _PlanningNoteRow extends StatelessWidget {
  const _PlanningNoteRow({required this.note, required this.onToggle});

  final QuickNote note;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = Color(note.colorArgb);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          color.withValues(alpha: 0.11),
          context.palette.surface,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 5)),
      ),
      child: Row(
        children: [
          Checkbox(value: note.isCompleted, onChanged: (_) => onToggle()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
              child: Text(
                note.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: note.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: note.isCompleted
                      ? context.palette.textSecondary
                      : context.palette.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
