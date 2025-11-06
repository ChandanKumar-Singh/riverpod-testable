import 'package:dio/dio.dart';

import 'http_client.dart';
import 'models/api_response.dart';

/// Lightweight API service interface used by repositories.
/// Keeps the data layer testable and independent of implementation details.
class ApiService {
  final AppHttpClient _client;
  ApiService(this._client);

  /// Generic POST request
  Future<ApiResponse<T>> request<T>(
    String path, {
    ApiMothod method = ApiMothod.post,
    Map<String, dynamic>? queryParameters,
    Object? data,
    CancelToken? cancelToken,
    Duration? timeout,
    ApiResponse<dynamic> Function(Map<String, dynamic>)? fromJson,
    ApiResponse<T> Function(ApiResponse<T>)? onSuccess,
    ApiResponse<T> Function(ApiResponse<T>)? onError,
  }) async {
    return safeCall<T>(
      () => _client.request(
        path,
        method: method.name.toUpperCase(),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        timeout: timeout,
        fromJson: fromJson,
      ),
      onSuccess: onSuccess ?? (response) => response,
      onError: onError,
    );
  }

  /// Generic safe call wrapper for all requests
  Future<ApiResponse<T>> safeCall<T>(
    Future<ApiResponse> Function() request, {
    required ApiResponse<T> Function(ApiResponse<T> response) onSuccess,
    ApiResponse<T> Function(ApiResponse<T> response)? onError,
  }) async {
    try {
      final result = await request();
      if (result is ApiResponseSuccess<T>) {
        return onSuccess(result);
      } else if (result is ApiResponseError<T>) {
        return onError != null
            ? onError(result)
            : ApiResponse.error(
                message: result.message,
                error: result.error,
                statusCode: result.statusCode,
              );
      } else {
        return ApiResponse.error(
          message: "Something went wrong",
          statusCode: 500,
        );
      }
    } catch (e, stackTrace) {
      return onError != null
          ? onError(
              ApiResponse.error(
                message: 'Request failed',
                error: e,
                statusCode: 500,
                stackTrace: stackTrace,
              ),
            )
          : ApiResponse.error(
              message: 'Something went wrong',
              error: e,
              statusCode: 500,
              stackTrace: stackTrace,
            );
    }
  }
}
