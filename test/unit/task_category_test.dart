import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/models/task.dart';

void main() {
  group('TaskCategory & TaskPriority Enum Unit Tests', () {
    test('TaskCategory enum contains all required values', () {
      expect(TaskCategory.values, contains(TaskCategory.work));
      expect(TaskCategory.values, contains(TaskCategory.personal));
      expect(TaskCategory.values, contains(TaskCategory.study));
      expect(TaskCategory.values, contains(TaskCategory.tech));
      expect(TaskCategory.values.length, equals(4));
    });

    test('TaskPriority enum contains all required values', () {
      expect(TaskPriority.values, contains(TaskPriority.low));
      expect(TaskPriority.values, contains(TaskPriority.medium));
      expect(TaskPriority.values, contains(TaskPriority.high));
      expect(TaskPriority.values.length, equals(3));
    });
  });
}
