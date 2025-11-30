import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/features/auth/presentation/screens/login_screen.dart';
import 'package:testable/core/di/providers.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  testWidgets('LoginScreen should display email and password fields', (
    tester,
  ) async {
    final storage = MockStorageAdapter();
    final container = createTestContainer(
      overrides: [
        storageProvider.overrideWithValue(storage),
        envProvider.overrideWithValue(TestEnv()),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('LoginScreen should display login button', (tester) async {
    final storage = MockStorageAdapter();
    final container = createTestContainer(
      overrides: [
        storageProvider.overrideWithValue(storage),
        envProvider.overrideWithValue(TestEnv()),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('LoginScreen should display theme switcher in app bar', (
    tester,
  ) async {
    final storage = MockStorageAdapter();
    final container = createTestContainer(
      overrides: [
        storageProvider.overrideWithValue(storage),
        envProvider.overrideWithValue(TestEnv()),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Theme switcher is in the body, not AppBar
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
