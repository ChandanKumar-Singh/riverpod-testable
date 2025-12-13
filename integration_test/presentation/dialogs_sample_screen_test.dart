import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dialogs Screen Tests', () {
    Future<void> navigateToDialogsScreen(WidgetTester tester) async {
      final harness = TestAppHarness(startAuthenticated: true);
      await harness.setup();
      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to Dialogs screen
      await tester.scrollUntilVisible(
        find.text('Dialogs'),
        500,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 10,
      );
      await tester.pumpAndSettle();

      expect(find.text('Dialogs'), findsOneWidget);
      await tester.tap(find.text('Dialogs').last);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify we're on the dialogs screen
      expect(find.text('UltraDialog Samples'), findsOneWidget);
    }

    testWidgets('Navigate to dialogs screen and verify UI', (tester) async {
      await navigateToDialogsScreen(tester);

      // Verify all main sections are present
      expect(find.text('Dialog Results'), findsOneWidget);
      expect(find.text('Basic Dialogs'), findsOneWidget);
      expect(find.text('Action Dialogs'), findsOneWidget);
      expect(find.text('Status Dialogs'), findsOneWidget);
      expect(find.text('UltraDialog Features'), findsOneWidget);

      // Verify all buttons are present
      expect(find.text('Basic Dialog'), findsOneWidget);
      expect(find.text('Styled Dialog'), findsOneWidget);
      expect(find.text('Bottom Sheet'), findsOneWidget);
      expect(find.text('Full Screen'), findsOneWidget);
      expect(find.text('Confirmation'), findsOneWidget);
      expect(find.text('Input Dialog'), findsOneWidget);
      expect(find.text('Selection Dialog'), findsOneWidget);
      expect(find.text('Form Dialog'), findsOneWidget);
      expect(find.text('Loading Dialog'), findsOneWidget);
      expect(find.text('Success Dialog'), findsOneWidget);
      expect(find.text('Error Dialog'), findsOneWidget);
    });

    testWidgets('Test Basic Dialog', (tester) async {
      await navigateToDialogsScreen(tester);

      await tester.tap(find.text('Basic Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Basic Dialog'), findsWidgets); // In dialog
      expect(find.textContaining('This is a simple dialog using the new UltraDialog API'), findsOneWidget);

      // Close the dialog
      await tester.tapAt(Offset.zero); // Tap outside to close
      await tester.pumpAndSettle();
    });

    testWidgets('Test Styled Dialog with close button', (tester) async {
      await navigateToDialogsScreen(tester);

      await tester.tap(find.text('Styled Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is shown with all elements
      expect(find.text('Styled Dialog'), findsWidgets);
      expect(find.byIcon(Icons.palette), findsWidgets);
      expect(find.text('Custom Styled Dialog'), findsWidgets);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);

      // Test Cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.text('Cancel', skipOffstage: false), findsNothing);
    });

    testWidgets('Test Confirmation Dialog', (tester) async {
      await navigateToDialogsScreen(tester);

      await tester.tap(find.text('Confirmation'));
      await tester.pumpAndSettle();

      // Verify confirmation dialog
      expect(find.text('Delete Item?'), findsOneWidget);
      expect(find.textContaining('This action cannot be undone'), findsOneWidget);

      // Test cancel option
      final cancelButton = find.widgetWithText(OutlinedButton, 'Cancel');
      final confirmButton = find.widgetWithText(FilledButton, 'Confirm');

      expect(cancelButton, findsOneWidget);
      expect(confirmButton, findsOneWidget);

      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Verify success dialog appears
      expect(find.text('Deletion cancelled.'), findsOneWidget);

      // Close success dialog
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();
    });

    testWidgets('Test Input Dialog', (tester) async {
      await navigateToDialogsScreen(tester);

      await tester.tap(find.text('Input Dialog'));
      await tester.pumpAndSettle();

      // Verify input dialog
      expect(find.text('Enter Your Name'), findsOneWidget);

      // Find text field and enter text
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'John Doe');
      await tester.pumpAndSettle();

      // Find and tap submit button
      final submitButton = find.widgetWithText(ElevatedButton, 'Submit');
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Verify input result is updated
        expect(
          find.text('John Doe'),
          findsAtLeast(2),
        ); // Should appear in results section
      }
    });

    testWidgets('Test Selection Dialog', (tester) async {
      await navigateToDialogsScreen(tester);

      await tester.tap(find.text('Selection Dialog'));
      await tester.pumpAndSettle();

      // Verify selection dialog
      expect(find.text('Choose Your Specialty'), findsOneWidget);

      // Search for an option if searchable
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField, 'Flutter');
        await tester.pumpAndSettle();
      }

      // Select an option
      final flutterOption = find.text('Flutter Development');
      expect(flutterOption, findsOneWidget);

      await tester.tap(flutterOption);
      await tester.pumpAndSettle();

      // Verify selection is updated in results
      expect(find.text('flutter'), findsOneWidget); // Check results section
    });

    testWidgets('Test Loading Dialog', (tester) async {
      await navigateToDialogsScreen(tester);

      await tester.tap(find.text('Loading Dialog'));
      await tester.pumpAndSettle();

      // Verify loading dialog appears
      expect(find.text('Processing your request...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for auto-close
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Verify success dialog appears after loading
      expect(find.text('Operation completed!'), findsOneWidget);

      // Close success dialog
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();
    });

    testWidgets('Test Success Dialog', (tester) async {
      await navigateToDialogsScreen(tester);

      await tester.tap(find.text('Success Dialog'));
      await tester.pumpAndSettle();

      // Verify success dialog
      expect(find.text('Success!'), findsOneWidget);
      expect(find.text('Operation completed successfully!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Close dialog
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();
    });

    testWidgets('Test Error Dialog', (tester) async {
      await navigateToDialogsScreen(tester);

      await tester.tap(find.text('Error Dialog'));
      await tester.pumpAndSettle();

      // Verify error dialog
      expect(find.text('Connection Error'), findsOneWidget);
      expect(find.text('Unable to connect to the server'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);

      // Check for error details expandable
      final viewDetailsButton = find.text('View Details');
      if (viewDetailsButton.evaluate().isNotEmpty) {
        await tester.tap(viewDetailsButton);
        await tester.pumpAndSettle();

        expect(find.text('Error Code: 503'), findsOneWidget);
      }

      // Close dialog
      final closeButton = find.widgetWithText(ElevatedButton, 'Close');
      if (closeButton.evaluate().isNotEmpty) {
        await tester.tap(closeButton);
      } else {
        await tester.tapAt(Offset.zero);
      }
      await tester.pumpAndSettle();
    });

    testWidgets('Test Bottom Sheet Dialog', (tester) async {
      await navigateToDialogsScreen(tester);

      await tester.tap(find.text('Bottom Sheet'));
      await tester.pumpAndSettle();

      // Verify bottom sheet
      expect(find.text('Bottom Sheet Dialog'), findsOneWidget);
      expect(find.text('Swipe down to dismiss'), findsOneWidget);

      // Test options in bottom sheet
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);

      // Test swipe to dismiss
      await tester.drag(find.text('Bottom Sheet Dialog'), const Offset(0, 300));
      await tester.pumpAndSettle();

      // Verify bottom sheet is dismissed
      expect(
        find.text('Bottom Sheet Dialog', skipOffstage: false),
        findsNothing,
      );
    });

    testWidgets('Test Full Screen Dialog', (tester) async {
      await navigateToDialogsScreen(tester);

      await tester.tap(find.text('Full Screen'));
      await tester.pumpAndSettle();

      // Verify full screen dialog
      expect(find.text('Full Screen Dialog'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsWidgets);

      // Check for list items
      expect(find.text('Advanced Settings'), findsOneWidget);
      expect(find.text('User Management'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);

      // Tap on an item
      await tester.tap(find.text('Advanced Settings'));
      await tester.pumpAndSettle();

      // Verify success dialog
      expect(find.text('Advanced Settings selected'), findsOneWidget);

      // Close success dialog
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      // Close full screen dialog
      final closeButton = find.byIcon(Icons.close);
      if (closeButton.evaluate().isNotEmpty) {
        await tester.tap(closeButton);
      } else {
        await tester.tap(find.text('Cancel'));
      }
      await tester.pumpAndSettle();
    });

    testWidgets('Test Form Dialog', (tester) async {
      await navigateToDialogsScreen(tester);

      await tester.tap(find.text('Form Dialog'));
      await tester.pumpAndSettle();

      // Verify form dialog
      expect(find.text('Create New Project'), findsOneWidget);
      expect(find.text('Fill in the details'), findsOneWidget);

      // Fill form fields
      final projectNameField = find.widgetWithText(
        TextFormField,
        'Project Name',
      );
      await tester.enterText(projectNameField, 'My Test Project');
      await tester.pumpAndSettle();

      // Create project
      await tester.tap(find.text('Create Project'));
      await tester.pumpAndSettle();

      // Verify success dialog
      expect(find.text('Project created successfully!'), findsOneWidget);

      // Close success dialog
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();
    });

    testWidgets('Verify dialog results update', (tester) async {
      await navigateToDialogsScreen(tester);

      // Check initial results
      expect(find.text('Selected Option:'), findsOneWidget);
      expect(
        find.text('None'),
        findsAtLeast(2),
      ); // Both results should be "None"
      expect(find.text('Input Result:'), findsOneWidget);

      // Test input dialog updates
      await tester.tap(find.text('Input Dialog'));
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Test User');
      await tester.pumpAndSettle();

      final submitButton = find.widgetWithText(ElevatedButton, 'Submit');
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Verify input result updated
        expect(find.text('Test User'), findsAtLeast(2));
      }

      // Test selection dialog updates
      await tester.tap(find.text('Selection Dialog'));
      await tester.pumpAndSettle();

      final designOption = find.text('UI/UX Design');
      if (designOption.evaluate().isNotEmpty) {
        await tester.tap(designOption);
        await tester.pumpAndSettle();

        // Verify selection updated
        expect(find.text('design'), findsOneWidget);
      }
    });

    testWidgets('Test screen scrollability', (tester) async {
      await navigateToDialogsScreen(tester);

      // Verify screen can scroll
      final scrollable = find.byType(SingleChildScrollView);
      expect(scrollable, findsOneWidget);

      // Scroll to bottom
      await tester.drag(scrollable, const Offset(0, -500));
      await tester.pumpAndSettle();

      // Verify bottom content
      expect(find.text('UltraDialog Features'), findsOneWidget);
      expect(find.text('Fully customizable styling'), findsOneWidget);

      // Scroll back to top
      await tester.drag(scrollable, const Offset(0, 500));
      await tester.pumpAndSettle();

      expect(find.text('Dialog Results'), findsOneWidget);
    });

    testWidgets('Test app bar navigation', (tester) async {
      await navigateToDialogsScreen(tester);

      // Verify app bar
      expect(find.text('UltraDialog Samples'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // Test back navigation (if applicable)
      final backButton = find.byIcon(Icons.arrow_back);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Should be back on home screen
        expect(find.text('Dialogs'), findsOneWidget);
      }
    });
  });
}
