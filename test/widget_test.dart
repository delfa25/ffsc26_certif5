import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/main.dart';

void main() {
  testWidgets('MyApp smoke test renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('TaskCraft - Gestion Pro'), findsOneWidget);
  });
}
