import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  static const routePath = '/calendar';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppCardPaddings.page,
      children: const [
        SizedBox(height: 24),
        _MonthCard(),
        SizedBox(height: 28),
        _EventsCard(),
      ],
    );
  }
}

class _MonthCard extends StatelessWidget {
  const _MonthCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppCardPaddings.spacious,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Octubre 2023',
                  style:
                      Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontSize: AppDesignTokens.sectionTitleFontSize,
                      ),
                ),
              ),
              const _ArrowButton(icon: Icons.chevron_left_rounded),
              const SizedBox(width: 10),
              const _ArrowButton(icon: Icons.chevron_right_rounded),
            ],
          ),
          const SizedBox(height: 32),
          const _CalendarGrid(),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: context.palette.neutralSoft),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid();

  @override
  Widget build(BuildContext context) {
    const labels = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    const days = [
      '26',
      '27',
      '28',
      '29',
      '30',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
    ];

    return Column(
      children: [
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.45,
          children: labels
              .map(
                (label) => Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          itemCount: days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 6,
            childAspectRatio: 0.56,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _DayCell(
              label: days[index],
              muted: index < 5,
              selected: days[index] == '5',
              highlighted: days[index] == '2' || days[index] == '13',
            );
          },
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.label,
    required this.muted,
    required this.selected,
    required this.highlighted,
  });

  final String label;
  final bool muted;
  final bool selected;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: highlighted
            ? palette.primaryMuted.withValues(alpha: 0.35)
            : palette.background.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected
              ? palette.primary
              : palette.neutralSoft.withValues(alpha: 0.6),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 12,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: muted
                    ? palette.neutral.withValues(alpha: 0.45)
                    : palette.textPrimary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          if (selected)
            Positioned(
              top: 44,
              child: Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: palette.primary),
                  const SizedBox(width: 6),
                  CircleAvatar(radius: 4, backgroundColor: palette.secondary),
                ],
              ),
            ),
          if (label == '2')
            Positioned(
              top: 48,
              child: Container(
                width: 22,
                height: 5,
                decoration: BoxDecoration(
                  color: palette.secondarySoft,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EventsCard extends StatelessWidget {
  const _EventsCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppCardPaddings.spacious,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Próximos Eventos',
                  style:
                      Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontSize: AppDesignTokens.sectionTitleFontSize,
                      ),
                ),
              ),
              Icon(
                Icons.add_circle_outline_rounded,
                color: context.palette.primary,
              ),
            ],
          ),
          const SizedBox(height: 28),
          const _EventRow(
            dayLabel: 'HOY',
            day: '05',
            title: 'Sesión de Enfoque\nProfundo',
            time: '09:00 - 11:30 AM',
            tag: 'PRODUCTIVIDAD',
          ),
          const SizedBox(height: 26),
          const _EventRow(
            dayLabel: 'MAÑ',
            day: '06',
            title: 'Revisión de Proyecto',
            time: '02:00 - 03:00 PM',
            tag: 'EQUIPO',
          ),
          const SizedBox(height: 26),
          const _EventRow(
            dayLabel: 'LUN',
            day: '09',
            title: 'Taller de Mindset',
            time: '10:00 AM',
            tag: 'BIENESTAR',
          ),
          const SizedBox(height: 28),
          Center(
            child: TextButton.icon(
              onPressed: null,
              label: const Text('Ver agenda completa'),
              icon: const Icon(Icons.arrow_forward_rounded),
              iconAlignment: IconAlignment.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.dayLabel,
    required this.day,
    required this.title,
    required this.time,
    required this.tag,
  });

  final String dayLabel;
  final String day;
  final String title;
  final String time;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Column(
            children: [
              Text(
                dayLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: palette.primary),
              ),
              Text(
                day,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 22),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: palette.neutralSoft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(
                        fontSize: AppDesignTokens.sectionTitleFontSize,
                      ),
                ),
                const SizedBox(height: 10),
                Text(time, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: tag == 'EQUIPO'
                        ? palette.secondarySoft.withValues(alpha: 0.45)
                        : palette.primaryMuted.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: tag == 'EQUIPO'
                          ? palette.secondary
                          : palette.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
