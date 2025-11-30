import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:testable/core/utils/error_handler.dart';
import 'package:testable/core/network/dio/models/api_response.dart';

void main() {
  group('ErrorHandler', () {
    group('getErrorMessage', () {
      test('returns message for DioException with bad response', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {'error': 'Bad Request'},
          ),
          type: DioExceptionType.badResponse,
        );

        final message = ErrorHandler.getErrorMessage(dioException);
        expect(message, isNotNull);
        expect(message, isNotEmpty);
      });

      test('returns message for 401 status', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 401,
          ),
          type: DioExceptionType.badResponse,
        );

        final message = ErrorHandler.getErrorMessage(dioException);
        expect(message, contains('Unauthorized'));
      });

      test('returns message for 403 status', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 403,
          ),
          type: DioExceptionType.badResponse,
        );

        final message = ErrorHandler.getErrorMessage(dioException);
        expect(message, contains('forbidden'));
      });

      test('returns message for 404 status', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 404,
          ),
          type: DioExceptionType.badResponse,
        );

        final message = ErrorHandler.getErrorMessage(dioException);
        expect(message, contains('not found'));
      });

      test('returns message for 500 status', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 500,
          ),
          type: DioExceptionType.badResponse,
        );

        final message = ErrorHandler.getErrorMessage(dioException);
        expect(message, contains('Server error'));
      });

      test('returns message for connection timeout', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        );

        final message = ErrorHandler.getErrorMessage(dioException);
        expect(message, contains('timeout'));
      });

      test('returns message for connection error', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionError,
        );

        final message = ErrorHandler.getErrorMessage(dioException);
        expect(message, contains('internet connection'));
      });

      test('returns message for cancelled request', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.cancel,
        );

        final message = ErrorHandler.getErrorMessage(dioException);
        expect(message, contains('cancelled'));
      });

      test('returns message for ApiResponseError', () {
        const error = ApiResponseError<String>(
          message: 'Custom error message',
          statusCode: 400,
        );

        final message = ErrorHandler.getErrorMessage(error);
        expect(message, 'Custom error message');
      });

      test('returns message for String error', () {
        const error = 'String error message';
        final message = ErrorHandler.getErrorMessage(error);
        expect(message, 'String error message');
      });

      test('returns default message for unknown error', () {
        final error = Exception('Unknown error');
        final message = ErrorHandler.getErrorMessage(error);
        expect(message, contains('unexpected error'));
      });
    });

    group('isRetryable', () {
      test('returns true for connection timeout', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        );

        expect(ErrorHandler.isRetryable(dioException), isTrue);
      });

      test('returns true for send timeout', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.sendTimeout,
        );

        expect(ErrorHandler.isRetryable(dioException), isTrue);
      });

      test('returns true for receive timeout', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.receiveTimeout,
        );

        expect(ErrorHandler.isRetryable(dioException), isTrue);
      });

      test('returns true for connection error', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionError,
        );

        expect(ErrorHandler.isRetryable(dioException), isTrue);
      });

      test('returns true for 500 status code', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 500,
          ),
          type: DioExceptionType.badResponse,
        );

        expect(ErrorHandler.isRetryable(dioException), isTrue);
      });

      test('returns false for 400 status code', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
          ),
          type: DioExceptionType.badResponse,
        );

        expect(ErrorHandler.isRetryable(dioException), isFalse);
      });

      test('returns false for non-DioException', () {
        final error = Exception('Test error');
        expect(ErrorHandler.isRetryable(error), isFalse);
      });
    });

    group('requiresAuth', () {
      test('returns true for 401 status', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 401,
          ),
          type: DioExceptionType.badResponse,
        );

        expect(ErrorHandler.requiresAuth(dioException), isTrue);
      });

      test('returns true for 403 status', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 403,
          ),
          type: DioExceptionType.badResponse,
        );

        expect(ErrorHandler.requiresAuth(dioException), isTrue);
      });

      test('returns false for other status codes', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
          ),
          type: DioExceptionType.badResponse,
        );

        expect(ErrorHandler.requiresAuth(dioException), isFalse);
      });

      test('returns true for ApiResponseError with 401', () {
        const error = ApiResponseError<String>(
          statusCode: 401,
        );

        expect(ErrorHandler.requiresAuth(error), isTrue);
      });

      test('returns false for non-auth errors', () {
        final error = Exception('Test error');
        expect(ErrorHandler.requiresAuth(error), isFalse);
      });
    });
  });
}
