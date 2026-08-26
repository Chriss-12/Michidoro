import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task_temporal_filter.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/task_temporal_filter_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum TaskFilter { all, active, completed }

enum TaskProgressBand { red, yellow, green, strongGreen }

class TaskStatusSummary {
  const TaskStatusSummary({
    required this.listed,
    required this.inProgress,
    required this.completed,
  });

  factory TaskStatusSummary.fromTasks(Iterable<Task> tasks) {
    var listed = 0;
    var inProgress = 0;
    var completed = 0;

    for (final task in tasks) {
      switch (task.status) {
        case TaskStatus.listed:
          listed += 1;
        case TaskStatus.inProgress:
          inProgress += 1;
        case TaskStatus.completed:
          completed += 1;
      }
    }

    return TaskStatusSummary(
      listed: listed,
      inProgress: inProgress,
      completed: completed,
    );
  }

  final int listed;
  final int inProgress;
  final int completed;

  int get total => listed + inProgress + completed;
  double get completionRatio => total == 0 ? 0 : completed / total;
}

class DailyTaskProgress {
  const DailyTaskProgress({
    required this.day,
    required this.summary,
    required this.isEnded,
  });

  final DateTime day;
  final TaskStatusSummary summary;
  final bool isEnded;

  double get completionRatio => summary.completionRatio;
  TaskProgressBand get band => taskProgressBandForRatio(completionRatio);
}

TaskProgressBand taskProgressBandForRatio(double ratio) {
  if (ratio <= 0.2) {
    return TaskProgressBand.red;
  }

  if (ratio <= 0.5) {
    return TaskProgressBand.yellow;
  }

  if (ratio <= 0.7) {
    return TaskProgressBand.green;
  }

  return TaskProgressBand.strongGreen;
}

class TasksController {
  TasksController({
    required TasksRepository repository,
    TaskTemporalFilterRepository? temporalFilterRepository,
    DateTime Function()? now,
  }) : _repository = repository,
       _temporalFilterRepository = temporalFilterRepository,
       temporalFilter = signal(TaskTemporalFilter.day((now ?? DateTime.now)()));

  final TasksRepository _repository;
  final TaskTemporalFilterRepository? _temporalFilterRepository;
  Future<void>? _temporalFilterLoad;
  final FlutterSignal<List<Task>> tasks = signal(const []);
  final FlutterSignal<TaskFilter> filter = signal(TaskFilter.all);
  final FlutterSignal<TaskTemporalFilter> temporalFilter;
  final FlutterSignal<Set<String>> endedDayKeys = signal(const {});
  final FlutterSignal<String?> validationMessage = signal(null);
  final FlutterSignal<bool> isLoading = signal(false);
  late final Computed<List<Task>> temporallyFilteredTasks =
      computed<List<Task>>(
        () => tasks.value
            .where(temporalFilter.value.includes)
            .toList(growable: false),
      );
  late final Computed<List<Task>> filteredTasks = computed<List<Task>>(() {
    final currentTasks = temporallyFilteredTasks.value;

    return switch (filter.value) {
      TaskFilter.all => currentTasks,
      TaskFilter.active =>
        currentTasks.where((task) => !task.isCompleted).toList(growable: false),
      TaskFilter.completed =>
        currentTasks.where((task) => task.isCompleted).toList(growable: false),
    };
  });
  late final Computed<TaskStatusSummary> allTaskSummary =
      computed<TaskStatusSummary>(
        () => TaskStatusSummary.fromTasks(tasks.value),
      );

  TaskFilter get selectedFilter => filter.value;
  TaskTemporalFilter get selectedTemporalFilter => temporalFilter.value;

  Future<void> loadTasks() async {
    isLoading.value = true;
    await (_temporalFilterLoad ??= _loadTemporalFilter());
    tasks.value = await _repository.loadTasks();
    isLoading.value = false;
  }

  List<Task> tasksForDay(DateTime day) {
    return tasks.value
        .where(
          (task) =>
              task.scheduledDate != null && _sameDate(task.scheduledDate!, day),
        )
        .toList(growable: false);
  }

  TaskStatusSummary summaryForDay(DateTime day) {
    return TaskStatusSummary.fromTasks(tasksForDay(day));
  }

  DailyTaskProgress progressForDay(DateTime day) {
    final normalized = _normalizeDate(day);

    return DailyTaskProgress(
      day: normalized,
      summary: summaryForDay(normalized),
      isEnded: endedDayKeys.value.contains(_dateKey(normalized)),
    );
  }

  List<DailyTaskProgress> progressForWeek(DateTime day) {
    final normalized = _normalizeDate(day);
    final start = normalized.subtract(Duration(days: normalized.weekday - 1));

    return List.generate(
      7,
      (index) => progressForDay(start.add(Duration(days: index))),
    );
  }

  List<Task> quickTasks() {
    return tasks.value
        .where((task) => task.scheduledDate == null)
        .toList(growable: false);
  }

  List<Task> tasksForGoal(String goalId) {
    return tasks.value
        .where((task) => task.goalId == goalId)
        .toList(growable: false);
  }

  TaskStatusSummary summaryForGoal(String goalId) {
    return TaskStatusSummary.fromTasks(tasksForGoal(goalId));
  }

  TaskStatusSummary unassignedSummary() {
    return TaskStatusSummary.fromTasks(
      tasks.value.where((task) => task.goalId == null),
    );
  }

  Set<int> plannedDaysForMonth(DateTime month) {
    return tasks.value
        .where(
          (task) =>
              task.scheduledDate != null &&
              task.scheduledDate!.year == month.year &&
              task.scheduledDate!.month == month.month,
        )
        .map((task) => task.scheduledDate!.day)
        .toSet();
  }

  Map<int, DailyTaskProgress> progressByDayForMonth(DateTime month) {
    final monthTasks = tasks.value.where(
      (task) =>
          task.scheduledDate != null &&
          task.scheduledDate!.year == month.year &&
          task.scheduledDate!.month == month.month,
    );
    final summaries = <int, List<Task>>{};

    for (final task in monthTasks) {
      final day = task.scheduledDate!.day;
      summaries.putIfAbsent(day, () => <Task>[]).add(task);
    }

    return {
      for (final entry in summaries.entries)
        entry.key: DailyTaskProgress(
          day: DateTime(month.year, month.month, entry.key),
          summary: TaskStatusSummary.fromTasks(entry.value),
          isEnded: endedDayKeys.value.contains(
            _dateKey(DateTime(month.year, month.month, entry.key)),
          ),
        ),
    };
  }

  Future<bool> createTask(String rawTitle) async {
    final title = rawTitle.trim();

    if (title.isEmpty) {
      validationMessage.value = 'Escribe un titulo para guardar la tarea.';
      return false;
    }

    final task = await _repository.createTask(title);

    tasks.value = [task, ...tasks.value];
    validationMessage.value = null;
    return true;
  }

  Future<bool> createPlannedTask({
    required String rawTitle,
    required DateTime scheduledDate,
    String? goalId,
    int? durationMinutes,
  }) async {
    final title = rawTitle.trim();

    if (title.isEmpty) {
      validationMessage.value = 'Escribe un titulo para guardar la tarea.';
      return false;
    }

    final task = await _repository.createPlannedTask(
      title: title,
      scheduledDate: scheduledDate,
      goalId: goalId,
      durationMinutes: durationMinutes,
    );

    tasks.value = [task, ...tasks.value];
    validationMessage.value = null;
    return true;
  }

  Future<bool> updateTaskTitle(String id, String rawTitle) async {
    final title = rawTitle.trim();

    if (title.isEmpty) {
      validationMessage.value = 'Escribe un titulo para guardar la tarea.';
      return false;
    }

    final updatedTask = await _repository.updateTaskTitle(id, title);
    if (updatedTask == null) {
      return false;
    }

    _replaceTask(updatedTask);
    validationMessage.value = null;
    return true;
  }

  Future<void> toggleTaskCompletion(String id) async {
    final updatedTask = await _repository.toggleTaskCompletion(id);
    if (updatedTask == null) {
      return;
    }

    _replaceTask(updatedTask);
  }

  Future<void> updateTaskStatus(String id, TaskStatus status) async {
    final updatedTask = await _repository.updateTaskStatus(id, status);
    if (updatedTask == null) {
      return;
    }

    _replaceTask(updatedTask);
  }

  Future<void> scheduleTask(String id, DateTime? scheduledDate) async {
    final updatedTask = await _repository.scheduleTask(id, scheduledDate);
    if (updatedTask == null) {
      return;
    }

    _replaceTask(updatedTask);
  }

  Future<void> assignTaskToGoal(String id, String? goalId) async {
    final updatedTask = await _repository.assignTaskToGoal(id, goalId);
    if (updatedTask == null) {
      return;
    }

    _replaceTask(updatedTask);
  }

  Future<bool> updateTaskPlanning({
    required String id,
    required String? goalId,
    required int durationMinutes,
  }) async {
    if (durationMinutes <= 0 || durationMinutes > 24 * 60) {
      validationMessage.value =
          'La duracion debe estar entre 1 y 1440 minutos.';
      return false;
    }

    final updatedTask = await _repository.updateTaskPlanning(
      id: id,
      goalId: goalId,
      durationMinutes: durationMinutes,
    );
    if (updatedTask == null) {
      validationMessage.value = 'No se pudo actualizar la tarea.';
      return false;
    }

    _replaceTask(updatedTask);
    validationMessage.value = null;
    return true;
  }

  Future<void> moveTaskToDay({
    required String id,
    required DateTime scheduledDate,
    String? goalId,
  }) async {
    final scheduledTask = await _repository.scheduleTask(id, scheduledDate);
    if (scheduledTask == null) {
      return;
    }

    final assignedTask = await _repository.assignTaskToGoal(id, goalId);
    _replaceTask(assignedTask ?? scheduledTask.copyWith(goalId: goalId));
  }

  Future<void> detachTasksFromGoal(String goalId) async {
    final affectedTasks = tasksForGoal(goalId);
    for (final task in affectedTasks) {
      final updatedTask = await _repository.assignTaskToGoal(task.id, null);
      if (updatedTask != null) {
        _replaceTask(updatedTask);
      }
    }
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    tasks.value = tasks.value
        .where((task) => task.id != id)
        .toList(growable: false);
  }

  void endDay(DateTime day) {
    final key = _dateKey(day);
    endedDayKeys.value = {...endedDayKeys.value, key};
  }

  set selectedFilter(TaskFilter value) {
    filter.value = value;
  }

  Future<void> selectTemporalFilter(TaskTemporalFilter value) async {
    await (_temporalFilterLoad ??= _loadTemporalFilter());
    temporalFilter.value = value;
    await _temporalFilterRepository?.save(value);
  }

  void clearValidationMessage() {
    if (validationMessage.value == null) {
      return;
    }

    validationMessage.value = null;
  }

  void _replaceTask(Task updatedTask) {
    tasks.value = [
      for (final task in tasks.value)
        if (task.id == updatedTask.id) updatedTask else task,
    ];
  }

  Future<void> _loadTemporalFilter() async {
    final stored = await _temporalFilterRepository?.load();
    if (stored != null) temporalFilter.value = stored;
  }
}

bool _sameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String _dateKey(DateTime date) {
  final normalized = _normalizeDate(date);

  return '${normalized.year.toString().padLeft(4, "0")}-'
      '${normalized.month.toString().padLeft(2, "0")}-'
      '${normalized.day.toString().padLeft(2, "0")}';
}
