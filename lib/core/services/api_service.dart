// lib/core/network/api_service.dart
import 'dart:async';
import 'package:dio/dio.dart';

import 'package:testable/core/config/env.dart';
import 'package:testable/core/network/dio/http_client.dart';
import 'package:testable/core/network/dio/models/api_response.dart';
import 'package:testable/core/utils/logger.dart';

enum ApiMethod { get, post, put, delete, patch, head, options }

class ApiService {
  ApiService({
    required AppHttpClient client,
    required this.logger,
    required this.env,
  }) : _client = client;

  final AppHttpClient _client;
  final AppLogger logger;
  final Env env;

  /// Single unified request method with enhanced error handling
  Future<ApiResponse<R>> request<R>(
    String path, {
    ApiMethod method = ApiMethod.post,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
    Duration? timeout,
    R Function(Map<String, dynamic>)? fromJson,
    List<R> Function(List<dynamic>)? fromJsonList,
    int maxRetries = 0,
    Duration retryDelay = const Duration(milliseconds: 300),
    Map<String, dynamic>? extra,
  }) async {
    int attempt = 0;
    while (true) {
      attempt++;
      try {
        final resp = await _client.request(
          path,
          method: method.name.toUpperCase(),
          queryParameters: queryParameters,
          data: body,
          headers: headers,
          cancelToken: cancelToken,
          timeout: timeout,
          extra: {...?extra, 'requiresAuth': requiresAuth},
        );

        return _mapResponse<R>(
          resp,
          fromJson: fromJson,
          fromJsonList: fromJsonList,
        );
      } on DioException catch (e, st) {
        final enhancedError = _enhanceDioException(e);
        final statusCode = e.response?.statusCode;

        logger.e(
          'Request failed [$path] (attempt $attempt/${maxRetries + 1}) '
          'code=$statusCode, type=${e.type}',
          e: enhancedError,
          st: st,
          tag: 'ApiService',
        );

        // Handle authentication errors
        if ((statusCode == 401 || statusCode == 403) &&
            env.refreshTokenEnabled &&
            attempt == 1) {
          // Only try refresh on first attempt
          final refreshed = await _tryRefreshToken();
          if (refreshed) {
            await Future.delayed(retryDelay);
            continue; // retry with new token
          }
          // If refresh failed, return auth error
          return ApiResponse<R>.error(
            message: enhancedError.$1 ?? 'Authentication failed',
            statusCode: statusCode ?? 401,
            error: enhancedError,
            // data: _extractErrorData(e),
          );
        }

        // Handle cancellation
        if (e.type == DioExceptionType.cancel) {
          return ApiResponse<R>.error(
            message: 'Request cancelled',
            statusCode: e.response?.statusCode,
            error: enhancedError.$2,
            // data: _extractErrorData(e),
          );
        }

        // Handle timeout errors
        if (_isTimeoutError(e)) {
          return ApiResponse<R>.error(
            message: 'Request timeout',
            statusCode: e.response?.statusCode,
            error: enhancedError.$2,
            // data: _extractErrorData(e),
          );
        }

        // Handle connection errors
        if (_isConnectionError(e)) {
          return ApiResponse<R>.error(
            message:
                'Connection failed. Please check your internet connection.',
            statusCode: e.response?.statusCode,
            error: enhancedError.$2,
            // data: _extractErrorData(e),
          );
        }

        // Handle server errors (5xx)
        if (statusCode != null && statusCode >= 500) {
          return ApiResponse<R>.error(
            message: 'Server error. Please try again later.',
            statusCode: statusCode,
            error: enhancedError.$2,
            // data: _extractErrorData(e),
          );
        }

        // Handle client errors (4xx) with specific messages
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return ApiResponse<R>.error(
            message: enhancedError.$1 ?? 'Client error',
            statusCode: statusCode,
            error: enhancedError.$2,
            // data: _extractErrorData(e),
          );
        }

        // Retry logic for transient errors
        if (_isTransientError(e) && attempt <= maxRetries) {
          logger.i(
            'Retrying request (attempt $attempt/$maxRetries)...',
            tag: 'ApiService',
          );
          await Future.delayed(retryDelay * attempt);
          continue;
        }

        // Final error response for non-retryable or max-retry-exceeded errors
        return ApiResponse<R>.error(
          message: enhancedError.$1 ?? 'Network request failed',
          statusCode: statusCode,
          error: enhancedError,
          stackTrace: st,
          // data: _extractErrorData(e),
        );
      } catch (e, st) {
        logger.e(
          'Unexpected error in ApiService.request',
          e: e,
          st: st,
          tag: 'ApiService',
        );

        // Handle non-Dio exceptions
        return ApiResponse<R>.error(
          message: _getUnexpectedErrorMessage(e),
          error: e,
          stackTrace: st,
        );
      }
    }
  }

  /// Enhanced DioException with better error messages and extracted data
  (String?, Map<String, dynamic>?) _enhanceDioException(DioException e) {
    final String? enhancedMessage = _extractErrorMessageFromDioError(e);
    final Map<String, dynamic>? errorData = _extractErrorData(e);

    return (enhancedMessage, errorData);
  }

  /// Extract meaningful error message from DioException
  String? _extractErrorMessageFromDioError(DioException e) {
    // First, try to extract from response data
    final responseData = e.response?.data;

    if (responseData is Map<String, dynamic>) {
      return responseData['message']?.toString() ??
          responseData['error']?.toString() ??
          responseData['detail']?.toString() ??
          responseData['description']?.toString() ??
          _getDefaultErrorMessage(e);
    }

    if (responseData is String && responseData.isNotEmpty) {
      return responseData;
    }

    // Fall back to type-based messages
    return _getDefaultErrorMessage(e);
  }

  /// Get default error message based on DioException type
  String _getDefaultErrorMessage(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout => 'Connection timeout',
      DioExceptionType.sendTimeout => 'Send timeout',
      DioExceptionType.receiveTimeout => 'Receive timeout',
      DioExceptionType.connectionError => 'Connection failed',
      DioExceptionType.badCertificate => 'Invalid certificate',
      DioExceptionType.badResponse => 'Invalid response from server',
      DioExceptionType.cancel => 'Request cancelled',
      DioExceptionType.unknown => 'Unknown network error',
    };
  }

  /// Extract error data from DioException for debugging
  Map<String, dynamic>? _extractErrorData(DioException e) {
    final responseData = e.response?.data;

    if (responseData is Map<String, dynamic>) {
      return responseData;
    }

    if (responseData != null) {
      return {'raw_response': responseData.toString()};
    }

    return null;
  }

  /// Get message for unexpected (non-Dio) errors
  String _getUnexpectedErrorMessage(dynamic error) {
    if (error is FormatException) {
      return 'Data format error';
    } else if (error is TypeError) {
      return 'Type conversion error';
    } else if (error is StateError) {
      return 'Application state error';
    }
    return 'Unexpected error occurred';
  }

  /// Enhanced transient error detection
  bool _isTransientError(DioException e) {
    return _isTimeoutError(e) || _isConnectionError(e);
  }

  bool _isTimeoutError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout;
  }

  bool _isConnectionError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown;
  }

  /// Map Dio Response to ApiResponse<R> using provided converters
  ApiResponse<R> _mapResponse<R>(
    Response<dynamic> resp, {
    R Function(Map<String, dynamic>)? fromJson,
    List<R> Function(List<dynamic>)? fromJsonList,
  }) {
    final status = resp.statusCode ?? 500;
    final raw = resp.data;

    // Success status codes (2xx)
    if (status >= 200 && status < 300) {
      return _handleSuccessResponse<R>(
        raw,
        status: status,
        fromJson: fromJson,
        fromJsonList: fromJsonList,
      );
    }

    // Error status codes
    return _handleErrorResponse<R>(raw, status: status);
  }

  /// Handle successful responses (2xx)
  ApiResponse<R> _handleSuccessResponse<R>(
    dynamic raw, {
    required int status,
    R Function(Map<String, dynamic>)? fromJson,
    List<R> Function(List<dynamic>)? fromJsonList,
  }) {
    // If the backend uses a standardized wrapper
    if (raw is Map<String, dynamic>) {
      final hasResponseCode =
          raw.containsKey('response_code') || raw.containsKey('success');

      if (hasResponseCode) {
        final bool success =
            (raw['response_code'] == 1) || (raw['success'] == true);
        final message = (raw['response_message'] ?? raw['message']) as String?;
        final obj = raw['response_obj'] ?? raw['data'] ?? raw['payload'];

        if (success) {
          return _parseSuccessData<R>(
            obj,
            message: message,
            status: status,
            fromJson: fromJson,
            fromJsonList: fromJsonList,
          );
        } else {
          // Backend signalled failure with success=false
          return ApiResponse<R>.error(
            message: message ?? 'Request failed',
            statusCode: status,
            error: obj,
            // data: obj,
          );
        }
      }
    }

    // Direct response without wrapper
    return _parseSuccessData<R>(
      raw,
      status: status,
      fromJson: fromJson,
      fromJsonList: fromJsonList,
    );
  }

  /// Parse successful response data
  ApiResponse<R> _parseSuccessData<R>(
    dynamic data, {
    required int status,
    String? message,
    R Function(Map<String, dynamic>)? fromJson,
    List<R> Function(List<dynamic>)? fromJsonList,
  }) {
    try {
      // Handle null data
      if (data == null) {
        if (R == Null) {
          return ApiResponse<R>.success(
            data: null as R,
            message: message,
            statusCode: status,
          );
        }
        return ApiResponse<R>.error(
          message: 'Response data is null',
          statusCode: status,
        );
      }

      // Handle list data
      if (data is List) {
        if (fromJsonList != null) {
          final parsedList = fromJsonList(data);
          return ApiResponse<R>.success(
            data: parsedList as R,
            message: message,
            statusCode: status,
          );
        } else if (fromJson != null) {
          final items = data
              .whereType<Map<String, dynamic>>()
              .map(fromJson)
              .toList();
          return ApiResponse<R>.success(
            data: items as R,
            message: message,
            statusCode: status,
          );
        } else {
          // Direct cast for primitive lists
          try {
            return ApiResponse<R>.success(
              data: data as R,
              message: message,
              statusCode: status,
            );
          } catch (castError) {
            return ApiResponse<R>.error(
              message: 'Type cast failed for list data',
              error: castError,
              statusCode: status,
            );
          }
        }
      }

      // Handle object data
      if (data is Map<String, dynamic>) {
        if (fromJson != null) {
          final parsed = fromJson(data);
          return ApiResponse<R>.success(
            data: parsed,
            message: message,
            statusCode: status,
          );
        } else {
          final parsed = parseDynamicToType<R>(data, fromJson: fromJson);
          if (parsed != null) {
            return ApiResponse<R>.success(
              data: parsed,
              message: message,
              statusCode: status,
            );
          }

          // Fallback: cast for primitive types
          try {
            return ApiResponse<R>.success(
              data: data as R,
              message: message,
              statusCode: status,
            );
          } catch (castError) {
            return ApiResponse<R>.error(
              message: 'Type cast failed for map data',
              error: castError,
              statusCode: status,
            );
          }
        }
      }

      // Handle scalar values (String, int, bool, etc.)
      try {
        return ApiResponse<R>.success(
          data: data as R,
          message: message,
          statusCode: status,
        );
      } catch (castError) {
        return ApiResponse<R>.error(
          message: 'Type cast failed for scalar data',
          error: castError,
          statusCode: status,
        );
      }
    } catch (e, st) {
      logger.e(
        'Error parsing success response',
        e: e,
        st: st,
        tag: 'ApiService',
      );
      return ApiResponse<R>.error(
        message: 'Failed to parse response data',
        error: e,
        stackTrace: st,
        statusCode: status,
      );
    }
  }

  /// Handle error responses
  ApiResponse<R> _handleErrorResponse<R>(dynamic raw, {required int status}) {
    String? message;
    dynamic errorData;

    if (raw is Map<String, dynamic>) {
      message = (raw['response_message'] ?? raw['message']) as String?;
      errorData = raw['response_obj'] ?? raw['data'] ?? raw['payload'];
      raw['error']?.toString() ?? raw['detail']?.toString() ?? message;
    } else if (raw is String) {
      message = raw.isNotEmpty ? raw : message;
    }

    return ApiResponse<R>.error(
      message: message,
      statusCode: status,
      error: errorData,
      // data: errorData,
    );
  }

  Future<bool> _tryRefreshToken() async {
    // Implementation depends on your token refresh logic
    // if (!env.refreshTokenEnabled || env.refreshTokenHandler == null) {
    //   return false;
    // }
    // try {
    //   logger.i('Attempting token refresh', 'ApiService');
    //   // return await env.refreshTokenHandler!();
    // } catch (e, st) {
    //   logger.e('Refresh token failed', e: e, st: st, tag: 'ApiService');
    //   return false;
    // }
    return false;
  }
}

// Helper function (assuming it exists elsewhere)
R? parseDynamicToType<R>(
  dynamic data, {
  R Function(Map<String, dynamic>)? fromJson,
}) {
  // Your implementation here
  try {
    if (fromJson != null && data is Map<String, dynamic>) {
      return fromJson(data);
    }

    // Handle primitive types
    if (R == String && data != null) return data.toString() as R;
    if (R == int && data is int) return data as R;
    if (R == double && data is double) return data as R;
    if (R == bool && data is bool) return data as R;
    if (R == dynamic) return data as R;

    return null;
  } catch (_) {
    return null;
  }
}
