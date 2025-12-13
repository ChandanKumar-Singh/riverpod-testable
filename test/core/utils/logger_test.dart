import 'package:flutter_test/flutter_test.dart';
import 'package:testable/core/utils/logger.dart';

void main() {
  group('AppLogger', () {
    test('creates logger with default settings', () {
      final logger = AppLogger();
      expect(logger, isNotNull);
    });

    /*     test('creates logger with disabled logging', () {
      final logger = AppLogger(enabled: false);
      expect(logger, isNotNull);
      // Should not throw when logging is disabled
      logger.d('Test message');
      logger.i('Test message');
      logger.e('Test message');
    });

    test('creates logger with custom log level', () {
      final logger = AppLogger(
        enabled: true,
        minLevel: LogLevel.warning,
      );
      expect(logger, isNotNull);
    });

    test('logger methods do not throw', () {
      final logger = AppLogger(enabled: true);
      
      expect(() => logger.v('Verbose message'), returnsNormally);
      expect(() => logger.d('Debug message'), returnsNormally);
      expect(() => logger.i('Info message'), returnsNormally);
      expect(() => logger.w('Warning message'), returnsNormally);
      expect(() => logger.e('Error message'), returnsNormally);
      expect(() => logger.f('Fatal message'), returnsNormally);
    });

    test('logger methods with tags do not throw', () {
      final logger = AppLogger(enabled: true);
      
      expect(() => logger.v('Message', tag: 'Test'), returnsNormally);
      expect(() => logger.d('Message', tag: 'Test'), returnsNormally);
      expect(() => logger.i('Message', tag: 'Test'), returnsNormally);
      expect(() => logger.w('Message', tag: 'Test'), returnsNormally);
      expect(() => logger.e('Message', tag: 'Test'), returnsNormally);
      expect(() => logger.f('Message', tag: 'Test'), returnsNormally);
    });

    test('logger methods with errors do not throw', () {
      final logger = AppLogger(enabled: true);
      final error = Exception('Test error');
      
      expect(() => logger.e('Error message', e: error), returnsNormally);
      expect(() => logger.f('Fatal message', e: error), returnsNormally);
    });

    test('network logging does not throw', () {
      final logger = AppLogger(enabled: true);
      
      expect(() => logger.network(
        'GET',
        'https://example.com',
        statusCode: 200,
        duration: const Duration(milliseconds: 100),
      ), returnsNormally);
    });

    test('json logging does not throw', () {
      final logger = AppLogger(enabled: true);
      
      expect(() => logger.json(
        'JSON data',
        data: {'key': 'value'},
        tag: 'Test',
      ), returnsNormally);
    });

    test('dispose does not throw', () {
      final logger = AppLogger();
      expect(() => logger.dispose(), returnsNormally);
    });
   */
  });

  /*   group('LogLevel', () {
    test('LogLevel has correct values', () {
      expect(LogLevel.verbose.i, 0);
      expect(LogLevel.debug.i, 1);
      expect(LogLevel.info.i, 2);
      expect(LogLevel.warning.i, 3);
      expect(LogLevel.error.i, 4);
      expect(LogLevel.fatal.i, 5);
    });
  }); */
}
