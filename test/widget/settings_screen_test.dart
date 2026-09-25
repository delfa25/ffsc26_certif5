import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ffsc26_certif5/providers/task_provider.dart';
import 'package:ffsc26_certif5/providers/settings_provider.dart';
import 'package:ffsc26_certif5/repositories/task_repository.dart';
import 'package:ffsc26_certif5/screens/settings_screen.dart';
import 'package:ffsc26_certif5/l10n/app_localizations.dart';

void main() {
  testWidgets('SettingsScreen displays profile, theme and language options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(
            create: (_) =>
                TaskProvider(repository: TaskRepository(initialTasks: [])),
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
          home: SettingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Mama Fadel DIAWARA'), findsOneWidget);
    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.text('Langue'), findsOneWidget);
    expect(find.text('Thème'), findsOneWidget);
  });
}
