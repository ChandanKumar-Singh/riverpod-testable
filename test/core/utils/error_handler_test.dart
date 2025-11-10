import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:testable/core/utils/error_handler.dart';
import 'package:testable/core/network/dio/models/api_response.dart';

void main() {
  group('ErrorHandler', () {
    test('should return user-friendly message for connection timeout', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final message = ErrorHandler.getErrorMessage(error);
      expect(message, contains('timeout'));
      expect(message, contains('connection'));
    });

    test('should return user-friendly message for 401 error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
      );

      final message = ErrorHandler.getErrorMessage(error);
      expect(message, contains('Unauthorized'));
      expect(message, contains('login'));
    });

    test('should return user-friendly message for 500 error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );

      final message = ErrorHandler.getErrorMessage(error);
      expect(message, contains('Server error'));
    });

    test('should return user-friendly message for connection error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      final message = ErrorHandler.getErrorMessage(error);
      expect(message, contains('internet connection'));
    });

    test('should return message from ApiResponseError', () {
      const error = ApiResponseError<String>(
        message: 'Custom error message',
        statusCode: 400,
      );

      final message = ErrorHandler.getErrorMessage(error);
      expect(message, 'Custom error message');
    });

    test('should return message from string error', () {
      const error = 'String error message';
      final message = ErrorHandler.getErrorMessage(error);
      expect(message, 'String error message');
    });

    test('should return default message for unknown error', () {
      final error = Exception('Unknown error');
      final message = ErrorHandler.getErrorMessage(error);
      expect(message, contains('unexpected error'));
    });

    test('isRetryable should return true for retryable errors', () {
      final timeoutError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(ErrorHandler.isRetryable(timeoutError), isTrue);

      final connectionError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      expect(ErrorHandler.isRetryable(connectionError), isTrue);
    });

    test('isRetryable should return false for non-retryable errors', () {
      final error400 = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
        ),
      );

      expect(ErrorHandler.isRetryable(error400), isFalse);
    });

    test('requiresAuth should return true for 401/403 errors', () {
      final error401 = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
      );

      expect(ErrorHandler.requiresAuth(error401), isTrue);

      final error403 = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
        ),
      );

      expect(ErrorHandler.requiresAuth(error403), isTrue);
    });

    test('requiresAuth should return false for other errors', () {
      final error500 = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );

      expect(ErrorHandler.requiresAuth(error500), isFalse);
    });
  });
}
