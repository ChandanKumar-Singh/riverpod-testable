import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/app/app.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/core/services/local_storage_adapter.dart';

import 'helpers/test_helpers.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    final storage = LocalStorage(
      sharedPreferencesAdapter: MockSharedPreferencesStorageAdapter(),
      secureStorageAdapter: MockSecureStorageAdapter(),
    );
    final container = createTestContainer(
      overrides: [
        storageProvider.overrideWithValue(storage),
        envProvider.overrideWithValue(TestEnv()),
      ],
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );
    await tester.pumpAndSettle();

    // Verify that the app builds without throwing errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
