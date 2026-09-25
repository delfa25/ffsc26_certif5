import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/models/task.dart';
import 'package:ffsc26_certif5/widgets/task_card.dart';
import 'package:ffsc26_certif5/l10n/app_localizations.dart';

void main() {
  testWidgets('TaskCard displays task information and triggers callbacks', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    bool deleted = false;
    bool? toggledValue;

    final task = Task(
      id: 'tc_1',
      title: 'Complete Unit Tests',
      description: 'Write 10 unit tests for certification',
      category: TaskCategory.tech,
      priority: TaskPriority.high,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: TaskCard(
            task: task,
            onTap: () => tapped = true,
            onDelete: () => deleted = true,
            onToggle: (val) => toggledValue = val,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Complete Unit Tests'), findsOneWidget);
    expect(find.text('Write 10 unit tests for certification'), findsOneWidget);

    // Tap card
    await tester.tap(find.text('Complete Unit Tests'));
    await tester.pump();
    expect(tapped, isTrue);

    // Tap delete button
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();
    expect(deleted, isTrue);

    // Tap checkbox
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(toggledValue, isTrue);
  });
}
