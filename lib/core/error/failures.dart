/// Sealed Result class — modern Dart 3 alternative to dartz Either.
/// Used throughout the app for type-safe error handling.
sealed class Result<T> {
  const Result();
}

/// Represents a successful operation with data.
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

/// Represents a failed operation with error info.
class Failure<T> extends Result<T> {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});
}
