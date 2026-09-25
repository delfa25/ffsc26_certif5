import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/widgets/empty_state_widget.dart';

void main() {
  testWidgets('EmptyStateWidget renders title, message and action button', (
    WidgetTester tester,
  ) async {
    bool actionClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyStateWidget(
            title: 'No Items Found',
            message: 'Create a new item to get started.',
            actionLabel: 'Create Item',
            onAction: () {
              actionClicked = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('No Items Found'), findsOneWidget);
    expect(find.text('Create a new item to get started.'), findsOneWidget);
    expect(find.text('Create Item'), findsOneWidget);

    await tester.tap(find.text('Create Item'));
    await tester.pump();

    expect(actionClicked, isTrue);
  });
}
