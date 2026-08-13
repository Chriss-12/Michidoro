import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/widgets/goal_date_range_dialog.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations.dart';

void main() {
  testWidgets('selects and applies an inclusive start and end date', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const _RangeDialogTestApp(locale: Locale('es')),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('goal-date-range-dialog')),
      findsOneWidget,
    );
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Fin'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('goal-range-start-field')));
    await tester.tap(
      find.byKey(const ValueKey('goal-range-day-2026-08-14')),
    );
    await tester.tap(
      find.byKey(const ValueKey('goal-range-day-2026-08-16')),
    );
    await tester.tap(find.byKey(const ValueKey('apply-goal-date-range')));
    await tester.pumpAndSettle();

    expect(find.text('14/08/2026 - 16/08/2026'), findsOneWidget);
    expect(find.byKey(const ValueKey('goal-date-range-dialog')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('fits English large text at the narrow portrait width', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const _RangeDialogTestApp(
        locale: Locale('en'),
        dark: true,
        largeText: true,
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Select period'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('End'), findsOneWidget);
    expect(find.text('Apply'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _RangeDialogTestApp extends StatelessWidget {
  const _RangeDialogTestApp({
    required this.locale,
    this.dark = false,
    this.largeText = false,
  });

  final Locale locale;
  final bool dark;
  final bool largeText;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.fromPreset(
      dark ? AppThemePreset.graphiteNight : AppThemePreset.natureFocus,
      isDark: dark,
      fontScale: largeText ? AppTypography.maxFontScale : 1,
    );
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme,
      home: _RangeLauncher(locale: locale),
    );
  }
}

class _RangeLauncher extends StatefulWidget {
  const _RangeLauncher({required this.locale});

  final Locale locale;

  @override
  State<_RangeLauncher> createState() => _RangeLauncherState();
}

class _RangeLauncherState extends State<_RangeLauncher> {
  DateTimeRange? _range;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(
            onPressed: _open,
            child: Text(widget.locale.languageCode == 'en' ? 'Open' : 'Abrir'),
          ),
          if (_range != null)
            Text('${_format(_range!.start)} - ${_format(_range!.end)}'),
        ],
      ),
    ),
  );

  Future<void> _open() async {
    final range = await showGoalDateRangeDialog(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030, 12, 31),
      initialDateRange: DateTimeRange(
        start: DateTime(2026, 8, 10),
        end: DateTime(2026, 8, 12),
      ),
    );
    if (range != null && mounted) setState(() => _range = range);
  }
}

String _format(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/${date.year}';
