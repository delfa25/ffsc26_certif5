import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/models/task.dart';
import 'package:ffsc26_certif5/models/subtask.dart';
import 'package:ffsc26_certif5/repositories/task_repository.dart';

void main() {
  group('TaskRepository Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository(initialTasks: []);
    });

    test(
      'Initial repository should be empty when initialized with empty list',
      () async {
        final tasks = await repository.getTasks();
        expect(tasks, isEmpty);
      },
    );

    test(
      'Default seeding populates initial tasks when no parameter is passed',
      () async {
        final defaultRepo = TaskRepository();
        final tasks = await defaultRepo.getTasks();
        expect(tasks, isNotEmpty);
        expect(tasks.length, equals(5));
      },
    );

    test('addTask adds a new task successfully', () async {
      final task = Task(
        id: 'repo_1',
        title: 'Repository Task',
        description: 'Testing Repo',
        category: TaskCategory.tech,
        priority: TaskPriority.high,
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final added = await repository.addTask(task);
      final tasks = await repository.getTasks();

      expect(added.id, equals('repo_1'));
      expect(tasks.length, equals(1));
      expect(tasks.first.title, equals('Repository Task'));
    });

    test('updateTask modifies existing task details', () async {
      final task = Task(
        id: 'repo_1',
        title: 'Original Title',
        description: 'Original Desc',
        category: TaskCategory.personal,
        priority: TaskPriority.low,
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await repository.addTask(task);
      final updatedTask = task.copyWith(title: 'Updated Title');
      await repository.updateTask(updatedTask);

      final tasks = await repository.getTasks();
      expect(tasks.first.title, equals('Updated Title'));
    });

    test('deleteTask removes task from repository', () async {
      final task = Task(
        id: 'del_1',
        title: 'Task to delete',
        description: 'Desc',
        category: TaskCategory.work,
        priority: TaskPriority.medium,
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await repository.addTask(task);
      expect((await repository.getTasks()).length, equals(1));

      await repository.deleteTask('del_1');
      expect((await repository.getTasks()).length, equals(0));
    });

    test('toggleTaskCompletion toggles status and subtasks', () async {
      final task = Task(
        id: 'toggle_1',
        title: 'Toggle Task',
        description: 'Desc',
        category: TaskCategory.work,
        priority: TaskPriority.medium,
        dueDate: DateTime.now(),
        isCompleted: false,
        subtasks: const [
          Subtask(id: 's1', title: 'Subtask 1', isCompleted: false),
        ],
        createdAt: DateTime.now(),
      );

      await repository.addTask(task);
      final toggled = await repository.toggleTaskCompletion('toggle_1');

      expect(toggled.isCompleted, isTrue);
      expect(toggled.subtasks.first.isCompleted, isTrue);
    });

    test(
      'addSubtask and toggleSubtaskCompletion update task properly',
      () async {
        final task = Task(
          id: 'sub_task_1',
          title: 'Main Task',
          description: 'Desc',
          category: TaskCategory.tech,
          priority: TaskPriority.high,
          dueDate: DateTime.now(),
          createdAt: DateTime.now(),
        );

        await repository.addTask(task);
        const subtask = Subtask(
          id: 'sub_1',
          title: 'New Subtask',
          isCompleted: false,
        );
        final updatedTask = await repository.addSubtask('sub_task_1', subtask);

        expect(updatedTask.subtasks.length, equals(1));
        expect(updatedTask.subtasks.first.title, equals('New Subtask'));

        final afterToggle = await repository.toggleSubtaskCompletion(
          'sub_task_1',
          'sub_1',
        );
        expect(afterToggle.subtasks.first.isCompleted, isTrue);
        expect(afterToggle.isCompleted, isTrue);
      },
    );
  });
}
