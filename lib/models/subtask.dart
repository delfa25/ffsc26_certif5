class Subtask {
  final String id;
  final String title;
  final bool isCompleted;

  const Subtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Subtask copyWith({String? id, String? title, bool? isCompleted}) {
    return Subtask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isCompleted': isCompleted};
  }

  factory Subtask.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final title = json['title']?.toString() ?? 'Subtask';
      final isCompleted = json['isCompleted'] is bool
          ? json['isCompleted'] as bool
          : json['isCompleted']?.toString().toLowerCase() == 'true';

      return Subtask(
        id: id,
        title: title,
        isCompleted: isCompleted,
      );
    } catch (e) {
      throw FormatException('Failed to parse Subtask from JSON: $e');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subtask &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ isCompleted.hashCode;
}
