// FEATURE: Dio (HTTP CLIENT)

// lib/core/network/http_client.dart
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:testable/core/config/env.dart';
import 'package:testable/core/utils/logger.dart';

typedef TokenGetter = Future<String?> Function();

/// AppHttpClient: Dio wrapper with:
///  - structured interceptors
///  - optional token injection (Bearer)
///  - custom logging via AppLogger
///  - ability to add per-request headers and cancel tokens
class AppHttpClient {
  AppHttpClient({
    required this.logger,
    required this.env,
    Dio? dio,
    this.tokenGetter,
  }) : _dio = dio ?? Dio(BaseOptions(baseUrl: env.baseUrl)) {
    _setupInterceptors();
  }
  final Dio _dio;
  final AppLogger logger;
  final Env env;
  final TokenGetter? tokenGetter;

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.clear();

    // Request interceptor: inject headers like auth
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Default headers
          options.headers['Accept'] = 'application/json';
          // options.headers['X-Client'] = env.clientId;

          // Attach optional custom headers from Env
          // final extraHeaders = env.defaultHeaders;
          // if (extraHeaders != null) {
          //   options.headers.addAll(extraHeaders);
          // }
          // Token injection if required (we let ApiService decide per-request whether to use auth)
          if (options.extra['requiresAuth'] == true && tokenGetter != null) {
            try {
              final token = await tokenGetter!();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = token;
              }
            } catch (e, st) {
              logger.e(
                'Unable to find session',
                e: e,
                st: st,
                tag: 'AppHttpClient',
              );
            }
          }

          if (env.enableLogging) {
            logger.d(
              'HTTP ▶ ${options.method} ${options.uri}',
              tag: 'AppHttpClient',
              e: {
                'headers': options.headers,
                'data': options.data,
                'extra': options.extra,
              },
            );
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (env.enableLogging) {
            logger.i(
              'HTTP ◀ ${response.statusCode} ${response.requestOptions.uri}',
              tag: 'AppHttpClient',
              e: response.data is Map || response.data is List
                  ? jsonEncode(response.data)
                  : response.data?.toString(),
            );
          }
          handler.next(response);
        },
        onError: (err, handler) {
          logger.e(
            'HTTP ✖ ${err.requestOptions.uri}',
            e: err,
            st: err.stackTrace,
            tag: 'AppHttpClient',
          );
          handler.next(err);
        },
      ),
    );
  }

  /// low-level request wrapper: returns Dio [Response]
  /// options.extra keys:
  ///  - requiresAuth: bool -> instructs the interceptor to attach token
  Future<Response<dynamic>> request(
    String path, {
    String method = 'POST',
    Map<String, dynamic>? queryParameters,
    Object? data,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    Duration? timeout,
    Map<String, dynamic>? extra,
    Options? options,
  }) async {
    try {
      final finalOptions =
          options?.copyWith(method: method) ?? Options(method: method);
      finalOptions.extra = {...(finalOptions.extra ?? {}), ...?extra};

      if (headers != null && headers.isNotEmpty) {
        finalOptions.headers = {...?finalOptions.headers, ...headers};
      }
      final resp = await _dio
          .request(
            path,
            data: data,
            queryParameters: queryParameters,
            options: finalOptions,
            cancelToken: cancelToken,
          )
          .timeout(timeout ?? const Duration(seconds: 30));
      return resp;
    } on DioException {
      // Bubble up DioException to service layer which will normalize to ApiResponse
      rethrow;
    } on TimeoutException catch (t) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.receiveTimeout,
        error: t,
      );
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.unknown,
        error: e,
      );
    }
  }

  // convenience wrappers
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
    Map<String, dynamic>? extra,
  }) => request(
    path,
    method: 'GET',
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    timeout: timeout,
    extra: extra,
  );

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
    Map<String, dynamic>? extra,
  }) => request(
    path,
    method: 'POST',
    data: data,
    options: options,
    cancelToken: cancelToken,
    timeout: timeout,
    extra: extra,
  );

  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
    Map<String, dynamic>? extra,
  }) => request(
    path,
    method: 'PUT',
    data: data,
    options: options,
    cancelToken: cancelToken,
    timeout: timeout,
    extra: extra,
  );

  Future<Response<dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
    Map<String, dynamic>? extra,
  }) => request(
    path,
    method: 'DELETE',
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    timeout: timeout,
    extra: extra,
  );
}
