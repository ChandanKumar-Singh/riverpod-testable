import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/shared/localization/lang_provider.dart';
import 'package:testable/shared/localization/lang_storage.dart';
import 'package:testable/shared/localization/supported_locales.dart';
import 'lang_provider_test.mocks.dart';

@GenerateMocks([LangStorage])
void main() {
  group('LangNotifier', () {
    late ProviderContainer container;
    late MockLangStorage mockStorage;

    setUp(() {
      mockStorage = MockLangStorage();
      when(mockStorage.loadLocale())
          .thenAnswer((_) async => SupportedLocales.en);
      container = ProviderContainer(
        overrides: [
          langProvider.overrideWith((ref) => LangNotifier(mockStorage)),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initializes with English locale', () async {
      await Future.delayed(const Duration(milliseconds: 10));
      final state = container.read(langProvider);
      expect(state, SupportedLocales.en);
    });

    test('setLocale updates locale and saves to storage', () async {
      when(mockStorage.saveLocale(any)).thenAnswer((_) async {});
      
      final notifier = container.read(langProvider.notifier);
      await notifier.setLocale(SupportedLocales.hi);

      final state = container.read(langProvider);
      expect(state, SupportedLocales.hi);
      verify(mockStorage.saveLocale(SupportedLocales.hi)).called(1);
    });

    test('nextLocale cycles through all locales', () async {
      when(mockStorage.saveLocale(any)).thenAnswer((_) async {});
      
      final notifier = container.read(langProvider.notifier);
      
      // Start with English
      await notifier.setLocale(SupportedLocales.en);
      expect(container.read(langProvider), SupportedLocales.en);

      // Next should be Hindi
      await notifier.nextLocale();
      expect(container.read(langProvider), SupportedLocales.hi);

      // Next should cycle back to English
      await notifier.nextLocale();
      expect(container.read(langProvider), SupportedLocales.en);
    });
  });
}

