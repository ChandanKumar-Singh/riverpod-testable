// FEATURE: Errors

// core/errors/exceptions.dart

/// Exception types used by core services
class ServerException implements Exception {
  final String? message;
  final int? statusCode;
  ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NetworkException implements Exception {
  final String? message;
  NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String? message;
  CacheException([this.message = 'Cache error']);

  @override
  String toString() => 'CacheException: $message';
}
