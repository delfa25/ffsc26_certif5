import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/widgets/optimized_image_widget.dart';

void main() {
  testWidgets('OptimizedImageWidget renders fallback icon when imageUrl is null', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OptimizedImageWidget(
            imageUrl: null,
            width: 48,
            height: 48,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.task_alt), findsOneWidget);
    expect(find.byType(OptimizedImageWidget), findsOneWidget);
  });
}
