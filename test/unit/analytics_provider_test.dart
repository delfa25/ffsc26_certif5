import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/models/task.dart';
import 'package:ffsc26_certif5/providers/analytics_provider.dart';

void main() {
  group('AnalyticsProvider Unit Tests', () {
    late AnalyticsProvider analytics;
    late List<Task> sampleTasks;

    setUp(() {
      analytics = AnalyticsProvider();
      sampleTasks = [
        Task(
          id: '1',
          title: 'Task 1',
          description: '',
          category: TaskCategory.work,
          priority: TaskPriority.high,
          dueDate: DateTime.now(),
          isCompleted: true,
          createdAt: DateTime.now(),
        ),
        Task(
          id: '2',
          title: 'Task 2',
          description: '',
          category: TaskCategory.work,
          priority: TaskPriority.medium,
          dueDate: DateTime.now(),
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Task(
          id: '3',
          title: 'Task 3',
          description: '',
          category: TaskCategory.tech,
          priority: TaskPriority.high,
          dueDate: DateTime.now(),
          isCompleted: true,
          createdAt: DateTime.now(),
        ),
      ];
    });

    test('getCategoryStats calculates correct totals and completion rates', () {
      final stats = analytics.getCategoryStats(sampleTasks);

      final workStat = stats.firstWhere((s) => s.category == TaskCategory.work);
      final techStat = stats.firstWhere((s) => s.category == TaskCategory.tech);
      final studyStat = stats.firstWhere(
        (s) => s.category == TaskCategory.study,
      );

      expect(workStat.totalTasks, equals(2));
      expect(workStat.completedTasks, equals(1));
      expect(workStat.completionRate, equals(0.5));

      expect(techStat.totalTasks, equals(1));
      expect(techStat.completedTasks, equals(1));
      expect(techStat.completionRate, equals(1.0));

      expect(studyStat.totalTasks, equals(0));
      expect(studyStat.completedTasks, equals(0));
      expect(studyStat.completionRate, equals(0.0));
    });

    test('getPriorityDistribution returns accurate count per priority', () {
      final dist = analytics.getPriorityDistribution(sampleTasks);

      expect(dist[TaskPriority.high], equals(2));
      expect(dist[TaskPriority.medium], equals(1));
      expect(dist[TaskPriority.low], equals(0));
    });

    test('calculateOverallScore calculates correct score', () {
      final score = analytics.calculateOverallScore(sampleTasks);
      // 2 out of 3 completed = 66.666...% -> rounded to 67
      expect(score, equals(67.0));

      expect(analytics.calculateOverallScore([]), equals(0.0));
    });
  });
}
