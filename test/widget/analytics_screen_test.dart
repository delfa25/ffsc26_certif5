import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ffsc26_certif5/providers/task_provider.dart';
import 'package:ffsc26_certif5/providers/settings_provider.dart';
import 'package:ffsc26_certif5/repositories/task_repository.dart';
import 'package:ffsc26_certif5/models/task.dart';
import 'package:ffsc26_certif5/screens/analytics_screen.dart';
import 'package:ffsc26_certif5/l10n/app_localizations.dart';

void main() {
  testWidgets('AnalyticsScreen displays productivity score and stats cards', (
    WidgetTester tester,
  ) async {
    final repository = TaskRepository(
      initialTasks: [
        Task(
          id: 'a_1',
          title: 'Analytics Task',
          description: 'Desc',
          category: TaskCategory.tech,
          priority: TaskPriority.high,
          dueDate: DateTime.now(),
          isCompleted: true,
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
          home: AnalyticsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Statistiques'), findsOneWidget);
    expect(find.text('Score d\'efficacité'), findsOneWidget);
    expect(find.text('100 / 100'), findsOneWidget);
  });
}
