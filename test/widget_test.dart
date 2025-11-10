import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testable/app/app.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app builds without throwing errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
