import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:testable/shared/widgets/error_widget.dart';

void main() {
  group('ErrorDisplay', () {
    testWidgets('displays error message', (WidgetTester tester) async {
      const error = 'Test error';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorDisplay(error: error)),
        ),
      );

      // In debug mode, it shows "An Error Occurred", in release mode "Something went wrong"
      expect(find.text('An Error Occurred'), findsOneWidget);
    });

    testWidgets('displays custom title when provided', (
      WidgetTester tester,
    ) async {
      const error = 'Test error';
      const title = 'Custom Error Title';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(error: error, title: title),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry is provided', (
      WidgetTester tester,
    ) async {
      const error = 'Test error';
      bool retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(error: error, onRetry: () => retryCalled = true),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryCalled, isTrue);
    });

    testWidgets('does not show retry button when onRetry is null', (
      WidgetTester tester,
    ) async {
      const error = 'Test error';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorDisplay(error: error)),
        ),
      );

      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('displays custom icon when provided', (
      WidgetTester tester,
    ) async {
      const error = 'Test error';
      const customIcon = Icon(Icons.warning);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(error: error, icon: customIcon),
          ),
        ),
      );

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });
  });

  group('ErrorScreen', () {
    testWidgets('displays error screen in release mode', (
      WidgetTester tester,
    ) async {
      const error = 'Test error';
      await tester.pumpWidget(const MaterialApp(home: ErrorScreen(error: error)));

      expect(find.text('Oops! Something went wrong'), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry is provided', (
      WidgetTester tester,
    ) async {
      const error = 'Test error';
      bool retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ErrorScreen(error: error, onRetry: () => retryCalled = true),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryCalled, isTrue);
    });
  });
}
