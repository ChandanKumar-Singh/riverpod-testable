// lib/core/network/models/api_response.dart
import 'dart:convert';

/// Unified API response container.
///
/// Supports:
///  - success responses with typed `data`
///  - error responses with message, error object and stacktrace
///  - loading state (useful for UI state models)
sealed class ApiResponse<T> {
  const ApiResponse();

  const factory ApiResponse.success({
    required T data,
    String? message,
    int? statusCode,
    Map<String, dynamic>? meta,
  }) = ApiResponseSuccess<T>;

  const factory ApiResponse.error({
    required String message,
    Object? error,
    int? statusCode,
    StackTrace? stackTrace,
    T? data,
  }) = ApiResponseError<T>;

  const factory ApiResponse.loading() = ApiResponseLoading<T>;

  bool get isSuccess => this is ApiResponseSuccess<T>;
  bool get isError => this is ApiResponseError<T>;
  bool get isLoading => this is ApiResponseLoading<T>;

  /// Returns typed data if present (null otherwise)
  T? get data {
    return switch (this) {
      ApiResponseSuccess(:final data) => data,
      ApiResponseError(:final data) => data,
      _ => null,
    };
  }

  String? get message {
    return switch (this) {
      ApiResponseSuccess(:final message) => message,
      ApiResponseError(:final message) => message,
      _ => null,
    };
  }

  int? get statusCode {
    return switch (this) {
      ApiResponseSuccess(:final statusCode) => statusCode,
      ApiResponseError(:final statusCode) => statusCode,
      _ => null,
    };
  }

  @override
  String toString() {
    return switch (this) {
      ApiResponseSuccess(:final data, :final message, :final statusCode) =>
        'ApiResponse.success(statusCode=$statusCode, message=$message, data=$data)',
      ApiResponseError(:final message, :final statusCode, :final error) =>
        'ApiResponse.error(statusCode=$statusCode, message=$message, error=$error)',
      ApiResponseLoading() => 'ApiResponse.loading()',
    };
  }
}

final class ApiResponseSuccess<T> extends ApiResponse<T> {
  final T data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? meta;

  const ApiResponseSuccess({
    required this.data,
    this.message,
    this.statusCode,
    this.meta,
  });
}

final class ApiResponseError<T> extends ApiResponse<T> {
  final String message;
  final Object? error;
  final int? statusCode;
  final StackTrace? stackTrace;
  final T? data;

  const ApiResponseError({
    required this.message,
    this.error,
    this.statusCode,
    this.stackTrace,
    this.data,
  });
}

final class ApiResponseLoading<T> extends ApiResponse<T> {
  const ApiResponseLoading();
}

/// Small helper to create typed objects from dynamic JSON
T? parseDynamicToType<T>(
  dynamic raw, {
  T Function(Map<String, dynamic>)? fromJson,
  bool allowListToSingle =
      false, // when API sometimes returns list but expected single
}) {
  if (raw == null) return null;
  // If T is Map<String, dynamic>
  if (T is Map<String, dynamic>) {
    if (raw is Map<String, dynamic>) return raw as T;
    if (raw is String) {
      try {
        return jsonDecode(raw) as T;
      } catch (_) {
        // not JSON, return raw if matches
        return raw as T;
      }
    }
  }

  if (fromJson != null) {
    if (raw is Map<String, dynamic>) {
      return fromJson(raw);
    } else if (raw is List) {
      // if caller expects T to be List<X>, they should pass fromJson and T as List<X>.
      // This helper cannot reliably construct List<X> because generics are erased.
      // Caller-side mapping is recommended for lists (see ApiService below).
      // If allowListToSingle is set, try to use first element.
      if (allowListToSingle &&
          raw.isNotEmpty &&
          raw.first is Map<String, dynamic>) {
        return fromJson(raw.first as Map<String, dynamic>);
      }
    }
  }

  // Last resort: try to cast
  try {
    return raw as T;
  } catch (_) {
    return null;
  }
}
