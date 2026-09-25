import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../l10n/app_localizations.dart';
import 'optimized_image_widget.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  Color _getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return Colors.blue;
      case TaskCategory.personal:
        return Colors.purple;
      case TaskCategory.study:
        return Colors.teal;
      case TaskCategory.tech:
        return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final priorityColor = _getPriorityColor(task.priority);
    final categoryColor = _getCategoryColor(task.category);
    final formattedDate = DateFormat('dd MMM yyyy').format(task.dueDate);

    return Semantics(
      label: 'Task card for ${task.title}',
      hint: 'Tap to view task details',
      button: true,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: task.isOverdue
              ? const BorderSide(color: Colors.red, width: 1.5)
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      label: 'Task completion status checkbox',
                      checked: task.isCompleted,
                      child: Checkbox(
                        value: task.isCompleted,
                        onChanged: onToggle,
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        task.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                  color: task.isCompleted
                                      ? Colors.grey
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Optimized lazy-loaded avatar/image widget
                    OptimizedImageWidget(
                      imageUrl: task.imageUrl,
                      width: 32,
                      height: 32,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(width: 4),
                    Semantics(
                      label: l10n.delete,
                      hint: 'Delete task ${task.title}',
                      button: true,
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onPressed: onDelete,
                        tooltip: l10n.delete,
                      ),
                    ),
                  ],
                ),
                if (task.description.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 48.0,
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    child: Text(
                      task.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                if (task.subtasks.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 48.0,
                      right: 16.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: task.progress,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  task.progress == 1.0
                                      ? Colors.green
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(task.progress * 100).toInt()}%',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(left: 48.0),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Chip(
                        label: Text(
                          l10n.categoryName(task.category),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: categoryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: priorityColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: priorityColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          l10n.priorityName(task.priority),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: priorityColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color:
                                task.isOverdue ? Colors.red : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: task.isOverdue
                                  ? Colors.red
                                  : Colors.grey[600],
                              fontWeight: task.isOverdue
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
