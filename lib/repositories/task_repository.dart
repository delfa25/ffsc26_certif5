import 'dart:convert';
import '../models/task.dart';
import '../models/subtask.dart';

abstract class ITaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> addTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<Task> toggleTaskCompletion(String id);
  Future<Task> addSubtask(String taskId, Subtask subtask);
  Future<Task> toggleSubtaskCompletion(String taskId, String subtaskId);
}

class TaskRepository implements ITaskRepository {
  final List<Task> _tasks = [];
  bool _initialized = false;

  TaskRepository({List<Task>? initialTasks}) {
    if (initialTasks != null) {
      _tasks.addAll(initialTasks);
      _initialized = true;
    }
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    try {
      // Seed default tasks if empty
      if (_tasks.isEmpty) {
        _seedDefaultTasks();
      }
      _initialized = true;
    } catch (e) {
      throw Exception('Failed to initialize task repository: $e');
    }
  }

  void _seedDefaultTasks() {
    final now = DateTime.now();
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Complete Certification Project',
        description:
            'Implement 5 screens, unit & widget tests, CI/CD pipeline and clean architecture.',
        category: TaskCategory.tech,
        priority: TaskPriority.high,
        dueDate: now.add(const Duration(days: 2)),
        isCompleted: false,
        subtasks: const [
          Subtask(
            id: 's1',
            title: 'Setup project architecture',
            isCompleted: true,
          ),
          Subtask(id: 's2', title: 'Write 10 unit tests', isCompleted: true),
          Subtask(
            id: 's3',
            title: 'Write widget & integration tests',
            isCompleted: false,
          ),
          Subtask(
            id: 's4',
            title: 'Configure GitHub Actions CI/CD',
            isCompleted: false,
          ),
        ],
        tags: const ['Flutter', 'Certification', 'CI/CD'],
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: '2',
        title: 'Review Code Quality & Linting',
        description:
            'Ensure flutter analyze passes without warnings and all const constructors are used.',
        category: TaskCategory.work,
        priority: TaskPriority.high,
        dueDate: now.add(const Duration(days: 1)),
        isCompleted: true,
        subtasks: const [
          Subtask(id: 's5', title: 'Run flutter analyze', isCompleted: true),
          Subtask(
            id: 's6',
            title: 'Fix all warning messages',
            isCompleted: true,
          ),
        ],
        tags: const ['Linter', 'Quality'],
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Task(
        id: '3',
        title: 'Design Dark Mode Theme',
        description:
            'Support Material 3 dark/light dynamic theme with smooth contrast.',
        category: TaskCategory.tech,
        priority: TaskPriority.medium,
        dueDate: now.add(const Duration(days: 4)),
        isCompleted: false,
        subtasks: const [
          Subtask(id: 's7', title: 'Create ThemeProvider', isCompleted: true),
          Subtask(
            id: 's8',
            title: 'Test high contrast ratio',
            isCompleted: false,
          ),
        ],
        tags: const ['UI/UX', 'Theme'],
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      Task(
        id: '4',
        title: 'Prepare Presentation Slides',
        description:
            'Summarize architecture decisions and testing strategy for final review.',
        category: TaskCategory.study,
        priority: TaskPriority.low,
        dueDate: now.add(const Duration(days: 5)),
        isCompleted: false,
        subtasks: const [],
        tags: const ['Docs'],
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      Task(
        id: '5',
        title: 'Buy Groceries & Supplies',
        description:
            'Buy organic fruit, coffee beans, and dark chocolate for the sprint.',
        category: TaskCategory.personal,
        priority: TaskPriority.low,
        dueDate: now.add(const Duration(days: 3)),
        isCompleted: false,
        subtasks: const [],
        tags: const ['Personal'],
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ]);
  }

  @override
  Future<List<Task>> getTasks() async {
    await _ensureInitialized();
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task> addTask(Task task) async {
    await _ensureInitialized();
    try {
      _tasks.add(task);
      return task;
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  @override
  Future<Task> updateTask(Task task) async {
    await _ensureInitialized();
    try {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        return task;
      }
      throw Exception('Task with id ${task.id} not found');
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await _ensureInitialized();
    try {
      _tasks.removeWhere((t) => t.id == id);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<Task> toggleTaskCompletion(String id) async {
    await _ensureInitialized();
    try {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        final task = _tasks[index];
        final newStatus = !task.isCompleted;
        final updatedSubtasks =
            task.subtasks.map((s) => s.copyWith(isCompleted: newStatus)).toList();
        final updatedTask = task.copyWith(
          isCompleted: newStatus,
          subtasks: updatedSubtasks,
        );
        _tasks[index] = updatedTask;
        return updatedTask;
      }
      throw Exception('Task with id $id not found');
    } catch (e) {
      throw Exception('Failed to toggle task completion: $e');
    }
  }

  @override
  Future<Task> addSubtask(String taskId, Subtask subtask) async {
    await _ensureInitialized();
    try {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        final task = _tasks[index];
        final updatedSubtasks = [...task.subtasks, subtask];
        final updatedTask = task.copyWith(subtasks: updatedSubtasks);
        _tasks[index] = updatedTask;
        return updatedTask;
      }
      throw Exception('Task with id $taskId not found');
    } catch (e) {
      throw Exception('Failed to add subtask: $e');
    }
  }

  @override
  Future<Task> toggleSubtaskCompletion(String taskId, String subtaskId) async {
    await _ensureInitialized();
    try {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        final task = _tasks[index];
        final updatedSubtasks = task.subtasks.map((s) {
          if (s.id == subtaskId) {
            return s.copyWith(isCompleted: !s.isCompleted);
          }
          return s;
        }).toList();

        final allCompleted = updatedSubtasks.isNotEmpty &&
            updatedSubtasks.every((s) => s.isCompleted);

        final updatedTask = task.copyWith(
          subtasks: updatedSubtasks,
          isCompleted: allCompleted,
        );
        _tasks[index] = updatedTask;
        return updatedTask;
      }
      throw Exception('Task with id $taskId not found');
    } catch (e) {
      throw Exception('Failed to toggle subtask completion: $e');
    }
  }

  /// Utility method to serialize all tasks to JSON string
  String exportToJson() {
    final list = _tasks.map((t) => t.toJson()).toList();
    return jsonEncode(list);
  }
}
