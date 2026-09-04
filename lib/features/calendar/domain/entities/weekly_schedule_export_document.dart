class WeeklyScheduleExportDocument {
  const WeeklyScheduleExportDocument({
    required this.weekStart,
    required this.generatedAt,
    required this.isEnglish,
    required this.activities,
    required this.goals,
  });

  final DateTime weekStart;
  final DateTime generatedAt;
  final bool isEnglish;
  final List<WeeklyScheduleExportActivity> activities;
  final List<WeeklyScheduleExportGoal> goals;

  DateTime get weekEnd => weekStart.add(const Duration(days: 6));
}

class WeeklyScheduleExportActivity {
  const WeeklyScheduleExportActivity({
    required this.localDate,
    required this.routineName,
    required this.title,
    required this.startMinute,
    required this.durationMinutes,
    required this.statusLabel,
    required this.colorKey,
    required this.customColorArgb,
    required this.hasOverlap,
  });

  final DateTime localDate;
  final String routineName;
  final String title;
  final int startMinute;
  final int durationMinutes;
  final String statusLabel;
  final String colorKey;
  final int? customColorArgb;
  final bool hasOverlap;

  int get endMinute => startMinute + durationMinutes;
}

class WeeklyScheduleExportGoal {
  const WeeklyScheduleExportGoal({
    required this.targetDate,
    required this.title,
    required this.completedTasks,
    required this.totalTasks,
  });

  final DateTime targetDate;
  final String title;
  final int completedTasks;
  final int totalTasks;
}
