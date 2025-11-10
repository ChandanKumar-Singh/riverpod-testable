// FEATURE: Errors

// core/errors/exceptions.dart

/// Exception types used by core services
class ServerException implements Exception {
  ServerException(this.message, {this.statusCode});
  final String? message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NetworkException implements Exception {
  NetworkException([this.message = 'No internet connection']);
  final String? message;

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  CacheException([this.message = 'Cache error']);
  final String? message;

  @override
  String toString() => 'CacheException: $message';
}
