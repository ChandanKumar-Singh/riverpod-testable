// core/errors/failures.dart

/// Failures are the domain-friendly error representation returned by repositories/usecases.
/// This separation means services throw Exceptions and domain layers consume Failures.
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  final int? code;
  const ServerFailure(super.message, {this.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
