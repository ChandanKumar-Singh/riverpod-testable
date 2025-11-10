import 'package:flutter_test/flutter_test.dart';
import 'package:testable/core/network/dio/models/api_response.dart';

void main() {
  group('ApiResponse', () {
    group('ApiResponseSuccess', () {
      test('should create success response with data', () {
        const response = ApiResponse.success(data: 'test data');
        
        expect(response.isSuccess, isTrue);
        expect(response.isError, isFalse);
        expect(response.isLoading, isFalse);
        expect(response.data, 'test data');
      });

      test('should create success response with message', () {
        const response = ApiResponse.success(
          data: 'test data',
          message: 'Success message',
        );
        
        expect(response.isSuccess, isTrue);
        expect(response.data, 'test data');
        expect(response.message, 'Success message');
      });

      test('should create success response with status code', () {
        const response = ApiResponse.success(
          data: 'test data',
          statusCode: 200,
        );
        
        expect(response.isSuccess, isTrue);
        expect(response.statusCode, 200);
      });
    });

    group('ApiResponseError', () {
      test('should create error response with message', () {
        const response = ApiResponse.error(message: 'Error message');
        
        expect(response.isError, isTrue);
        expect(response.isSuccess, isFalse);
        expect(response.isLoading, isFalse);
        expect(response.message, 'Error message');
      });

      test('should create error response with status code', () {
        const response = ApiResponse.error(
          message: 'Error message',
          statusCode: 404,
        );
        
        expect(response.isError, isTrue);
        expect(response.statusCode, 404);
      });

      test('should create error response with error object', () {
        const error = 'Error details';
        final response = ApiResponse.error(
          message: 'Error message',
          error: error,
        );
        
        expect(response.isError, isTrue);
        // Error is stored internally but not exposed via getter
        expect(response.message, 'Error message');
      });
    });

    group('ApiResponseLoading', () {
      test('should create loading response', () {
        const response = ApiResponse<String>.loading();
        
        expect(response.isLoading, isTrue);
        expect(response.isSuccess, isFalse);
        expect(response.isError, isFalse);
        expect(response.data, isNull);
      });
    });

    group('Data getter', () {
      test('should return data for success response', () {
        const response = ApiResponse.success(data: 'test');
        expect(response.data, 'test');
      });

      test('should return data for error response if provided', () {
        const response = ApiResponse.error(
          message: 'Error',
          data: 'error data',
        );
        expect(response.data, 'error data');
      });

      test('should return null for loading response', () {
        const response = ApiResponse<String>.loading();
        expect(response.data, isNull);
      });
    });

    group('Message getter', () {
      test('should return message for success response', () {
        const response = ApiResponse.success(
          data: 'test',
          message: 'Success',
        );
        expect(response.message, 'Success');
      });

      test('should return message for error response', () {
        const response = ApiResponse.error(message: 'Error');
        expect(response.message, 'Error');
      });

      test('should return null for loading response', () {
        const response = ApiResponse<String>.loading();
        expect(response.message, isNull);
      });
    });
  });
}

