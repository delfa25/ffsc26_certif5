import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/widgets/stat_card.dart';

void main() {
  testWidgets('StatCard displays title, value and icon correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatCard(
            title: 'Total Tasks',
            value: '42',
            icon: Icons.check_circle,
            color: Colors.green,
            subtitle: '10 completed today',
          ),
        ),
      ),
    );

    expect(find.text('Total Tasks'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('10 completed today'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
