import 'subtask.dart';

enum TaskPriority { low, medium, high }

enum TaskCategory { work, personal, study, tech }

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }
}

extension TaskCategoryExtension on TaskCategory {
  String get displayName {
    switch (this) {
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.study:
        return 'Study';
      case TaskCategory.tech:
        return 'Tech';
    }
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final TaskCategory category;
  final TaskPriority priority;
  final DateTime dueDate;
  final bool isCompleted;
  final List<Subtask> subtasks;
  final List<String> tags;
  final DateTime createdAt;
  final String? imageUrl;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
    this.subtasks = const [],
    this.tags = const [],
    required this.createdAt,
    this.imageUrl,
  });

  double get progress {
    if (subtasks.isEmpty) {
      return isCompleted ? 1.0 : 0.0;
    }
    final completedCount = subtasks.where((s) => s.isCompleted).length;
    return completedCount / subtasks.length;
  }

  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now();
    return dueDate.isBefore(DateTime(now.year, now.month, now.day));
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskCategory? category,
    TaskPriority? priority,
    DateTime? dueDate,
    bool? isCompleted,
    List<Subtask>? subtasks,
    List<String>? tags,
    DateTime? createdAt,
    String? imageUrl,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      subtasks: subtasks ?? this.subtasks,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'priority': priority.name,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'subtasks': subtasks.map((s) => s.toJson()).toList(),
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final title = json['title']?.toString() ?? 'Untitled Task';
      final description = json['description']?.toString() ?? '';

      final categoryStr = json['category']?.toString().toLowerCase() ?? '';
      final category = TaskCategory.values.firstWhere(
        (c) => c.name.toLowerCase() == categoryStr,
        orElse: () => TaskCategory.work,
      );

      final priorityStr = json['priority']?.toString().toLowerCase() ?? '';
      final priority = TaskPriority.values.firstWhere(
        (p) => p.name.toLowerCase() == priorityStr,
        orElse: () => TaskPriority.medium,
      );

      DateTime dueDate;
      if (json['dueDate'] != null) {
        dueDate =
            DateTime.tryParse(json['dueDate'].toString()) ?? DateTime.now();
      } else {
        dueDate = DateTime.now();
      }

      DateTime createdAt;
      if (json['createdAt'] != null) {
        createdAt =
            DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
      } else {
        createdAt = DateTime.now();
      }

      final isCompleted = json['isCompleted'] is bool
          ? json['isCompleted'] as bool
          : json['isCompleted']?.toString().toLowerCase() == 'true';

      List<Subtask> subtasks = [];
      if (json['subtasks'] is List) {
        subtasks = (json['subtasks'] as List)
            .whereType<Map<String, dynamic>>()
            .map((s) => Subtask.fromJson(s))
            .toList();
      }

      List<String> tags = [];
      if (json['tags'] is List) {
        tags = (json['tags'] as List).map((t) => t.toString()).toList();
      }

      final imageUrl = json['imageUrl']?.toString();

      return Task(
        id: id,
        title: title,
        description: description,
        category: category,
        priority: priority,
        dueDate: dueDate,
        isCompleted: isCompleted,
        subtasks: subtasks,
        tags: tags,
        createdAt: createdAt,
        imageUrl: imageUrl,
      );
    } catch (e) {
      throw FormatException('Failed to parse Task from JSON: $e');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          category == other.category &&
          priority == other.priority &&
          dueDate == other.dueDate &&
          isCompleted == other.isCompleted &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      category.hashCode ^
      priority.hashCode ^
      dueDate.hashCode ^
      isCompleted.hashCode ^
      createdAt.hashCode;
}
