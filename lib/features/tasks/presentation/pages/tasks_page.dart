import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  static const routePath = '/tasks';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return ListView(
      padding: AppCardPaddings.page,
      children: [
        const SizedBox(height: 24),
        GlassCard(
          padding: AppCardPaddings.compact,
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: palette.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search tasks...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: palette.neutral,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        GlassCard(
          child: Column(
            children: [
              CircleAvatar(
                radius: 56,
                backgroundColor: palette.primaryMuted,
                child: Icon(
                  Icons.checklist_rounded,
                  color: palette.primary,
                  size: 46,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'My Tasks',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Plan your daily tasks here.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: palette.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),
              GlassCard(
                padding: AppCardPaddings.compact,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: palette.tertiary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.lightbulb_outline_rounded,
                        color: palette.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pro tip',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Use the '+' button to add your first task.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
