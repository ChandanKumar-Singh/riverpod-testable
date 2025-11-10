// FEATURE: Error Observers

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:testable/core/di/providers.dart';
import 'package:testable/core/utils/logger.dart';

/// Central error handler (singleton)
class AppErrorHandler {
  factory AppErrorHandler() => _instance;
  AppErrorHandler._internal();
  static final AppErrorHandler _instance = AppErrorHandler._internal();

  late final AppLogger _logger;

  void initialize(AppLogger logger) {
    _logger = logger;

    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _logger.e('FlutterError', e: details.exception, st: details.stack);
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      } else {
        _handleError(details.exception, details.stack);
      }
    };

    // Catch Dart async zone errors
    runZonedGuarded(
      () async {
        _logger.i('Global error zone initialized ✅');
      },
      (error, stack) {
        _handleError(error, stack);
      },
    );
  }

  void _handleError(Object error, StackTrace? stack) {
    _logger.e('Unhandled exception', e: error, st: stack);

    // Show feedback in release mode only
    if (!kDebugMode) {
      // AppToastification.error(
      //   'Something went wrong. Please try again later.',
      //   title: 'Unexpected Error',
      // );
    }
  }

  /// Optional: manually report caught exceptions
  void report(Object error, [StackTrace? stack]) {
    _handleError(error, stack);
  }
}

/// Riverpod provider for error handler
final appErrorHandlerProvider = Provider<AppErrorHandler>((ref) {
  final logger = ref.read(loggerProvider);
  final handler = AppErrorHandler()..initialize(logger);
  return handler;
});

/// Hook into Riverpod’s error reporting
class RiverpodErrorObserver extends ProviderObserver {
  RiverpodErrorObserver(this.logger);
  final AppLogger logger;

  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    logger.e(
      'Riverpod provider error in ${provider.name ?? provider.runtimeType}',
      e: error,
      st: stackTrace,
    );
  }
}
