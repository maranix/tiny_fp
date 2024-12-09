sealed class Either<E, T> {
  const Either();

  @Deprecated(
    "This function is deprecated."
    "\n"
    "Only use in situations where `switch` based pattern matching is not feasible or supported.",
  )
  R match<R>({
    required R Function(E error) onLeft,
    required R Function(T value) onRight,
  });

  /// Check if the value is Left (failure)
  bool get isLeft => this is Left<E, T>;

  /// Check if the value is Right (success)
  bool get isRight => this is Right<E, T>;

  /// Extracts the value from [Right] or return [defaultValue] on [Left]
  T fromEither(T defaultValue) => switch (this) {
        Left() => defaultValue,
        Right(:final value) => value,
      };

  /// Extracts the value from [Right] but throws a [StateError] for [Left]
  T fromRight() => switch (this) {
        Left() => throw StateError("Expected Right, got Left"),
        Right(:final value) => value,
      };

  /// Extracts the error from [Left] but throws a [StateError] for [Right]
  E fromLeft() => switch (this) {
        Left(:final error) => error,
        Right() => throw StateError("Expected Right, got Left"),
      };
}

/// Represents a failure (error) with type [E]
final class Left<E, T> extends Either<E, T> {
  const Left(this.error);

  final E error;

  @Deprecated(
    "This function is deprecated."
    "\n"
    "Only use in situations where `switch` based pattern matching is not feasible or supported.",
  )
  @override
  R match<R>({
    required R Function(E error) onLeft,
    required R Function(T value) onRight,
  }) =>
      onLeft(error);

  @override
  bool operator ==(Object other) => other is Left<E, T> && other.error == error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => "Left(${error.toString()})";
}

/// Represents a success with type [T]
final class Right<E, T> extends Either<E, T> {
  const Right(this.value);

  final T value;

  @Deprecated(
    "This function is deprecated."
    "\n"
    "Only use in situations where `switch` based pattern matching is not feasible or supported.",
  )
  @override
  R match<R>({
    required R Function(E error) onLeft,
    required R Function(T value) onRight,
  }) =>
      onRight(value);

  @override
  bool operator ==(Object other) =>
      other is Right<E, T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "Right($value)";
}

extension EitherExtension<E, T> on Either<E, T> {
  /// Transform the value inside `Right` while keeping `Left` unchanged
  Either<E, R> map<R>(
    R Function(T value) transform,
  ) =>
      switch (this) {
        Left(:final error) => Left(error),
        Right(:final value) => Right(transform(value)),
      };

  /// Chain operations that return `Either`.
  Either<E, R> flatMap<R>(
    Either<E, R> Function(T value) transform,
  ) =>
      switch (this) {
        Left(:final error) => Left(error),
        Right(:final value) => transform(value),
      };

  /// Fold function to handle both success and failure cases
  R fold<R>({
    required R Function(E error) onLeft,
    required R Function(T value) onRight,
  }) =>
      switch (this) {
        Left(:final error) => onLeft(error),
        Right(:final value) => onRight(value),
      };
}
