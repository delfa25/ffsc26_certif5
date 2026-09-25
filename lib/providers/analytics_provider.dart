import '../models/task.dart';

class CategoryStat {
  final TaskCategory category;
  final int totalTasks;
  final int completedTasks;

  const CategoryStat({
    required this.category,
    required this.totalTasks,
    required this.completedTasks,
  });

  double get completionRate =>
      totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
}

class AnalyticsProvider {
  List<CategoryStat> getCategoryStats(List<Task> tasks) {
    return TaskCategory.values.map((cat) {
      final categoryTasks = tasks.where((t) => t.category == cat).toList();
      final completed = categoryTasks.where((t) => t.isCompleted).length;
      return CategoryStat(
        category: cat,
        totalTasks: categoryTasks.length,
        completedTasks: completed,
      );
    }).toList();
  }

  Map<TaskPriority, int> getPriorityDistribution(List<Task> tasks) {
    final map = <TaskPriority, int>{
      TaskPriority.high: 0,
      TaskPriority.medium: 0,
      TaskPriority.low: 0,
    };
    for (final task in tasks) {
      map[task.priority] = (map[task.priority] ?? 0) + 1;
    }
    return map;
  }

  double calculateOverallScore(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completedCount = tasks.where((t) => t.isCompleted).length;
    final rate = completedCount / tasks.length;
    return (rate * 100).roundToDouble();
  }
}
