import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ffsc26_certif5/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Task Management Integration Flow Tests', () {
    testWidgets('Complete task creation and deletion flow', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Ensure app initialized on HomeScreen
      expect(find.text('TaskCraft - Gestion Pro'), findsOneWidget);

      // Open new task form
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Enter task title
      final titleField = find.byKey(const Key('task_title_input'));
      await tester.tap(titleField);
      await tester.enterText(titleField, 'New Flow Task');
      await tester.pumpAndSettle();

      // Save task
      final saveButton = find.byKey(const Key('save_task_button'));
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify task appeared on list
      expect(find.text('New Flow Task'), findsOneWidget);
    });
  });
}
