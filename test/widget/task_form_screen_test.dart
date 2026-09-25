import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ffsc26_certif5/providers/task_provider.dart';
import 'package:ffsc26_certif5/providers/settings_provider.dart';
import 'package:ffsc26_certif5/repositories/task_repository.dart';
import 'package:ffsc26_certif5/screens/task_form_screen.dart';
import 'package:ffsc26_certif5/l10n/app_localizations.dart';

void main() {
  testWidgets('TaskFormScreen renders form fields and save button', (
    WidgetTester tester,
  ) async {
    final repository = TaskRepository(initialTasks: []);

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
          home: TaskFormScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Ajouter une tâche'), findsOneWidget);
    expect(find.byKey(const Key('task_title_input')), findsOneWidget);
    expect(find.byKey(const Key('task_desc_input')), findsOneWidget);
    expect(find.byKey(const Key('save_task_button')), findsOneWidget);
  });
}
