import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:testable/features/auth/data/providers/auth_provider.dart';
import 'package:testable/shared/localization/lang_storage.dart';
import 'package:testable/shared/localization/lang_switcher.dart';
import 'package:testable/shared/theme/theme_storage.dart';
import 'package:testable/shared/theme/theme_switcher.dart';

import 'helpers/TestAppHelper.dart';
import 'helpers/test_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Testable App Integration', () {
    testWidgets(
      'shows login screen for unauthenticated users and validates form errors',
      (tester) async {
        final app = await TestAppHelper.createUnauthenticatedApp();
        await tester.pumpWidget(app);

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
        final app = await TestAppHelper.createUnauthenticatedApp();
        await tester.pumpWidget(app);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        print('🔄 App started. Looking for login screen...');
        expect(find.text('Sign In'), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 500));

        // Step 1: Enter email
        print('📧 Entering email...');
        final emailField = find.widgetWithText(TextFormField, 'Email Address');
        expect(emailField, findsOneWidget);
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump(const Duration(milliseconds: 300));

        // Verify email entered
        expect(find.text('test@example.com'), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 200));

        // Step 2: Enter password
        print('🔑 Entering password...');
        final passwordField = find.widgetWithText(TextFormField, 'Password');
        expect(passwordField, findsOneWidget);
        await tester.enterText(passwordField, 'superSecret');
        await tester.pump(const Duration(milliseconds: 1000));
        // Step 2: Enter password
        print('🔑 Show Password...');
        final obsecureButton = find.byKey(const Key('obscure_field_key'));
        expect(obsecureButton, findsOneWidget);
        await tester.tap(obsecureButton);
        await tester.pump(const Duration(milliseconds: 1000));

        // Mask password verification (show asterisks)
        expect(find.text('superSecret'), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 1000));
        // Step 3: Tap Sign In button
        print('👉 Tapping Sign In button...');
        final signInButton = find.text('Sign In');
        expect(signInButton, findsOneWidget);

        // Debug: Check if button is visible and enabled
        await tester.ensureVisible(signInButton);
        await tester.pump();

        await tester.tap(signInButton, warnIfMissed: true);

        // Show loading state
        /*      expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 3000));

        // Wait for API call and navigation
        print('⏳ Waiting for authentication...');
         */
        await tester.pumpAndSettle(const Duration(seconds: 2));
        // Step 4: Verify successful login
        print('✅ Checking home screen...');
        expect(find.text('Home'), findsOneWidget);
        final authUser = TestAppHelper.container(
          tester,
        ).read(authProvider).user;
        if (authUser != null) {
          await TestAppHelper.saveUserState(authUser.toJson());
        } else {
          print('❌ User not found in auth state...');
        }
        print('✅ Checking user card ...');
        expect(find.byKey(const Key('dashboard_user_card_key')), findsWidgets);
        await tester.pump(
          const Duration(milliseconds: 1000),
        ); // Pause to see home screen
        // Step 5: Summary
        print('🎉 Test completed successfully!');
        print('├── ✅ Login successful');
        print('└── ✅ Home screen loaded');
      },
    );

    testWidgets(
      'Profile Api Test',
      (tester) async {
        final app = await TestAppHelper.createAuthenticatedApp();
        await tester.pumpWidget(app);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Step 1: Navigate to Profile
        print('👤 Navigating to Profile...');
        final profileButton = find.text('Profile').first;
        expect(profileButton, findsOneWidget);
        await tester.tap(profileButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        print('✅ Checking profile screen...');
        expect(find.text('Profile'), findsWidgets);
        await tester.pumpAndSettle();
        print('✅ Checking user card ...');
        expect(find.byKey(const Key('dashboard_user_card_key')), findsWidgets);
        await tester.pump(
          const Duration(milliseconds: 1500),
        ); // Pause to see profile

        // Step 2: Summary
        print('🎉 Test completed successfully!');
        print('├── ✅ Home screen loaded');
        print('└── ✅ Profile navigation worked');
        await tester.pump(const Duration(seconds: 1));
      },
      timeout: const Timeout(
        Duration(seconds: 60),
      ), // Extended timeout for visual tests
    );

    testWidgets(
      'Screen Test',
      (tester) async {
        final app = await TestAppHelper.createAuthenticatedApp();
        await tester.pumpWidget(app);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Step 1: Navigate to Payments
        print('💳 Navigating to Payments...');
        final paymentsButton = find.text('Payments').first;
        expect(paymentsButton, findsOneWidget);
        await tester.tap(paymentsButton);

        // Show loading animation
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Wait for payments to load
        await tester.pumpAndSettle(const Duration(seconds: 1));

        print('✅ Checking payments screen...');
        expect(find.text('Payments'), findsWidgets);
        // await tester.pump(
        //   const Duration(milliseconds: 1500),
        // ); // Pause to see payments
        // expect(find.text('Loading payments...'), findsOneWidget);
        await tester.pump(
          const Duration(milliseconds: 1500),
        ); // Pause to see payments

        // Step 2: Go back to Home
        print('↩️ Going back to Home...');
        await tester.pageBack();
        await tester.pumpAndSettle(const Duration(milliseconds: 800));
        expect(find.text('Home'), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 1000));

        // Step 3: Summary
        print('🎉 Test completed successfully!');
        print('├── ✅ Home screen loaded');
        print('├── ✅ Payments navigation worked');
        print('└── ✅ Back navigation worked');

        await tester.pump(const Duration(seconds: 1));
      },
      timeout: const Timeout(
        Duration(seconds: 60),
      ), // Extended timeout for visual tests
    );

    testWidgets('restores persisted session and keeps theme + locale changes', (
      tester,
    ) async {
      final harness = TestAppHarness();
      await harness.setup();
      await harness.storage.save(ThemeStorage.modeKey, 'light');
      await harness.storage.save(LangStorage.rootKey, 'en');

      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(find.textContaining('Test User'), findsWidgets);

      final darkModeButton = find.byKey(const Key(ThemeSwitcher.buttonKey));
      expect(darkModeButton, findsOneWidget);
      await Future.delayed(const Duration(milliseconds: 2000));
      await tester.tap(darkModeButton);
      await Future.delayed(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key(ThemeSwitcher.buttonKey)), findsOneWidget);
      await Future.delayed(const Duration(milliseconds: 3500));

      final langDropdown = find.byKey(const Key(LangSwitcher.buttonKey));
      expect(langDropdown, findsOneWidget);

      await tester.tap(langDropdown);
      await Future.delayed(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      await tester.tap(find.text('हिन्दी').last);
      await Future.delayed(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();

      expect(find.text('टेस्टेबल ऐप'), findsOneWidget);

      final savedTheme = await harness.storage.getString(
        ThemeStorage.modeKey,
        secure: false,
      );
      final savedLocale = await harness.storage.getString(
        LangStorage.rootKey,
        secure: false,
      );

      expect(savedTheme, 'dark');
      expect(savedLocale, 'hi');
      await Future.delayed(const Duration(milliseconds: 5000));
    });
  });
}
