// test/core/observers/app_error_handler_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/observers/app_error_handler.dart';
import 'package:testable/core/utils/logger.dart';

void main() {
  group('AppErrorHandler', () {
     AppLogger logger = AppLogger();

    setUpAll(() {
      logger = AppLogger(enabled: true);
    });

    // Test the singleton behavior
    test('is a singleton', () {
      final handler1 = AppErrorHandler();
      final handler2 = AppErrorHandler();
      expect(handler1, same(handler2));
    });

    // Test initialization
    test('initializes without throwing', () {
      final handler = AppErrorHandler();
      expect(() => handler.initialize(logger), returnsNormally);
    });

    // Since it's a singleton, we need to test in a single test
    test('complete handler lifecycle', () {
      final handler = AppErrorHandler();

      // Initialize
      expect(() => handler.initialize(logger), returnsNormally);

      // Test report with regular error
      final regularError = Exception('Regular error');
      expect(() => handler.report(regularError), returnsNormally);

      // Test report with asset error
      final assetError = Exception('Unable to load asset: test.svg');
      expect(() => handler.report(assetError), returnsNormally);
    });

    // Test that initialize can be called multiple times (should not throw)
    test('initialize is idempotent', () {
      final handler = AppErrorHandler();
      handler.initialize(logger);

      // Second call should not throw (idempotent)
      expect(() => handler.initialize(logger), returnsNormally);
    });
  });

  group('RiverpodErrorObserver', () {
    // ... keep existing tests unchanged
    test('creates observer with logger', () {
      final logger = AppLogger(enabled: false);
      final observer = RiverpodErrorObserver(logger);
      expect(observer.logger, same(logger));
    });

    test('providerDidFail does not throw', () {
      final logger = AppLogger(enabled: false);
      final observer = RiverpodErrorObserver(logger);

      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
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
  });
}
