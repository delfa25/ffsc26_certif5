import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ffsc26_certif5/providers/task_provider.dart';
import 'package:ffsc26_certif5/providers/settings_provider.dart';
import 'package:ffsc26_certif5/repositories/task_repository.dart';
import 'package:ffsc26_certif5/models/task.dart';
import 'package:ffsc26_certif5/screens/home_screen.dart';
import 'package:ffsc26_certif5/l10n/app_localizations.dart';

void main() {
  testWidgets('HomeScreen renders search, stats and task list', (
    WidgetTester tester,
  ) async {
    final repository = TaskRepository(
      initialTasks: [
        Task(
          id: 'hs_1',
          title: 'HomeScreen Test Task',
          description: 'Verify HomeScreen UI rendering',
          category: TaskCategory.work,
          priority: TaskPriority.high,
          dueDate: DateTime.now().add(const Duration(days: 1)),
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
      ],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(
            create: (_) => TaskProvider(repository: repository),
          ),
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
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('TaskCraft - Gestion Pro'), findsOneWidget);
    expect(find.text('HomeScreen Test Task'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
