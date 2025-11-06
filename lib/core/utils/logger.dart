// core/utils/logger.dart
import 'dart:developer' as developer;

/// Small logger wrapper to allow swapping implementations in tests/CI.
class AppLogger {
  final bool enabled;

  const AppLogger({this.enabled = true});

  void v(String message, [String? tag]) {
    if (!enabled) return;
    developer.log(message, name: tag ?? 'VERBOSE');
  }

  void i(String message, [String? tag]) {
    if (!enabled) return;
    developer.log(message, name: tag ?? 'INFO');
  }

  void w(String message, [String? tag]) {
    if (!enabled) return;
    developer.log(message, name: tag ?? 'WARN');
  }

  void e(String message, [Object? error, StackTrace? st, String? tag]) {
    if (!enabled) return;
    developer.log(
      '$message ${error ?? ''}',
      name: tag ?? 'ERROR',
      error: error,
      stackTrace: st,
    );
  }
}
