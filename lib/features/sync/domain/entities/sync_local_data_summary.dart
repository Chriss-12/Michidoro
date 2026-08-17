class SyncLocalDataSummary {
  const SyncLocalDataSummary({
    required this.goals,
    required this.tasks,
    required this.calendarEvents,
    required this.focusSessions,
    required this.taskCompletionEvents,
    required this.routines,
    required this.routineRuns,
  });

  const SyncLocalDataSummary.empty()
    : goals = 0,
      tasks = 0,
      calendarEvents = 0,
      focusSessions = 0,
      taskCompletionEvents = 0,
      routines = 0,
      routineRuns = 0;

  final int goals;
  final int tasks;
  final int calendarEvents;
  final int focusSessions;
  final int taskCompletionEvents;
  final int routines;
  final int routineRuns;

  int get totalRecords =>
      goals +
      tasks +
      calendarEvents +
      focusSessions +
      taskCompletionEvents +
      routines +
      routineRuns;

  bool get hasUserData => totalRecords > 0;
}
