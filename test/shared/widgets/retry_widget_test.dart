import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testable/shared/widgets/retry_widget.dart';

void main() {
  group('RetryWidget', () {
    testWidgets('should display error icon and message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWidget(
              message: 'Error occurred',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Error occurred'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should call onRetry when retry button is pressed', (tester) async {
      bool retryPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWidget(
              message: 'Error occurred',
              onRetry: () {
                retryPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryPressed, isTrue);
    });

    testWidgets('should display custom icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWidget(
              message: 'Error occurred',
              icon: Icons.warning,
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.warning), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsNothing);
    });
  });
}

