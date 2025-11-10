// core/errors/failures.dart

/// Failures are the domain-friendly error representation returned by repositories/usecases.
/// This separation means services throw Exceptions and domain layers consume Failures.
abstract class Failure {
  const Failure(this.message);
  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.code});
  final int? code;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
