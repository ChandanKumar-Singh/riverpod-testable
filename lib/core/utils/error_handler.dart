import 'package:dio/dio.dart';
import 'package:testable/core/network/dio/models/api_response.dart';

/// Centralized error handler utility
class ErrorHandler {
  /// Convert DioException to user-friendly message
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      return _getDioErrorMessage(error);
    } else if (error is ApiResponseError) {
      return error.message;
    } else if (error is String) {
      return error;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  static String _getDioErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return 'Unauthorized. Please login again.';
        } else if (statusCode == 403) {
          return 'Access forbidden. You don\'t have permission.';
        } else if (statusCode == 404) {
          return 'Resource not found.';
        } else if (statusCode == 500) {
          return 'Server error. Please try again later.';
        } else if (statusCode != null &&
            statusCode >= 400 &&
            statusCode < 500) {
          return 'Client error. Please check your input.';
        } else if (statusCode != null && statusCode >= 500) {
          return 'Server error. Please try again later.';
        }
        return 'Request failed. Please try again.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.badCertificate:
        return 'Certificate error. Please contact support.';
      case DioExceptionType.unknown:
        final message = error.message;
        if (message != null && message.isNotEmpty) {
          return message;
        }
        return 'Network error. Please check your connection.';
    }
  }

  /// Check if error is retryable
  static bool isRetryable(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError ||
          (error.type == DioExceptionType.badResponse &&
              error.response?.statusCode != null &&
              error.response!.statusCode! >= 500);
    }
    return false;
  }

  /// Check if error requires authentication
  static bool requiresAuth(dynamic error) {
    if (error is DioException) {
      return error.response?.statusCode == 401 ||
          error.response?.statusCode == 403;
    }
    if (error is ApiResponseError) {
      return error.statusCode == 401 || error.statusCode == 403;
    }
    return false;
  }
}
