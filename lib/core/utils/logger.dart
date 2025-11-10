// FEATURE: Logger

// core/utils/logger.dart
import 'package:logging/logging.dart';

/// Simple, configurable logger wrapper
class AppLogger {
  AppLogger({
    String name = 'AppLogger',
    bool enabled = true,
    LogLevel minLevel = LogLevel.info,
    bool showEmojis = true,
  }) : _logger = Logger(name),
       _enabled = enabled,
       _minLevel = minLevel,
       _showEmojis = showEmojis {
    _setupLogging();
  }
  final Logger _logger;
  final bool _enabled;
  final LogLevel _minLevel;
  final bool _showEmojis;

  void _setupLogging() {
    if (!_enabled) return;

    Logger.root.level = _toLoggingLevel(_minLevel);

    Logger.root.onRecord.listen((record) {
      final emoji = _showEmojis ? _getLevelEmoji(record.level) : '';
      final levelName = record.level.name.toUpperCase().padRight(7);

      _print('$emoji [$levelName] ${record.loggerName}: ${record.message}');

      if (record.error != null) {
        _print(record.error);
      }

      if (record.stackTrace != null) {
        _print('   STACK: ${record.stackTrace}');
      }
    });
  }

  void _print(dynamic record) => print('   ERROR: $record');

  Level _toLoggingLevel(LogLevel level) {
    return switch (level) {
      LogLevel.verbose => Level.ALL,
      LogLevel.debug => Level.FINE,
      LogLevel.info => Level.INFO,
      LogLevel.warning => Level.WARNING,
      LogLevel.error => Level.SEVERE,
      LogLevel.fatal => Level.SHOUT,
    };
  }

  String _getLevelEmoji(Level level) {
    return switch (level) {
      Level.FINEST || Level.FINER || Level.FINE || Level.CONFIG => '🔍',
      Level.INFO => '💡',
      Level.WARNING => '⚠️',
      Level.SEVERE => '❌',
      Level.SHOUT => '💀',
      _ => '📝',
    };
  }

  bool _shouldLog(LogLevel level) {
    return _enabled && level.index >= _minLevel.index;
  }

  // Public logging methods
  void v(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.verbose)) return;
    _logger.fine(((tag ?? '').isNotEmpty ? '[$tag] ' : '') + message, e, st);
  }

  void d(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.debug)) return;
    _logger.info(
      ((tag ?? '').isNotEmpty ? '[$tag] ' : '') + message,
      e,
      st,
    ); // Using INFO for debug to ensure it shows
  }

  void i(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.info)) return;
    _logger.info(((tag ?? '').isNotEmpty ? '[$tag] ' : '') + message, e, st);
  }

  void w(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.warning)) return;
    _logger.warning(((tag ?? '').isNotEmpty ? '[$tag] ' : '') + message, e, st);
  }

  void e(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.error)) return;
    _logger.severe(((tag ?? '').isNotEmpty ? '[$tag] ' : '') + message, e, st);
  }

  void f(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.fatal)) return;
    _logger.shout(((tag ?? '').isNotEmpty ? '[$tag] ' : '') + message, e, st);
  }

  /// Network request logging
  void network(
    String method,
    String url, {
    int? statusCode,
    Duration? duration,
  }) {
    if (!_shouldLog(LogLevel.info)) return;

    final durationMsg = duration != null
        ? ' (${duration.inMilliseconds}ms)'
        : '';
    final statusEmoji = _getStatusEmoji(statusCode);

    i('$statusEmoji $method $url$durationMsg');
  }

  String _getStatusEmoji(int? statusCode) {
    if (statusCode == null) return '🔵';
    return switch (statusCode ~/ 100) {
      2 => '🟢',
      3 => '🔵',
      4 => '🟡',
      5 => '🔴',
      _ => '⚪',
    };
  }
}

/// Log levels enum
enum LogLevel {
  verbose(0),
  debug(1),
  info(2),
  warning(3),
  error(4),
  fatal(5);

  const LogLevel(this.i);
  final int i;
}
