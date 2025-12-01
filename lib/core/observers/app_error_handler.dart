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

   AppLogger? _logger;

  void initialize(AppLogger logger) {
    _logger = logger;

    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      // Check if this is an asset loading error that should be ignored
      if (_isAssetLoadingError(details)) {
        // Silently ignore asset loading errors - don't log them
        return;
      }

      _logger?.e(
        'FlutterError ${details.exception}',
        e: details.exception,
        st: details.stack,
      );
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      } else {
        _handleError(details.exception, details.stack);
      }
    };

    // Catch Dart async zone errors
    runZonedGuarded(
      () async {
        _logger?.i('Global error zone initialized ✅');
      },
      (error, stack) {
        // Check if this is an asset loading error
        if (_isAssetException(error)) {
          // Silently ignore asset loading errors
          return;
        }
        _handleError(error, stack);
      },
    );
  }

  /// Detect asset loading errors from FlutterErrorDetails
  bool _isAssetLoadingError(FlutterErrorDetails details) {
    final exception = details.exception;
    final stack = details.stack;

    return _isAssetException(exception) || _isAssetStackTrace(stack);
  }

  /// Detect asset loading errors from exceptions
  bool _isAssetException(Object error) {
    final errorString = error.toString();

    // Check for asset-related error patterns
    final isAssetError =
        errorString.contains('Unable to load asset:') ||
        errorString.contains('Asset not found') ||
        errorString.contains('PlatformAssetBundle.loadBuffer') ||
        errorString.contains('AssetBundleImageProvider._loadAsync');

    return isAssetError;
  }

  /// Detect asset loading errors from stack traces
  bool _isAssetStackTrace(StackTrace? stack) {
    if (stack == null) return false;

    final stackString = stack.toString();

    // Check for asset-related stack trace patterns
    final isAssetStack =
        stackString.contains('PlatformAssetBundle.loadBuffer') ||
        stackString.contains('AssetBundleImageProvider._loadAsync') ||
        stackString.contains(
          'MultiFrameImageStreamCompleter._handleCodecReady',
        );

    return isAssetStack;
  }

  void _handleError(Object error, StackTrace? stack) {
    // Double-check if it's an asset error (in case it slipped through)
    if (_isAssetException(error) || _isAssetStackTrace(stack)) {
      return; // Silently ignore
    }

    _logger?.e('Unhandled exception', e: error, st: stack);

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
    // Check if this is an asset loading error that should be ignored
    if (_isAssetException(error) || _isAssetStackTrace(stack)) {
      return; // Silently ignore
    }
    _handleError(error, stack);
  }
}

/// Riverpod provider for error handler
final appErrorHandlerProvider = Provider<AppErrorHandler>((ref) {
  final logger = ref.read(loggerProvider);
  final handler = AppErrorHandler()..initialize(logger);
  return handler;
});

/// Hook into Riverpod's error reporting
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
    // Check if this is an asset loading error
    if (_isAssetException(error) || _isAssetStackTrace(stackTrace)) {
      return; // Silently ignore
    }

    logger.e(
      'Riverpod provider error in ${provider.name ?? provider.runtimeType}',
      e: error,
      st: stackTrace,
    );
  }

  /// Detect asset loading errors from exceptions
  bool _isAssetException(Object error) {
    final errorString = error.toString();

    // Check for asset-related error patterns
    final isAssetError =
        errorString.contains('Unable to load asset:') ||
        errorString.contains('Asset not found') ||
        errorString.contains('PlatformAssetBundle.loadBuffer') ||
        errorString.contains('AssetBundleImageProvider._loadAsync');

    return isAssetError;
  }

  /// Detect asset loading errors from stack traces
  bool _isAssetStackTrace(StackTrace? stack) {
    if (stack == null) return false;

    final stackString = stack.toString();

    // Check for asset-related stack trace patterns
    final isAssetStack =
        stackString.contains('PlatformAssetBundle.loadBuffer') ||
        stackString.contains('AssetBundleImageProvider._loadAsync') ||
        stackString.contains(
          'MultiFrameImageStreamCompleter._handleCodecReady',
        );

    return isAssetStack;
  }
}
