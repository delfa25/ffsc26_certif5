import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ffsc26_certif5/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Application Integration Tests', () {
    testWidgets('E2E Flow 1: Create a new task and interact with details', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify Home Screen loaded
      expect(find.text('TaskCraft - Gestion Pro'), findsOneWidget);

      // Tap on FloatingActionButton to navigate to TaskFormScreen
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Enter Task Title in form
      final titleField = find.byKey(const Key('task_title_input'));
      await tester.tap(titleField);
      await tester.pumpAndSettle();
      await tester.enterText(titleField, 'Integration Test Task');
      await tester.pumpAndSettle();

      // Enter Task Description in form
      final descField = find.byKey(const Key('task_desc_input'));
      await tester.tap(descField);
      await tester.pumpAndSettle();
      await tester.enterText(
        descField,
        'Description for e2e integration testing',
      );
      await tester.pumpAndSettle();

      // Tap Save button
      final saveButton = find.byKey(const Key('save_task_button'));
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify the task appears on the home screen
      expect(find.text('Integration Test Task'), findsOneWidget);

      // Tap on the task to open TaskDetailScreen
      await tester.tap(find.text('Integration Test Task'));
      await tester.pumpAndSettle();

      // Verify TaskDetailScreen is displayed
      expect(find.text('Détails de la tâche'), findsOneWidget);
      expect(
        find.text('Description for e2e integration testing'),
        findsOneWidget,
      );
    });

    testWidgets('E2E Flow 2: Navigation to Analytics and Settings Screens', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap Analytics Icon in AppBar
      final analyticsButton = find.byIcon(Icons.bar_chart);
      expect(analyticsButton, findsOneWidget);
      await tester.tap(analyticsButton);
      await tester.pumpAndSettle();

      // Verify Analytics Screen loaded
      expect(find.text('Statistiques'), findsOneWidget);
      expect(find.text('Score d\'efficacité'), findsOneWidget);

      // Navigate back
      final backButton = find.byType(BackButton);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Tap Settings Icon in AppBar
      final settingsButton = find.byIcon(Icons.settings);
      expect(settingsButton, findsOneWidget);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Verify Settings Screen loaded
      expect(find.text('Paramètres'), findsOneWidget);
      expect(find.text('Mama Fadel DIAWARA'), findsOneWidget);
    });
  });
}
