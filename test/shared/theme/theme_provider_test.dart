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
      when(mockStorage.loadThemeMode())
          .thenAnswer((_) async => ThemeMode.system);
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
      
      final notifier = container.read(themeProvider.notifier);
      await notifier.setTheme(ThemeMode.dark);

      final state = container.read(themeProvider);
      expect(state, ThemeMode.dark);
      verify(mockStorage.saveThemeMode(ThemeMode.dark)).called(1);
    });

    test('toggle switches from light to dark', () async {
      when(mockStorage.saveThemeMode(any)).thenAnswer((_) async {});
      
      final notifier = container.read(themeProvider.notifier);
      await notifier.setTheme(ThemeMode.light);
      await notifier.toggle();

      final state = container.read(themeProvider);
      expect(state, ThemeMode.dark);
    });

    test('toggle switches from dark to light', () async {
      when(mockStorage.saveThemeMode(any)).thenAnswer((_) async {});
      
      final notifier = container.read(themeProvider.notifier);
      await notifier.setTheme(ThemeMode.dark);
      await notifier.toggle();

      final state = container.read(themeProvider);
      expect(state, ThemeMode.light);
    });
  });
}

