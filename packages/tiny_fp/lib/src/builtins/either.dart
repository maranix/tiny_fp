import "package:tiny_fp/src/hkt.dart";

sealed class Either<L, R> extends HKT2<Either, L, R>
    implements
        Eq2<Either, L, R>,
        Functor2<Either, L, R>,
        Applicative2<Either, L, R>,
        Monad2<Either, L, R> {
  const Either();

  /// Executes one of two functions depending on whether the instance is `Left` or `Right`.
  T when<T>({
    required T Function(L left) left,
    required T Function(R right) right,
  }) =>
      switch (this) {
        Left<L, R>(:final _value) => left(_value),
        Right<L, R>(:final _value) => right(_value),
      };

  const factory Either.left(L value) = Left<L, R>;

  const factory Either.right(R value) = Right<L, R>;

  /// Checks if the value is a `Left`.
  bool get isLeft;

  /// Checks if the value is a `Right`.
  bool get isRight;

  L fromLeft(L defaultValue);

  R fromRight(R defaultValue);

  @override
  Either<L, T> map<T>(T Function(R) f);

  @override
  Either<L, T> pure<T>(T value) => Right(value);

  @override
  Either<L, T> ap<T>(covariant Either<L, T Function(R)> f);

  @override
  Either<L, T> flatMap<T>(covariant Either<L, T> Function(R) f);

  @override
  Either<L, T> flatten<T>();

  @override
  bool equals(covariant Either<L, R> other);

  @override
  bool operator ==(covariant Either<L, R> other);

  @override
  int get hashCode;
}

final class Left<L, R> extends Either<L, R> implements Identity<L> {
  const Left(this._value);

  final L _value;

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  L fromLeft(L defaultValue) => _value;

  @override
  R fromRight(R defaultValue) => defaultValue;

  @override
  Left<L, T> map<T>(T Function(R) f) => Left(_value);

  @override
  Left<L, T> ap<T>(Either<L, T Function(R)> f) => Left(_value);

  @override
  Left<L, T> flatMap<T>(Either<L, T> Function(R) f) => Left(_value);

  @override
  Left<L, T> flatten<T>() => Left(_value);

  @override
  L extract() => _value;

  @override
  bool equals(Left<L, R> other) =>
      identical(this, other) || _value == other._value;

  @override
  bool operator ==(Left<L, R> other) => equals(other);

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => "Left($_value)";
}

final class Right<L, R> extends Either<L, R> implements Identity<R> {
  const Right(this._value);

  final R _value;

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  L fromLeft(L defaultValue) => defaultValue;

  @override
  R fromRight(R defaultValue) => _value;

  @override
  Either<L, T> map<T>(T Function(R) f) => pure(f(_value));

  @override
  Either<L, T> ap<T>(Either<L, T Function(R)> f) =>
      f.flatMap((func) => map(func));

  @override
  Either<L, T> flatMap<T>(Either<L, T> Function(R) f) => f(_value);

  @override
  Either<L, T> flatten<T>() {
    dynamic current = _value;

    while (current is Right) {
      if (current._value is T) {
        return pure(current._value);
      }

      current = current._value;
    }

    if (current is! T) {
      throw TypeError();
    }

    return pure(current);
  }

  @override
  R extract() => _value;

  @override
  bool equals(Right<L, R> other) =>
      identical(this, other) || _value == other._value;

  @override
  bool operator ==(Right<L, R> other) => equals(other);

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => "Right($_value)";
}
