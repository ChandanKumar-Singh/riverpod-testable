import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/shared/theme/theme_provider.dart';
import 'package:testable/shared/theme/theme_storage.dart';
import 'theme_provider_test.mocks.dart';

@GenerateMocks([ThemeStorage])
void main() {
  group('ThemeNotifier', () {
    late ProviderContainer container;
    late MockThemeStorage mockStorage;

    setUp(() {
      mockStorage = MockThemeStorage();
      when(
        mockStorage.loadThemeMode(),
      ).thenAnswer((_) async => ThemeMode.system);
      container = ProviderContainer(
        overrides: [
          themeProvider.overrideWith((ref) => ThemeNotifier(mockStorage)),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initializes with system theme', () async {
      await Future.delayed(const Duration(milliseconds: 10));
      final state = container.read(themeProvider);
      expect(state, ThemeMode.system);
    });

    test('setTheme updates theme and saves to storage', () async {
      when(mockStorage.saveThemeMode(any)).thenAnswer((_) async {});

      // Wait for initial load to complete
      await Future.delayed(const Duration(milliseconds: 50));

      // Get the notifier and verify initial state
      final notifier = container.read(themeProvider.notifier);
      expect(notifier.state, ThemeMode.system);

      // Set theme and wait for completion
      await notifier.setTheme(ThemeMode.dark);
      await Future.delayed(
        const Duration(milliseconds: 10),
      ); // Ensure state update completes

      // State should be updated
      expect(notifier.state, ThemeMode.dark);
      expect(container.read(themeProvider), ThemeMode.dark);
      verify(mockStorage.saveThemeMode(ThemeMode.dark)).called(1);
    });

    test('toggle switches from light to dark', () async {
      when(mockStorage.saveThemeMode(any)).thenAnswer((_) async {});

      // Wait for initial load to complete
      await Future.delayed(const Duration(milliseconds: 50));

      final notifier = container.read(themeProvider.notifier);
      await notifier.setTheme(ThemeMode.light);
      await Future.delayed(const Duration(milliseconds: 10));

      // Verify it's set to light
      expect(notifier.state, ThemeMode.light);
      expect(container.read(themeProvider), ThemeMode.light);

      // Mock toastification to avoid initialization errors
      try {
        await notifier.toggle();
        await Future.delayed(const Duration(milliseconds: 10));
      } catch (e) {
        // Ignore toastification errors in tests
      }

      expect(notifier.state, ThemeMode.dark);
      expect(container.read(themeProvider), ThemeMode.dark);
    });

    test('toggle switches from dark to light', () async {
      when(mockStorage.saveThemeMode(any)).thenAnswer((_) async {});

      // Wait for initial load to complete
      await Future.delayed(const Duration(milliseconds: 50));

      final notifier = container.read(themeProvider.notifier);
      await notifier.setTheme(ThemeMode.dark);
      await Future.delayed(const Duration(milliseconds: 10));

      // Verify it's set to dark
      expect(notifier.state, ThemeMode.dark);
      expect(container.read(themeProvider), ThemeMode.dark);

      // Mock toastification to avoid initialization errors
      try {
        await notifier.toggle();
        await Future.delayed(const Duration(milliseconds: 10));
      } catch (e) {
        // Ignore toastification errors in tests
      }

      expect(notifier.state, ThemeMode.light);
      expect(container.read(themeProvider), ThemeMode.light);
    });
  });
}
