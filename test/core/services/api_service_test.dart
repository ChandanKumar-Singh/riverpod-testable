import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:testable/core/services/api_service.dart';
import 'package:testable/core/network/dio/http_client.dart';
import 'package:testable/core/config/env.dart';
import 'package:testable/core/utils/logger.dart';
import 'api_service_test.mocks.dart';

@GenerateMocks([AppHttpClient, AppLogger, Env])
void main() {
  late ApiService apiService;
  late MockAppHttpClient mockClient;
  late MockAppLogger mockLogger;
  late MockEnv mockEnv;

  setUp(() {
    mockClient = MockAppHttpClient();
    mockLogger = MockAppLogger();
    mockEnv = MockEnv();

    when(mockEnv.baseUrl).thenReturn('https://test.example.com');
    when(mockEnv.enableLogging).thenReturn(true);
    when(mockEnv.refreshTokenEnabled).thenReturn(false);

    apiService = ApiService(
      client: mockClient,
      logger: mockLogger,
      env: mockEnv,
    );
  });

  group('ApiService - Success Responses', () {
    test('request returns success response for 200 status', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: {
          'response_code': 1,
          'response_message': 'Success',
          'response_obj': {'id': 1, 'name': 'Test'},
        },
      );

      when(
        mockClient.request(
          any,
          method: anyNamed('method'),
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.request<Map<String, dynamic>>(
        '/test',
        fromJson: (data) => data,
      );

      expect(result.isSuccess, isTrue);
      expect(result.data, isNotNull);
      expect(result.statusCode, 200);
    });

    test('request handles list responses', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: [
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
        ],
      );

      when(
        mockClient.request(
          any,
          method: anyNamed('method'),
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenAnswer((_) async => response);

      // Note: When requesting List<Map<String, dynamic>>, fromJsonList
      // expects List<List<Map<String, dynamic>>> Function(List<dynamic>)
      // So we need to use fromJson instead for list of maps
      final result = await apiService.request<List<Map<String, dynamic>>>(
        '/test',
        fromJson: (data) {
          // Handle list data - data is already a List from the response
          final list = data as List<dynamic>;
          return list
              .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item as Map),
              )
              .toList();
        },
      );

      expect(result.isSuccess, isTrue);
      expect(result.data, isA<List<Map<String, dynamic>>>());
      expect(result.data?.length, 2);
    });

    test('request handles direct response without wrapper', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: {'id': 1, 'name': 'Test'},
      );

      when(
        mockClient.request(
          any,
          method: anyNamed('method'),
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.request<Map<String, dynamic>>(
        '/test',
        fromJson: (data) => data,
      );

      expect(result.isSuccess, isTrue);
      expect(result.data, isNotNull);
    });
  });

  group('ApiService - Error Responses', () {
    test('request returns error for 400 status', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'error': 'Bad Request'},
        ),
        type: DioExceptionType.badResponse,
      );

      when(
        mockClient.request(
          any,
          method: anyNamed('method'),
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenThrow(dioException);

      final result = await apiService.request<Map<String, dynamic>>(
        '/test',
        fromJson: (data) => data,
      );

      expect(result.isError, isTrue);
      expect(result.statusCode, 400);
      expect(result.message, isNotNull);
    });

    test('request returns error for 401 status', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: {'error': 'Unauthorized'},
        ),
        type: DioExceptionType.badResponse,
      );

      when(
        mockClient.request(
          any,
          method: anyNamed('method'),
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenThrow(dioException);

      final result = await apiService.request<Map<String, dynamic>>(
        '/test',
        fromJson: (data) => data,
      );

      expect(result.isError, isTrue);
      expect(result.statusCode, 401);
    });

    test('request returns error for 500 status', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
          data: {'error': 'Server Error'},
        ),
        type: DioExceptionType.badResponse,
      );

      when(
        mockClient.request(
          any,
          method: anyNamed('method'),
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenThrow(dioException);

      final result = await apiService.request<Map<String, dynamic>>(
        '/test',
        fromJson: (data) => data,
      );

      expect(result.isError, isTrue);
      expect(result.statusCode, 500);
      expect(result.message, contains('Server error'));
    });

    test('request handles connection timeout', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      when(
        mockClient.request(
          any,
          method: anyNamed('method'),
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenThrow(dioException);

      final result = await apiService.request<Map<String, dynamic>>(
        '/test',
        fromJson: (data) => data,
      );

      expect(result.isError, isTrue);
      expect(result.message, contains('timeout'));
    });

    test('request handles connection error', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      when(
        mockClient.request(
          any,
          method: anyNamed('method'),
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenThrow(dioException);

      final result = await apiService.request<Map<String, dynamic>>(
        '/test',
        fromJson: (data) => data,
      );

      expect(result.isError, isTrue);
      expect(result.message, contains('Connection failed'));
    });

    test('request handles cancelled request', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.cancel,
      );

      when(
        mockClient.request(
          any,
          method: anyNamed('method'),
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenThrow(dioException);

      final result = await apiService.request<Map<String, dynamic>>(
        '/test',
        fromJson: (data) => data,
      );

      expect(result.isError, isTrue);
      expect(result.message, contains('cancelled'));
    });
  });

  group('ApiService - Retry Logic', () {
    test('request retries on transient errors', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      when(
        mockClient.request(
          any,
          method: anyNamed('method'),
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenThrow(dioException);

      final result = await apiService.request<Map<String, dynamic>>(
        '/test',
        fromJson: (data) => data,
        maxRetries: 2,
        retryDelay: const Duration(milliseconds: 10),
      );

      expect(result.isError, isTrue);
      // Should have attempted multiple times
      verify(
        mockClient.request(
          any,
          method: anyNamed('method'),
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).called(greaterThan(1));
    });
  });

  group('ApiService - Different HTTP Methods', () {
    test('request supports GET method', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: {'success': true},
      );

      when(
        mockClient.request(
          any,
          method: 'GET',
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenAnswer((_) async => response);

      await apiService.request<Map<String, dynamic>>(
        '/test',
        method: ApiMethod.get,
        fromJson: (data) => data,
      );

      verify(
        mockClient.request(
          '/test',
          method: 'GET',
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).called(1);
    });

    test('request supports PUT method', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: {'success': true},
      );

      when(
        mockClient.request(
          any,
          method: 'PUT',
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenAnswer((_) async => response);

      await apiService.request<Map<String, dynamic>>(
        '/test',
        method: ApiMethod.put,
        body: {'key': 'value'},
        fromJson: (data) => data,
      );

      verify(
        mockClient.request(
          '/test',
          method: 'PUT',
          data: {'key': 'value'},
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).called(1);
    });

    test('request supports DELETE method', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: {'success': true},
      );

      when(
        mockClient.request(
          any,
          method: 'DELETE',
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).thenAnswer((_) async => response);

      await apiService.request<Map<String, dynamic>>(
        '/test',
        method: ApiMethod.delete,
        fromJson: (data) => data,
      );

      verify(
        mockClient.request(
          '/test',
          method: 'DELETE',
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          headers: anyNamed('headers'),
          cancelToken: anyNamed('cancelToken'),
          timeout: anyNamed('timeout'),
          extra: anyNamed('extra'),
        ),
      ).called(1);
    });
  });
}
