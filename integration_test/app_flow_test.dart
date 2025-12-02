import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/test_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Testable App Integration', () {
    testWidgets(
      'shows login screen for unauthenticated users and validates form errors',
      (tester) async {
        final harness = TestAppHarness();
        await harness.setup();

        await tester.pumpWidget(harness.buildApp());
        await tester.pumpAndSettle();

        expect(find.text('Welcome Back!'), findsOneWidget);

        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        expect(find.text('Please enter your email'), findsOneWidget);
        expect(find.text('Please enter password'), findsOneWidget);

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email Address'),
          'invalid@',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          '123',
        );
        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        expect(find.text('Please enter a valid email'), findsOneWidget);
        expect(
          find.text('Password must be at least 6 characters'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'performs successful OTP login and navigates across feature screens',
      (tester) async {
        final harness = TestAppHarness();

        await tester.pumpWidget(harness.buildApp());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email Address'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'superSecret',
        );
        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle(const Duration(milliseconds: 600));

        expect(find.text('Home'), findsOneWidget);
        expect(find.textContaining('Test User'), findsWidgets);

        await tester.tap(find.text('Payments').first);
        await tester.pumpAndSettle();
        expect(find.text('Payments'), findsWidgets);
        expect(find.text('Loading payments...'), findsOneWidget);

        await tester.pageBack();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Profile').first);
        await tester.pumpAndSettle();
        expect(find.text('Profile'), findsWidgets);
        expect(find.text('Test User'), findsWidgets);
      },
    );

    testWidgets('restores persisted session and keeps theme + locale changes', (
      tester,
    ) async {
      final harness = TestAppHarness(startAuthenticated: true);

      await harness.storage.save('theme_mode', 'light');
      await harness.storage.save('language_code', 'en');

      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.textContaining('Test User'), findsWidgets);

      final darkModeButton = find.byIcon(Icons.dark_mode_rounded);
      expect(darkModeButton, findsOneWidget);
      await tester.tap(darkModeButton);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);

      final langDropdown = find.byWidgetPredicate(
        (widget) => widget is DropdownButton<Locale>,
      );
      expect(langDropdown, findsOneWidget);

      await tester.tap(langDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('हिन्दी').last);
      await tester.pumpAndSettle();

      expect(find.text('टेस्टेबल ऐप'), findsOneWidget);

      final savedTheme = await harness.storage.getString(
        'theme_mode',
        secure: false,
      );
      final savedLocale = await harness.storage.getString(
        'language_code',
        secure: false,
      );

      expect(savedTheme, 'dark');
      expect(savedLocale, 'hi');
    });
  });
}
