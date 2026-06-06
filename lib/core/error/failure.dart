/// Base failure type returned from repositories.
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

/// Failure caused by no connection, timeout, or socket issues.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure caused by an invalid or expired token.
class TokenFailure extends Failure {
  const TokenFailure(super.message);
}

/// Failure caused by validation or client-side API errors.
class ClientFailure extends Failure {
  const ClientFailure(super.message);
}

/// Failure caused by backend/server errors.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure caused by local cache errors.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
