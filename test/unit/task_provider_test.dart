import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/models/task.dart';
import 'package:ffsc26_certif5/models/subtask.dart';
import 'package:ffsc26_certif5/repositories/task_repository.dart';
import 'package:ffsc26_certif5/providers/task_provider.dart';

void main() {
  group('TaskProvider Unit Tests', () {
    late TaskRepository repository;
    late TaskProvider provider;

    setUp(() {
      repository = TaskRepository(
        initialTasks: [
          Task(
            id: '1',
            title: 'Learn Flutter',
            description: 'State management and unit testing',
            category: TaskCategory.tech,
            priority: TaskPriority.high,
            dueDate: DateTime.now().add(const Duration(days: 1)),
            isCompleted: false,
            tags: const ['Flutter', 'Mobile'],
            createdAt: DateTime.now(),
          ),
          Task(
            id: '2',
            title: 'Buy Groceries',
            description: 'Fruit and vegetables',
            category: TaskCategory.personal,
            priority: TaskPriority.low,
            dueDate: DateTime.now().add(const Duration(days: 2)),
            isCompleted: true,
            tags: const ['Shopping'],
            createdAt: DateTime.now(),
          ),
          Task(
            id: '3',
            title: 'Prepare Exam',
            description: 'Study Dart and async operations',
            category: TaskCategory.study,
            priority: TaskPriority.medium,
            dueDate: DateTime.now().subtract(const Duration(days: 1)),
            isCompleted: false,
            tags: const ['Study', 'Dart'],
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ],
      );
      provider = TaskProvider(repository: repository);
    });

    test('Initial loading populates tasks correctly', () async {
      await provider.loadTasks();
      expect(provider.tasks.length, equals(3));
      expect(provider.totalCount, equals(3));
      expect(provider.completedCount, equals(1));
      expect(provider.pendingCount, equals(2));
      expect(provider.overdueCount, equals(1));
      expect(provider.completionPercentage, closeTo(0.333, 0.01));
    });

    test('Search filter filters tasks by query', () async {
      await provider.loadTasks();
      provider.setSearchQuery('Groceries');
      expect(provider.filteredTasks.length, equals(1));
      expect(provider.filteredTasks.first.id, equals('2'));

      provider.setSearchQuery('flutter');
      expect(provider.filteredTasks.length, equals(1));
      expect(provider.filteredTasks.first.id, equals('1'));
    });

    test('Category filter filters tasks by TaskCategory', () async {
      await provider.loadTasks();
      provider.setCategoryFilter(TaskCategory.tech);
      expect(provider.filteredTasks.length, equals(1));
      expect(provider.filteredTasks.first.category, equals(TaskCategory.tech));

      provider.setCategoryFilter(null);
      expect(provider.filteredTasks.length, equals(3));
    });

    test('Priority filter filters tasks by TaskPriority', () async {
      await provider.loadTasks();
      provider.setPriorityFilter(TaskPriority.high);
      expect(provider.filteredTasks.length, equals(1));
      expect(provider.filteredTasks.first.priority, equals(TaskPriority.high));
    });

    test('showOnlyCompleted filter toggle works properly', () async {
      await provider.loadTasks();
      provider.toggleShowOnlyCompleted();
      expect(provider.filteredTasks.length, equals(1));
      expect(provider.filteredTasks.first.isCompleted, isTrue);
    });

    test(
      'clearFilters resets search query and category/priority filters',
      () async {
        await provider.loadTasks();
        provider.setSearchQuery('Flutter');
        provider.setCategoryFilter(TaskCategory.tech);
        provider.setPriorityFilter(TaskPriority.high);

        expect(provider.filteredTasks.length, equals(1));

        provider.clearFilters();
        expect(provider.searchQuery, isEmpty);
        expect(provider.selectedCategory, isNull);
        expect(provider.selectedPriority, isNull);
        expect(provider.filteredTasks.length, equals(3));
      },
    );

    test(
      'addTask and deleteTask update provider state and notify listeners',
      () async {
        await provider.loadTasks();
        final newTask = Task(
          id: '4',
          title: 'New Task',
          description: 'Testing add',
          category: TaskCategory.work,
          priority: TaskPriority.high,
          dueDate: DateTime.now(),
          createdAt: DateTime.now(),
        );

        await provider.addTask(newTask);
        expect(provider.totalCount, equals(4));

        await provider.deleteTask('4');
        expect(provider.totalCount, equals(3));
      },
    );

    test(
      'addSubtask and toggleSubtaskCompletion update subtasks in provider',
      () async {
        await provider.loadTasks();
        const sub = Subtask(
          id: 's100',
          title: 'Provider Subtask',
          isCompleted: false,
        );
        await provider.addSubtask('1', sub);

        final task = provider.tasks.firstWhere((t) => t.id == '1');
        expect(task.subtasks.length, equals(1));

        await provider.toggleSubtaskCompletion('1', 's100');
        final updatedTask = provider.tasks.firstWhere((t) => t.id == '1');
        expect(updatedTask.subtasks.first.isCompleted, isTrue);
      },
    );
  });
}
