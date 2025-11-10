import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testable/shared/widgets/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget', () {
    testWidgets('should display icon and title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Empty',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('Empty'), findsOneWidget);
    });

    testWidgets('should display message when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Empty',
              message: 'No items found',
            ),
          ),
        ),
      );

      expect(find.text('Empty'), findsOneWidget);
      expect(find.text('No items found'), findsOneWidget);
    });

    testWidgets('should display action button when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Empty',
              action: ElevatedButton(
                onPressed: () {},
                child: const Text('Refresh'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Refresh'), findsOneWidget);
    });
  });

  group('EmptyListWidget', () {
    testWidgets('should display default empty list message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyListWidget(),
          ),
        ),
      );

      expect(find.text('Empty'), findsOneWidget);
      expect(find.text('No items found'), findsOneWidget);
    });

    testWidgets('should display custom message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyListWidget(
              message: 'No payments found',
            ),
          ),
        ),
      );

      expect(find.text('No payments found'), findsOneWidget);
    });
  });

  group('ErrorEmptyStateWidget', () {
    testWidgets('should display error icon and message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorEmptyStateWidget(
              message: 'Something went wrong',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should not display retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorEmptyStateWidget(
              message: 'Error occurred',
            ),
          ),
        ),
      );

      expect(find.text('Error occurred'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
    });
  });
}


