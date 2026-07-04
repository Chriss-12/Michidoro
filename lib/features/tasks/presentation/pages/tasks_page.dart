import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/entities/task.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  static const routePath = '/tasks';

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController _titleController = TextEditingController();
  final TasksController _tasksController = serviceLocator<TasksController>();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _createTask() async {
    final created = await _tasksController.createTask(_titleController.text);
    if (created) {
      _titleController.clear();
      if (!mounted) {
        return;
      }

      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SignalBuilder(
      builder: (context) {
        final tasks = _tasksController.tasks.value;
        final visibleTasks = _tasksController.filteredTasks.value;
        final filter = _tasksController.filter.value;
        final validationMessage = _tasksController.validationMessage.value;

        return ListView(
          padding: AppCardPaddings.page,
          children: [
            const SizedBox(height: 24),
            Text(
              'Mis tareas',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: AppDesignTokens.mainTitleFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Organiza lo importante de hoy',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            GlassCard(
              padding: AppCardPaddings.compact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Nueva tarea',
                      hintText: 'Ej. Revisar avance del proyecto',
                      errorText: validationMessage,
                      prefixIcon: const Icon(Icons.add_task_rounded),
                    ),
                    onChanged: (_) => _tasksController.clearValidationMessage(),
                    onSubmitted: (_) => _createTask(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _createTask,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Agregar tarea'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (tasks.isNotEmpty) ...[
              _TaskFilterBar(
                selectedFilter: filter,
                tasks: tasks,
                onFilterChanged: (value) =>
                    _tasksController.selectedFilter = value,
              ),
              const SizedBox(height: 18),
            ],
            GlassCard(
              child: tasks.isEmpty
                  ? const _EmptyTasksState()
                  : _TaskList(
                      filter: filter,
                      tasks: visibleTasks,
                      onToggleCompleted: _tasksController.toggleTaskCompletion,
                      onEdit: _showEditTaskDialog,
                      onDelete: _confirmDeleteTask,
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _TaskFilterBar extends StatelessWidget {
  const _TaskFilterBar({
    required this.selectedFilter,
    required this.tasks,
    required this.onFilterChanged,
  });

  final TaskFilter selectedFilter;
  final List<Task> tasks;
  final ValueChanged<TaskFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final activeCount = tasks.where((task) => !task.isCompleted).length;
    final completedCount = tasks.length - activeCount;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<TaskFilter>(
        segments: [
          ButtonSegment(
            value: TaskFilter.all,
            label: Text('Todas (${tasks.length})'),
          ),
          ButtonSegment(
            value: TaskFilter.active,
            label: Text('Activas ($activeCount)'),
          ),
          ButtonSegment(
            value: TaskFilter.completed,
            label: Text('Hechas ($completedCount)'),
          ),
        ],
        selected: {selectedFilter},
        showSelectedIcon: false,
        onSelectionChanged: (selection) => onFilterChanged(selection.first),
      ),
    );
  }
}

class _EmptyTasksState extends StatelessWidget {
  const _EmptyTasksState();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
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
          'Sin tareas todavia',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: AppDesignTokens.sectionTitleFontSize,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Agrega tu primera tarea para empezar a planificar el dia.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: palette.textSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.filter,
    required this.tasks,
    required this.onToggleCompleted,
    required this.onEdit,
    required this.onDelete,
  });

  final TaskFilter filter;
  final List<Task> tasks;
  final Future<void> Function(String id) onToggleCompleted;
  final ValueChanged<Task> onEdit;
  final Future<void> Function(Task task) onDelete;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _FilteredEmptyState(filter: filter);
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tareas de hoy',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppDesignTokens.sectionTitleFontSize,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${tasks.length}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.palette.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final task in tasks) ...[
          _TaskTile(
            task: task,
            onToggleCompleted: () => onToggleCompleted(task.id),
            onEdit: () => onEdit(task),
            onDelete: () => onDelete(task),
          ),
          if (task != tasks.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _FilteredEmptyState extends StatelessWidget {
  const _FilteredEmptyState({required this.filter});

  final TaskFilter filter;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final label = switch (filter) {
      TaskFilter.all => 'No hay tareas para mostrar.',
      TaskFilter.active => 'No quedan tareas activas.',
      TaskFilter.completed => 'Todavia no completaste tareas.',
    };

    return Column(
      children: [
        Icon(Icons.inbox_outlined, color: palette.textSecondary, size: 42),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: palette.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onToggleCompleted,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggleCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 42,
            child: IconButton(
              tooltip: task.isCompleted
                  ? 'Marcar como activa'
                  : 'Marcar como completada',
              onPressed: onToggleCompleted,
              icon: Icon(
                task.isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: task.isCompleted ? palette.secondary : palette.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: task.isCompleted ? palette.textSecondary : null,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Editar tarea',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            tooltip: 'Eliminar tarea',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
    );
  }
}

extension on _TasksPageState {
  Future<void> _showEditTaskDialog(Task task) async {
    final title = await showDialog<String>(
      context: context,
      builder: (context) => _EditTaskDialog(initialTitle: task.title),
    );

    if (title == null) {
      return;
    }

    await _tasksController.updateTaskTitle(task.id, title);
  }

  Future<void> _confirmDeleteTask(Task task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar tarea'),
          content: Text('Eliminar "${task.title}" de la lista?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete ?? false) {
      await _tasksController.deleteTask(task.id);
    }
  }
}

class _EditTaskDialog extends StatefulWidget {
  const _EditTaskDialog({required this.initialTitle});

  final String initialTitle;

  @override
  State<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final title = _controller.text.trim();

    if (title.isEmpty) {
      setState(() {
        _errorText = 'Escribe un titulo para guardar la tarea.';
      });
      return;
    }

    Navigator.of(context).pop(title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar tarea'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Titulo',
          errorText: _errorText,
        ),
        textInputAction: TextInputAction.done,
        onChanged: (_) {
          if (_errorText == null) {
            return;
          }

          setState(() {
            _errorText = null;
          });
        },
        onSubmitted: (_) => _save(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save_rounded),
          label: const Text('Guardar'),
        ),
      ],
    );
  }
}
