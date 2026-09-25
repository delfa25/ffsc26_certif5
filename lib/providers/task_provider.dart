import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final ITaskRepository _repository;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String _searchQuery = '';
  TaskCategory? _selectedCategory;
  TaskPriority? _selectedPriority;
  bool _showOnlyCompleted = false;

  TaskProvider({ITaskRepository? repository})
      : _repository = repository ?? TaskRepository() {
    loadTasks();
  }

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  TaskCategory? get selectedCategory => _selectedCategory;
  TaskPriority? get selectedPriority => _selectedPriority;
  bool get showOnlyCompleted => _showOnlyCompleted;

  List<Task> get filteredTasks {
    return _tasks.where((task) {
      if (_showOnlyCompleted && !task.isCompleted) return false;

      if (_selectedCategory != null && task.category != _selectedCategory) {
        return false;
      }

      if (_selectedPriority != null && task.priority != _selectedPriority) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = task.title.toLowerCase().contains(query);
        final matchesDesc = task.description.toLowerCase().contains(query);
        final matchesTag = task.tags.any(
          (t) => t.toLowerCase().contains(query),
        );
        return matchesTitle || matchesDesc || matchesTag;
      }

      return true;
    }).toList();
  }

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  int get overdueCount => _tasks.where((t) => t.isOverdue).length;

  double get completionPercentage {
    if (_tasks.isEmpty) return 0.0;
    return completedCount / totalCount;
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = List.from(await _repository.getTasks());
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(TaskCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setPriorityFilter(TaskPriority? priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void toggleShowOnlyCompleted() {
    _showOnlyCompleted = !_showOnlyCompleted;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedPriority = null;
    _showOnlyCompleted = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final newTask = await _repository.addTask(task);
    _tasks = [..._tasks, newTask];
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final updated = await _repository.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final updated = await _repository.toggleTaskCompletion(id);
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  Future<void> addSubtask(String taskId, Subtask subtask) async {
    final updated = await _repository.addSubtask(taskId, subtask);
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  Future<void> toggleSubtaskCompletion(String taskId, String subtaskId) async {
    final updated = await _repository.toggleSubtaskCompletion(
      taskId,
      subtaskId,
    );
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }
}
