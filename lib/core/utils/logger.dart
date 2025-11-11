// core/utils/logger.dart
import 'package:logger/logger.dart';

/// Simple, configurable logger wrapper using the logger package
class AppLogger {
  AppLogger({
    String name = 'AppLogger',
    bool enabled = true,
    LogLevel minLevel = LogLevel.info,
    bool showEmojis = true,
    bool colors = true,
  }) : _enabled = enabled,
       _minLevel = minLevel,
       _showEmojis = showEmojis {
    _logger = Logger(
      filter: _enabled ? ProductionFilter() : CustomFilter(),
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 80,
        colors: colors,
        printEmojis: showEmojis,
        dateTimeFormat: DateTimeFormat.dateAndTime,
        // noBoxingByDefault: true,
      ),
      output: ConsoleOutput(),
    );
  }

  late final Logger _logger;
  final bool _enabled;
  final LogLevel _minLevel;
  final bool _showEmojis;

  Level _toLoggerLevel(LogLevel level) {
    return switch (level) {
      LogLevel.verbose => Level.trace,
      LogLevel.debug => Level.debug,
      LogLevel.info => Level.info,
      LogLevel.warning => Level.warning,
      LogLevel.error => Level.error,
      LogLevel.fatal => Level.fatal,
    };
  }

  bool _shouldLog(LogLevel level) {
    return _enabled && level.i >= _minLevel.i;
  }

  // Public logging methods
  void v(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.verbose)) return;
    final formattedMessage = _formatMessage(message, tag);
    _logger.t(formattedMessage, error: e, stackTrace: st);
  }

  void d(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.debug)) return;
    final formattedMessage = _formatMessage(message, tag);
    _logger.d(formattedMessage, error: e, stackTrace: st);
  }

  void i(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.info)) return;
    final formattedMessage = _formatMessage(message, tag);
    _logger.i(formattedMessage, error: e, stackTrace: st);
  }

  void w(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.warning)) return;
    final formattedMessage = _formatMessage(message, tag);
    _logger.w(formattedMessage, error: e, stackTrace: st);
  }

  void e(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.error)) return;
    final formattedMessage = _formatMessage(message, tag);
    _logger.e(formattedMessage, error: e, stackTrace: st);
  }

  void f(String message, {Object? e, StackTrace? st, String? tag}) {
    if (!_shouldLog(LogLevel.fatal)) return;
    final formattedMessage = _formatMessage(message, tag);
    _logger.f(formattedMessage, error: e, stackTrace: st);
  }

  String _formatMessage(String message, String? tag) {
    return (tag != null && tag.isNotEmpty) ? '[$tag] $message' : message;
  }

  /// Network request logging with custom formatting
  void network(
    String method,
    String url, {
    int? statusCode,
    Duration? duration,
    Map<String, dynamic>? requestHeaders,
    Map<String, dynamic>? responseHeaders,
    dynamic requestBody,
    dynamic responseBody,
  }) {
    if (!_shouldLog(LogLevel.info)) return;

    final durationMsg = duration != null
        ? ' (${duration.inMilliseconds}ms)'
        : '';
    final statusEmoji = _getStatusEmoji(statusCode);
    final statusCodeMsg = statusCode != null ? ' $statusCode' : '';

    final message = '$statusEmoji $method $url$statusCodeMsg$durationMsg';

    if (_shouldLog(LogLevel.debug)) {
      // Log detailed network info for debug level
      final buffer = StringBuffer(message);

      if (requestHeaders != null && requestHeaders.isNotEmpty) {
        buffer.write('\n📤 Request Headers: $requestHeaders');
      }

      if (requestBody != null) {
        buffer.write('\n📦 Request Body: $requestBody');
      }

      if (responseHeaders != null && responseHeaders.isNotEmpty) {
        buffer.write('\n📥 Response Headers: $responseHeaders');
      }

      if (responseBody != null) {
        buffer.write('\n📨 Response Body: $responseBody');
      }

      _logger.d(buffer.toString());
    } else {
      _logger.i(message);
    }
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

  /// Log JSON data in a pretty format
  void json(
    String message, {
    dynamic data,
    String? tag,
    LogLevel level = LogLevel.debug,
  }) {
    if (!_shouldLog(level)) return;

    final formattedMessage = _formatMessage(message, tag);

    // Create a custom printer for JSON that doesn't add extra formatting
    final jsonPrinter = PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 0,
      lineLength: 120,
      colors: true,
      printEmojis: false,
      printTime: false,
      noBoxingByDefault: true,
    );

    final jsonLogger = Logger(printer: jsonPrinter);

    final fullMessage = data != null
        ? '$formattedMessage\n${_formatJsonData(data)}'
        : formattedMessage;

    switch (level) {
      case LogLevel.verbose:
        jsonLogger.v(fullMessage);
      case LogLevel.debug:
        jsonLogger.d(fullMessage);
      case LogLevel.info:
        jsonLogger.i(fullMessage);
      case LogLevel.warning:
        jsonLogger.w(fullMessage);
      case LogLevel.error:
        jsonLogger.e(fullMessage);
      case LogLevel.fatal:
        jsonLogger.wtf(fullMessage);
    }
  }

  String _formatJsonData(dynamic data) {
    if (data is Map || data is List) {
      try {
        // Pretty print JSON-like data
        final indent = '  ';
        final pattern = RegExp(r'^', multiLine: true);
        return data.toString().replaceAll(pattern, indent);
      } catch (_) {
        return data.toString();
      }
    }
    return data.toString();
  }

  /// Close/dispose the logger (useful for file logging if implemented)
  void dispose() {
    // The logger package doesn't require disposal for basic console logging
    // This is here for future compatibility if you add file output
  }
}

/// Custom filter to handle disabled state
class CustomFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false; // Always return false when disabled
  }
}

/// Log levels enum (mapped to logger package levels)
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

// Example usage:
/*
final logger = AppLogger(
  enabled: true,
  minLevel: LogLevel.debug,
  showEmojis: true,
);

// Basic logging
logger.d('Debug message');
logger.i('Info message');
logger.e('Error message', e: exception, st: stackTrace);

// Network logging
logger.network(
  'GET',
  'https://api.example.com/users',
  statusCode: 200,
  duration: Duration(milliseconds: 150),
);

// JSON logging
logger.json(
  'API Response',
  data: {'id': 1, 'name': 'John'},
  level: LogLevel.debug,
);
*/
