// lib/core/network/api_service.dart
import 'dart:async';
import 'package:dio/dio.dart';

import '../config/env.dart';
import '../network/dio/http_client.dart';
import '../network/dio/models/api_response.dart';
import '../utils/logger.dart';

enum ApiMethod { get, post, put, delete, patch, head, options }

class ApiService {
  final AppHttpClient _client;
  final AppLogger logger;
  final Env env;

  ApiService({
    required AppHttpClient client,
    required this.logger,
    required this.env,
  }) : _client = client;

  /// Single unified request method.
  ///
  /// - method: ApiMethod (default POST)
  /// - requiresAuth: whether to attach Authorization header (uses client's tokenGetter)
  /// - fromJson: converter for single object (Map -> T) when response contains object
  /// - fromJsonList: converter for list (Map -> T) when response contains list
  /// - maxRetries + retryDelay for basic retry/backoff
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
    final header = {...?headers,
    
    };
    if(requiresAuth){
      // ADD token here
    }
    while (true) {
      attempt++;
      try {
        final resp = await _client.request(
          path,
          method: method.name.toUpperCase(),
          queryParameters: queryParameters,
          data: body,
          headers: header,
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
        // Handle auth errors (401) and optionally trigger refresh-token flow
        final statusCode = e.response?.statusCode;
        logger.e(
          'Request failed [$path] (attempt $attempt) code=$statusCode',
          e: e,
          st: st,
          tag: 'ApiService',
        );

        if ((statusCode == 401 || statusCode == 403) &&
            env.refreshTokenEnabled) {
          // Try refresh token flow once (user must provide env.refreshToken() implementation)
          final refreshed = await _tryRefreshToken();
          if (refreshed && attempt <= maxRetries) {
            await Future.delayed(retryDelay);
            continue; // retry
          }
          // else return auth error
          return ApiResponse.error(
            message: 'Unauthorized',
            statusCode: statusCode ?? 401,
            error: e,
          );
        }

        // Cancelled
        if (e.type == DioExceptionType.cancel) {
          return ApiResponse.error(
            message: 'Request cancelled',
            statusCode: e.response?.statusCode,
            error: e,
          );
        }

        // Retry logic for transient errors
        if (_isTransientError(e) && attempt <= maxRetries) {
          await Future.delayed(retryDelay * attempt);
          continue;
        }

        return ApiResponse.error(
          message: _extractMessageFromDioError(e) ?? 'Network request failed',
          statusCode: e.response?.statusCode,
          error: e,
          stackTrace: st,
        );
      } catch (e, st) {
        logger.e(
          'Unexpected error in ApiService.request',
          e: e,
          st: st,
          tag: 'ApiService',
        );
        return ApiResponse.error(
          message: 'Unexpected error',
          error: e,
          stackTrace: st,
        );
      }
    }
  }

  /// Map Dio Response to ApiResponse<R> using provided converters
  ApiResponse<R> _mapResponse<R>(
    Response<dynamic> resp, {
    R Function(Map<String, dynamic>)? fromJson,
    List<R> Function(List<dynamic>)? fromJsonList,
  }) {
    final status = resp.statusCode ?? 500;
    final raw = resp.data;

    // If the backend uses a standardized wrapper (response_code, response_message, response_obj),
    // normalize here. Attempt common shapes first.
    if (raw is Map<String, dynamic>) {
      // Common wrapper
      final hasResponseCode =
          raw.containsKey('response_code') || raw.containsKey('success');
      if (hasResponseCode) {
        final bool success =
            (raw['response_code'] == 1) || (raw['success'] == true);
        final message = raw['response_message'] ?? raw['message'];
        final obj = raw['response_obj'] ?? raw['data'] ?? raw['payload'];

        if (success) {
          // object
          if (obj is Map<String, dynamic>) {
            final parsed = fromJson != null
                ? fromJson(obj)
                : parseDynamicToType<R>(obj, fromJson: fromJson);
            if (parsed != null) {
              return ApiResponse.success(
                data: parsed,
                message: message,
                statusCode: status,
              );
            }
            return ApiResponse.success(
              data: obj as R,
              message: message,
              statusCode: status,
            );
          }

          // list
          if (obj is List) {
            if (fromJsonList != null) {
              final parsedList = fromJsonList(obj);
              return ApiResponse.success(
                data: parsedList as R,
                message: message,
                statusCode: status,
              );
            } else if (fromJson != null) {
              final items = obj
                  .whereType<Map<String, dynamic>>()
                  .map(fromJson)
                  .toList();
              return ApiResponse.success(
                data: items as R,
                message: message,
                statusCode: status,
              );
            } else {
              return ApiResponse.success(
                data: obj as R,
                message: message,
                statusCode: status,
              );
            }
          }

          // raw scalar/object value without wrapper
          final parsed = parseDynamicToType<R>(obj, fromJson: fromJson);
          if (parsed != null) {
            return ApiResponse.success(
              data: parsed,
              message: message,
              statusCode: status,
            );
          }

          return ApiResponse.success(
            data: obj as R,
            message: message,
            statusCode: status,
          );
        } else {
          // backend signalled failure
          return ApiResponse.error(
            message: message ?? 'Request failed',
            statusCode: status,
            error: raw,
            data: null,
          );
        }
      }

      // If no wrapper, try to parse direct body as object or list
      // object
      if (raw is Map<String, dynamic>) {
        final parsed = fromJson != null
            ? fromJson(raw)
            : parseDynamicToType<R>(raw, fromJson: fromJson);
        if (parsed != null) {
          return ApiResponse.success(data: parsed, statusCode: status);
        }
        // fallback: cast
        try {
          return ApiResponse.success(data: raw as R, statusCode: status);
        } catch (_) {
          return ApiResponse.error(
            message: 'Unable to parse response',
            error: raw,
            statusCode: status,
          );
        }
      }
    }

    // List or scalar response (e.g., GET list endpoint)
    if (raw is List) {
      if (fromJsonList != null) {
        final parsed = fromJsonList(raw);
        return ApiResponse.success(data: parsed as R, statusCode: status);
      } else if (fromJson != null) {
        final items = raw
            .whereType<Map<String, dynamic>>()
            .map(fromJson)
            .toList();
        return ApiResponse.success(data: items as R, statusCode: status);
      } else {
        return ApiResponse.success(data: raw as R, statusCode: status);
      }
    }

    // raw string or number
    try {
      return ApiResponse.success(data: raw as R, statusCode: status);
    } catch (_) {
      return ApiResponse.error(
        message: 'Unsupported response shape',
        error: raw,
        statusCode: status,
      );
    }
  }

  Future<bool> _tryRefreshToken() async {
    // if (!env.refreshTokenEnabled || env.refreshTokenHandler == null) {
    //   return false;
    // }
    // try {
    //   logger.i('Attempting token refresh', 'ApiService');
    //   // final ok = await env.refreshTokenHandler!();
    //   // logger.i('Token refresh result: $ok', 'ApiService');
    //   return ok;
    // } catch (e, st) {
    //   logger.e('Refresh token failed', e, st, 'ApiService');
    return false;
    // }
  }

  bool _isTransientError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.connectionError ||
      DioExceptionType.unknown => true,
      _ => false,
    };
  }

  String? _extractMessageFromDioError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString();
    }
    return e.message;
  }
}
