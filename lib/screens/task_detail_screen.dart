import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../l10n/app_localizations.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TextEditingController _subtaskController = TextEditingController();

  @override
  void dispose() {
    _subtaskController.dispose();
    super.dispose();
  }

  void _showAddSubtaskDialog(BuildContext context, TaskProvider taskProvider) {
    final l10n = AppLocalizations.of(context);
    _subtaskController.clear();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addSubtask),
        content: TextField(
          controller: _subtaskController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.subtaskTitle,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final title = _subtaskController.text.trim();
              if (title.isNotEmpty) {
                final subtask = Subtask(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title,
                );
                taskProvider.addSubtask(widget.taskId, subtask);
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final taskProvider = context.watch<TaskProvider>();
    final taskList = taskProvider.tasks
        .where((t) => t.id == widget.taskId)
        .toList();

    if (taskList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.taskDetail)),
        body: Center(child: Text(l10n.noTasksFound)),
      );
    }

    final task = taskList.first;
    final formattedDate = DateFormat('dd MMMM yyyy').format(task.dueDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.taskDetail),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: l10n.editTask,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskFormScreen(taskToEdit: task),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: l10n.delete,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.delete),
                  content: Text(l10n.deleteConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n.cancel),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.delete),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await taskProvider.deleteTask(task.id);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Status Checkbox & Title
            Row(
              children: [
                Semantics(
                  label: 'Toggle task status',
                  checked: task.isCompleted,
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) =>
                        taskProvider.toggleTaskCompletion(task.id),
                  ),
                ),
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Tags & Metadata Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.category,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Chip(label: Text(l10n.categoryName(task.category))),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.priority,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          l10n.priorityName(task.priority),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: task.priority == TaskPriority.high
                                ? Colors.red
                                : task.priority == TaskPriority.medium
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.dueDate,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: task.isOverdue ? Colors.red : null,
                            fontWeight: task.isOverdue ? FontWeight.bold : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Description
            if (task.description.isNotEmpty) ...[
              Text(
                l10n.description,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(task.description),
              ),
              const SizedBox(height: 16),
            ],
            // Subtasks Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.subtasks,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _showAddSubtaskDialog(context, taskProvider),
                  tooltip: l10n.addSubtask,
                ),
              ],
            ),
            if (task.subtasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Aucune sous-tâche pour le moment.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
            else ...[
              LinearProgressIndicator(
                value: task.progress,
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 8),
              ...task.subtasks.map((sub) {
                return CheckboxListTile(
                  title: Text(
                    sub.title,
                    style: TextStyle(
                      decoration: sub.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  value: sub.isCompleted,
                  onChanged: (_) {
                    taskProvider.toggleSubtaskCompletion(task.id, sub.id);
                  },
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
