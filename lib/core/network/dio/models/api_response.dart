enum ApiMothod {
  get,
  post,
  put,
  delete,
  patch,
  head,
  options,
}

abstract class ApiResponse<T> {
  const ApiResponse();

  // Factory constructors
  const factory ApiResponse.success({
    required T data,
    String? message,
    int statusCode,
    Map<String, dynamic>? meta,
  }) = ApiResponseSuccess<T>;

  const factory ApiResponse.error({
    required String message,
    Object? error,
    int statusCode,
    StackTrace? stackTrace,
    T? data,
  }) = ApiResponseError<T>;

  const factory ApiResponse.loading() = ApiResponseLoading<T>;

  // Helper getters
  bool get isSuccess => this is ApiResponseSuccess<T>;
  bool get isError => this is ApiResponseError<T>;
  bool get isLoading => this is ApiResponseLoading<T>;

  T? get data {
    return switch (this) {
      ApiResponseSuccess<T>(:final data) => data,
      ApiResponseError<T>(:final data) => data,
      _ => null,
    };
  }

  String? get errorMessage {
    return switch (this) {
      ApiResponseError<T>(:final message) => message,
      _ => null,
    };
  }
  StackTrace? get stackTrace {
    return switch (this) {
      ApiResponseError<T>(:final stackTrace) => stackTrace,
      _ => null,
    };
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final success = json['success'] as bool? ?? false;
    final loading = json['loading'] as bool? ?? false;

    if (loading) {
      return const ApiResponse.loading();
    }

    if (success) {
      final dataJson = json['data'];
      T data;

      if (dataJson is Map<String, dynamic>) {
        data = fromJsonT(dataJson);
      } else {
        throw FormatException(
          'Expected Map<String, dynamic> for data but got ${dataJson.runtimeType}',
        );
      }

      return ApiResponse.success(
        data: data,
        message: json['message'] as String?,
        statusCode: json['statusCode'] as int? ?? 200,
        meta: json['meta'] as Map<String, dynamic>?,
      );
    } else {
      T? errorData;
      final dataJson = json['data'];

      if (dataJson != null && dataJson is Map<String, dynamic>) {
        errorData = fromJsonT(dataJson);
      }

      return ApiResponse.error(
        message: json['message'] as String? ?? 'Unknown error occurred',
        error: json['error'],
        statusCode: json['statusCode'] as int? ?? 500,
        stackTrace: json['stackTrace'] != null
            ? StackTrace.fromString(json['stackTrace'] as String)
            : null,
        data: errorData,
      );
    }
  }


  @override
  bool operator ==(Object other) {
    return other is ApiResponse<T> &&
        other.runtimeType == runtimeType &&
        other.toString() == toString();
  }

  @override
  int get hashCode => toString().hashCode;
}

class ApiResponseSuccess<T> extends ApiResponse<T> {
  final T data;
  final String? message;
  final int statusCode;
  final Map<String, dynamic>? meta;

  const ApiResponseSuccess({
    required this.data,
    this.message,
    this.statusCode = 200,
    this.meta,
  });

  @override
  String toString() =>
      'ApiResponseSuccess(data: $data, message: $message, statusCode: $statusCode)';

  ApiResponseSuccess<T> copyWith({
    T? data,
    String? message,
    int? statusCode,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponseSuccess<T>(
      data: data ?? this.data,
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      meta: meta ?? this.meta,
    );
  }
}

class ApiResponseError<T> extends ApiResponse<T> {
  final String message;
  final Object? error;
  final int statusCode;
  final StackTrace? stackTrace;
  final T? data;

  const ApiResponseError({
    required this.message,
    this.error,
    this.statusCode = 500,
    this.stackTrace,
    this.data,
  });

  @override
  String toString() =>
      'ApiResponseError(message: $message, error: $error, statusCode: $statusCode)';

  ApiResponseError<T> copyWith({
    String? message,
    Object? error,
    int? statusCode,
    StackTrace? stackTrace,
    T? data,
  }) {
    return ApiResponseError<T>(
      message: message ?? this.message,
      error: error ?? this.error,
      statusCode: statusCode ?? this.statusCode,
      stackTrace: stackTrace ?? this.stackTrace,
      data: data ?? this.data,
    );
  }
}

class ApiResponseLoading<T> extends ApiResponse<T> {
  const ApiResponseLoading();

  @override
  String toString() => 'ApiResponseLoading()';
}

// Extension for easy response creation
extension ApiResponseFactories on ApiResponse {
  static ApiResponse<T> success<T>({
    required T data,
    String? message,
    int statusCode = 200,
    Map<String, dynamic>? meta,
  }) => ApiResponse.success(
    data: data,
    message: message,
    statusCode: statusCode,
    meta: meta,
  );

  static ApiResponse<T> error<T>({
    required String message,
    Object? error,
    int statusCode = 500,
    StackTrace? stackTrace,
    T? data,
  }) => ApiResponse.error(
    message: message,
    error: error,
    statusCode: statusCode,
    stackTrace: stackTrace,
    data: data,
  );

  static ApiResponse<T> loading<T>() => const ApiResponse.loading();
}