sealed class SumType<T> {
  const SumType();

  SumType<R> map<R>(R Function(T value) transform);

  SumType<R> flatMap<R>(SumType<R> Function(T value) transform);

  SumType<T> filter(bool Function(T value) predicate) =>
      throw UnimplementedError(
          "Method [filter] is not implemented by $runtimeType.");
}

sealed class Maybe<T> extends SumType<T> {
  const Maybe();

  bool get isJust => this is Just<T>;

  bool get isNothing => this is Nothing<T>;

  @override
  Maybe<R> map<R>(R Function(T value) transform) => switch (this) {
        Just(:final value) => Just<R>(transform(value)),
        Nothing() => Nothing<R>(),
      };

  @override
  Maybe<R> flatMap<R>(covariant Maybe<R> Function(T value) transform) =>
      switch (this) {
        Just(:final value) => transform(value),
        Nothing() => Nothing<R>(),
      };

  @override
  Maybe<T> filter(bool Function(T value) predicate) => switch (this) {
        Just(:final value) when predicate(value) => this,
        _ => Nothing<T>(),
      };
}

final class Nothing<T> extends Maybe<T> {
  const Nothing();

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => other is Nothing<T>;

  @override
  String toString() => "Nothing";
}

final class Just<T> extends Maybe<T> {
  const Just(this.value);

  final T value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => other is Just<T> && other.value == value;

  @override
  String toString() => "Nothing";
}

sealed class Either<E, T> extends SumType<T> {
  const Either();

  bool get isLeft => this is Left<E, T>;

  bool get isRight => this is Right<E, T>;

  @override
  Either<E, R> map<R>(R Function(T value) transform) => switch (this) {
        Left(:final error) => Left<E, R>(error),
        Right(:final value) => Right<E, R>(transform(value)),
      };

  @override
  Either<E, R> flatMap<R>(covariant Either<E, R> Function(T value) transform) =>
      switch (this) {
        Left(:final error) => Left<E, R>(error),
        Right(:final value) => transform(value),
      };

  R fold<R>({
    required R Function(E error) onLeft,
    required R Function(T value) onRight,
  }) =>
      switch (this) {
        Left(:final error) => onLeft(error),
        Right(:final value) => onRight(value),
      };
}

final class Left<E, T> extends Either<E, T> {
  const Left(this.error);

  final E error;

  @override
  int get hashCode => error.hashCode;

  @override
  bool operator ==(Object other) => other is Left<E, T> && other.error == error;

  @override
  String toString() => "Left($error)";
}

final class Right<E, T> extends Either<E, T> {
  const Right(this.value);

  final T value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Right<E, T> && other.value == value;

  @override
  String toString() => "Right($value)";
}
