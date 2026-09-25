import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/models/task.dart';
import 'package:ffsc26_certif5/models/subtask.dart';

void main() {
  group('Task Model Tests', () {
    test('Task progress calculation with no subtasks', () {
      final incompleteTask = Task(
        id: '1',
        title: 'Test',
        description: 'Desc',
        category: TaskCategory.work,
        priority: TaskPriority.medium,
        dueDate: DateTime.now(),
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      final completedTask = incompleteTask.copyWith(isCompleted: true);

      expect(incompleteTask.progress, equals(0.0));
      expect(completedTask.progress, equals(1.0));
    });

    test('Task progress calculation with subtasks', () {
      final taskWithSubtasks = Task(
        id: '1',
        title: 'Test with subtasks',
        description: 'Desc',
        category: TaskCategory.tech,
        priority: TaskPriority.high,
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
        subtasks: const [
          Subtask(id: 's1', title: 'Sub 1', isCompleted: true),
          Subtask(id: 's2', title: 'Sub 2', isCompleted: false),
          Subtask(id: 's3', title: 'Sub 3', isCompleted: true),
          Subtask(id: 's4', title: 'Sub 4', isCompleted: false),
        ],
      );

      expect(taskWithSubtasks.progress, equals(0.5));
    });

    test('Task isOverdue getter check', () {
      final overdueTask = Task(
        id: '1',
        title: 'Overdue Task',
        description: 'Desc',
        category: TaskCategory.work,
        priority: TaskPriority.high,
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
        isCompleted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      );

      final futureTask = overdueTask.copyWith(
        dueDate: DateTime.now().add(const Duration(days: 2)),
      );

      final completedOverdueTask = overdueTask.copyWith(isCompleted: true);

      expect(overdueTask.isOverdue, isTrue);
      expect(futureTask.isOverdue, isFalse);
      expect(completedOverdueTask.isOverdue, isFalse);
    });

    test('Task serialization toJson and fromJson', () {
      final originalTask = Task(
        id: '101',
        title: 'JSON Task',
        description: 'Serialization check',
        category: TaskCategory.study,
        priority: TaskPriority.medium,
        dueDate: DateTime(2026, 5, 15),
        isCompleted: false,
        tags: const ['Flutter', 'Test'],
        subtasks: const [
          Subtask(id: 'sub1', title: 'Sub task item', isCompleted: true),
        ],
        createdAt: DateTime(2026, 1, 10),
      );

      final json = originalTask.toJson();
      final deserialized = Task.fromJson(json);

      expect(deserialized.id, equals(originalTask.id));
      expect(deserialized.title, equals(originalTask.title));
      expect(deserialized.category, equals(originalTask.category));
      expect(deserialized.priority, equals(originalTask.priority));
      expect(deserialized.tags, equals(originalTask.tags));
      expect(deserialized.subtasks.length, equals(1));
      expect(deserialized.subtasks.first.title, equals('Sub task item'));
    });

    test('Task.fromJson throws FormatException when id is missing or empty', () {
      expect(() => Task.fromJson({'title': 'No ID'}), throwsFormatException);
      expect(() => Task.fromJson({'id': '', 'title': 'Empty ID'}), throwsFormatException);
    });

    test('Task.fromJson throws FormatException when title is missing or empty', () {
      expect(() => Task.fromJson({'id': '1'}), throwsFormatException);
      expect(() => Task.fromJson({'id': '1', 'title': '   '}), throwsFormatException);
    });

    test('Task.fromJson throws FormatException when date fields are invalid', () {
      expect(
        () => Task.fromJson({'id': '1', 'title': 'Test', 'dueDate': 'invalid-date'}),
        throwsFormatException,
      );
      expect(
        () => Task.fromJson({'id': '1', 'title': 'Test', 'createdAt': 'invalid-date'}),
        throwsFormatException,
      );
    });
  });
}
