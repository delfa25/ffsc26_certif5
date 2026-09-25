import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/models/subtask.dart';

void main() {
  group('Subtask Model Unit Tests', () {
    test('Subtask instantiation and default values', () {
      const subtask = Subtask(id: 's1', title: 'Code unit tests');
      expect(subtask.id, equals('s1'));
      expect(subtask.title, equals('Code unit tests'));
      expect(subtask.isCompleted, isFalse);
    });

    test('Subtask copyWith updates properties correctly', () {
      const original =
          Subtask(id: 's1', title: 'Write tests', isCompleted: false);
      final updated =
          original.copyWith(isCompleted: true, title: 'Write unit tests');

      expect(updated.id, equals('s1'));
      expect(updated.title, equals('Write unit tests'));
      expect(updated.isCompleted, isTrue);
    });

    test('Subtask toJson and fromJson serialization', () {
      const subtask =
          Subtask(id: 's100', title: 'Verify i10n', isCompleted: true);
      final json = subtask.toJson();
      final deserialized = Subtask.fromJson(json);

      expect(deserialized.id, equals(subtask.id));
      expect(deserialized.title, equals(subtask.title));
      expect(deserialized.isCompleted, equals(subtask.isCompleted));
    });

    test('Subtask.fromJson throws FormatException when id or title is missing', () {
      expect(() => Subtask.fromJson({'title': 'No ID'}), throwsFormatException);
      expect(() => Subtask.fromJson({'id': 's1'}), throwsFormatException);
    });
  });
}
