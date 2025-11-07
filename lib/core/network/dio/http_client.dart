// core/services/http_client.dart
import 'dart:async';
import 'package:dio/dio.dart';
import '../../config/env.dart';
import '../../utils/logger.dart';
import 'models/api_response.dart';

/// HttpClient wraps Dio to provide interceptors, centralized error handling, and testability.
/// Keep it pure Dart and inject dependencies so it can be mocked.
class AppHttpClient {
  final Dio _dio;
  final AppLogger logger;
  final Env env;

  AppHttpClient({Dio? dio, required this.logger, required this.env})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: env.baseUrl)) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.clear();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (env.enableLogging) {
            logger.i('HTTP ▶ ${options.method} ${options.uri}', 'HttpClient');
          }
          // Add default headers here (auth, content-type) if needed
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (env.enableLogging) {
            logger.i(
              'HTTP ◀ ${response.statusCode} ${response.requestOptions.uri}',
              'HttpClient',
            );
          }
          handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e(
            'HTTP ✖ ${e.requestOptions.uri} : ${e.error}',
            e,
            e.stackTrace,
            'HttpClient',
          );
          handler.next(e);
        },
      ),
    );
  }

  /// Main request method with comprehensive error handling
  Future<ApiResponse> request(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
    ApiResponse Function(Map<String, dynamic> data)? fromJson,
  }) async {
    try {
      /* logger.i('🌐 API Request: $method $path', {
        'queryParameters': queryParameters,
        'data': data,
        'timeout': timeout,
      }); */

      final response = await _dio
          .request<dynamic>(
            path,
            data: data,
            queryParameters: queryParameters,
            options:
                options?.copyWith(method: method) ?? Options(method: method),
            cancelToken: cancelToken,
          )
          .timeout(timeout ?? const Duration(seconds: 30));

      /*  logger.i('✅ API Response: ${response.statusCode} $path', {
        'data': response.data,
        'headers': response.headers.map,
      }); */

      return _handleSuccessResponse(response, fromJson: fromJson);
    } on DioException catch (dioError) {
      return _handleDioError(dioError, path);
    } on TimeoutException catch (timeoutError) {
      return _handleTimeoutError(timeoutError, path);
    } on Exception catch (error, stackTrace) {
      return _handleGenericError(error, stackTrace, path);
    }
  }

  /// Handle successful responses
  ApiResponse _handleSuccessResponse(
    Response<dynamic> response, {
    ApiResponse Function(Map<String, dynamic> data)? fromJson,
  }) {
    try {
      final statusCode = response.statusCode ?? 200;

      // Handle different status codes
      if (statusCode >= 200 && statusCode < 300) {
        final responseData = response.data;

        Map<String, dynamic> data;
        if (responseData is Map) {
          data = Map<String, dynamic>.from(responseData);
        } else if (responseData is List) {
          data = {'items': responseData};
        } else {
          data = {'data': responseData};
        }

        return fromJson?.call(response.data) ??
            ApiResponse.success(
              data: data,
              statusCode: statusCode,
              message: _getSuccessMessage(statusCode),
            );
      } else {
        return ApiResponse.error(
          message: _getErrorMessage(statusCode) ?? 'An error occurred',
          statusCode: statusCode,
          error: response.data,
        );
      }
    } on FormatException catch (error, stackTrace) {
      return ApiResponse.error(
        message: 'Data parsing failed',
        error: error,
        statusCode: response.statusCode ?? 500,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      return ApiResponse.error(
        message: 'An unexpected error occurred',
        error: error,
        statusCode: response.statusCode ?? 500,
        stackTrace: stackTrace,
      );
    }
  }

  /// Handle Dio-specific errors
  ApiResponse _handleDioError(DioException error, String path) {
    logger.e('❌ Dio Error: $path', error, error.stackTrace);

    final statusCode = error.response?.statusCode;
    final errorData = error.response?.data;

    String message;
    Object? errorObject;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Request timeout. Please check your connection.';
        break;
      case DioExceptionType.badCertificate:
        message = 'Certificate error. Please try again.';
        break;
      case DioExceptionType.badResponse:
        message =
            _extractErrorMessage(errorData) ??
            _getErrorMessage(statusCode) ??
            'Server error occurred';
        errorObject = errorData;
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your network.';
        break;
      case DioExceptionType.unknown:
        message = 'An unexpected error occurred';
        errorObject = error.error;
        break;
    }

    return ApiResponse.error(
      message: message,
      error: errorObject ?? error,
      statusCode: statusCode ?? 500,
      stackTrace: error.stackTrace,
    );
  }

  /// Handle timeout errors
  ApiResponse _handleTimeoutError(TimeoutException error, String path) {
    logger.e('⏰ Timeout Error: $path', error);

    return ApiResponse.error(
      message: 'Request timeout. Please try again.',
      error: error,
      statusCode: 408,
    );
  }

  /// Handle generic exceptions
  ApiResponse _handleGenericError(
    Exception error,
    StackTrace stackTrace,
    String path,
  ) {
    logger.e('💥 Generic Error: $path', error, stackTrace);

    return ApiResponse.error(
      message: 'An unexpected error occurred',
      error: error,
      statusCode: 500,
      stackTrace: stackTrace,
    );
  }

  /// Extract error message from response data
  String? _extractErrorMessage(dynamic errorData) {
    if (errorData is Map<String, dynamic>) {
      return errorData['message'] ??
          errorData['error'] ??
          errorData['description']?.toString();
    } else if (errorData is String) {
      return errorData;
    }
    return null;
  }

  /// Get user-friendly error messages
  String? _getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden.';
      case 404:
        return 'Resource not found.';
      case 409:
        return 'Conflict occurred.';
      case 422:
        return 'Validation failed.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return null;
    }
  }

  /// Get success messages
  String _getSuccessMessage(int statusCode) {
    switch (statusCode) {
      case 200:
        return 'Request successful';
      case 201:
        return 'Created successfully';
      case 202:
        return 'Request accepted';
      case 204:
        return 'Operation successful';
      default:
        return 'Request completed';
    }
  }

  /// Convenience methods for common HTTP verbs
  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
  }) => request(
    path,
    method: 'GET',
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    timeout: timeout,
  );

  Future<ApiResponse> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
  }) => request(
    path,
    method: 'POST',
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    timeout: timeout,
  );

  Future<ApiResponse> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
  }) => request(
    path,
    method: 'PUT',
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    timeout: timeout,
  );

  Future<ApiResponse> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
  }) => request(
    path,
    method: 'DELETE',
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    timeout: timeout,
  );

  Future<ApiResponse> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
  }) => request(
    path,
    method: 'PATCH',
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    timeout: timeout,
  );
}
