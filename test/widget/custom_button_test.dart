import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/widgets/custom_button.dart';

void main() {
  testWidgets('CustomButton renders label and handles tap event', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            label: 'Submit Action',
            icon: Icons.send,
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Submit Action'), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);

    await tester.tap(find.text('Submit Action'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
