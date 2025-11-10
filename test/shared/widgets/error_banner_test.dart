import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testable/shared/widgets/error_banner.dart';

void main() {
  group('ErrorBanner', () {
    testWidgets('should display error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorBanner(
              message: 'Error message',
            ),
          ),
        ),
      );

      expect(find.text('Error message'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display close button when onDismiss is provided', (tester) async {
      bool dismissed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorBanner(
              message: 'Error message',
              onDismiss: () {
                dismissed = true;
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      
      expect(dismissed, isTrue);
    });

    testWidgets('should not display close button when onDismiss is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorBanner(
              message: 'Error message',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
    });
  });

  group('SuccessBanner', () {
    testWidgets('should display success message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SuccessBanner(
              message: 'Success message',
            ),
          ),
        ),
      );

      expect(find.text('Success message'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('should display close button when onDismiss is provided', (tester) async {
      bool dismissed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SuccessBanner(
              message: 'Success message',
              onDismiss: () {
                dismissed = true;
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      
      expect(dismissed, isTrue);
    });
  });
}


