import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ffsc26_certif5/providers/task_provider.dart';
import 'package:ffsc26_certif5/providers/settings_provider.dart';
import 'package:ffsc26_certif5/repositories/task_repository.dart';
import 'package:ffsc26_certif5/models/task.dart';
import 'package:ffsc26_certif5/screens/task_detail_screen.dart';
import 'package:ffsc26_certif5/l10n/app_localizations.dart';

void main() {
  testWidgets('TaskDetailScreen displays task title, description and category',
      (
    WidgetTester tester,
  ) async {
    final repository = TaskRepository(
      initialTasks: [
        Task(
          id: 'td_1',
          title: 'Detail Screen Task',
          description: 'Detailed description text for testing',
          category: TaskCategory.work,
          priority: TaskPriority.high,
          dueDate: DateTime.now().add(const Duration(days: 1)),
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
      ],
    );

    final taskProvider = TaskProvider(repository: repository);
    await taskProvider.loadTasks();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider.value(value: taskProvider),
        ],
        child: const MaterialApp(
          locale: Locale('fr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: TaskDetailScreen(taskId: 'td_1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Détails de la tâche'), findsOneWidget);
    expect(find.text('Detail Screen Task'), findsOneWidget);
    expect(find.text('Detailed description text for testing'), findsOneWidget);
  });
}
