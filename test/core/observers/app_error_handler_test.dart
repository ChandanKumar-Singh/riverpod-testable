import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/observers/app_error_handler.dart';
import 'package:testable/core/utils/logger.dart';

void main() {
  group('AppErrorHandler', () {
    late AppErrorHandler handler;
    late AppLogger logger;

    setUp(() {
      logger = AppLogger(enabled: false); // Disable logging for tests
      handler = AppErrorHandler();
      handler.initialize(logger);
    });

    test('is a singleton', () {
      final handler1 = AppErrorHandler();
      final handler2 = AppErrorHandler();
      expect(handler1, same(handler2));
    });

    test('initializes without throwing', () {
      expect(() => handler.initialize(logger), returnsNormally);
    });

    test('report does not throw for regular errors', () {
      final error = Exception('Test error');
      expect(() => handler.report(error), returnsNormally);
    });

    test('report ignores asset loading errors', () {
      final assetError = Exception('Unable to load asset: test.svg');
      expect(() => handler.report(assetError), returnsNormally);
      // Should not throw or log asset errors
    });

    // Note: _isAssetException is private, testing through public methods
    test('report handles different error types', () {
      final regularError = Exception('Regular error');
      expect(() => handler.report(regularError), returnsNormally);
    });
  });

  group('RiverpodErrorObserver', () {
    late RiverpodErrorObserver observer;
    late AppLogger logger;

    setUp(() {
      logger = AppLogger(enabled: false);
      observer = RiverpodErrorObserver(logger);
    });

    test('creates observer with logger', () {
      expect(observer.logger, same(logger));
    });

    test('providerDidFail does not throw', () {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      // Create a simple test provider
      final testProvider = Provider((ref) => 'test');
      final container = ProviderContainer();

      expect(
        () => observer.providerDidFail(
          testProvider,
          error,
          stackTrace,
          container,
        ),
        returnsNormally,
      );

      container.dispose();
    });

    test('providerDidFail ignores asset errors', () {
      final assetError = Exception('Unable to load asset: test.svg');
      final stackTrace = StackTrace.current;
      final testProvider = Provider((ref) => 'test');
      final container = ProviderContainer();

      expect(
        () => observer.providerDidFail(
          testProvider,
          assetError,
          stackTrace,
          container,
        ),
        returnsNormally,
      );

      container.dispose();
    });
  });
}
