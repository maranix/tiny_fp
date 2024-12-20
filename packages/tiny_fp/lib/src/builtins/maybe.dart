import "package:tiny_fp/src/applicative.dart";
import "package:tiny_fp/src/eq.dart";
import "package:tiny_fp/src/functor.dart";
import "package:tiny_fp/src/hkt.dart";
import "package:tiny_fp/src/identity.dart";
import "package:tiny_fp/src/monad.dart";

const _extractNothingMessage =
    "Cannot extract value from Nothing, as Nothing does not contain a value";

sealed class Maybe<T> extends HKT<Maybe, T>
    implements
        Eq<Maybe, T>,
        Functor<Maybe, T>,
        Applicative<Maybe, T>,
        Monad<Maybe, T> {
  const Maybe();

  R when<R>({
    required R Function(T) just,
    required R Function() nothing,
  }) =>
      switch (this) {
        Just<T>(:final _value) => just(_value),
        Nothing() => nothing(),
      };

  bool get isJust;

  bool get isNothing;

  @override
  Maybe<R> map<R>(R Function(T) f);

  @override
  Just<R> pure<R>(R value) => Just(value);

  @override
  Maybe<R> ap<S, R>(
    covariant Maybe<R Function(S)> f,
    covariant Maybe<S> m,
  );

  @override
  Maybe<R> flatMap<R>(covariant Maybe<R> Function(T) f);

  @override
  Maybe<R> flatten<R>();

  @override
  bool equals(covariant Maybe<T> other);

  @override
  bool operator ==(covariant Maybe<T> other);

  @override
  int get hashCode;
}

final class Just<T> extends Maybe<T> implements Identity<T> {
  const Just(T value) : _value = value;

  final T _value;

  @override
  bool get isJust => true;

  @override
  bool get isNothing => false;

  @override
  Just<R> map<R>(R Function(T) f) => pure(f(_value));

  @override
  Just<R> ap<S, R>(
    Just<R Function(S)> f,
    Just<S> m,
  ) =>
      pure(f._value(m._value));

  @override
  Just<R> flatMap<R>(Just<R> Function(T) f) => f(_value);

  @override
  Just<R> flatten<R>() {
    dynamic current = _value;

    while (current is Just) {
      if (current._value is R) {
        return pure(current._value);
      }

      current = current._value;
    }

    if (current is! R) {
      throw TypeError();
    }

    return pure(current);
  }

  @override
  T extract() => _value;

  @override
  bool equals(Just<T> other) =>
      (identical(this, other) || this._value == other._value);

  @override
  bool operator ==(Just<T> other) => equals(other);

  @override
  int get hashCode => _value.hashCode;
}

final class Nothing extends Maybe<Never> {
  const Nothing._();

  static const _instance = Nothing._();

  factory Nothing() => _instance;

  @override
  bool get isJust => false;

  @override
  bool get isNothing => true;

  @override
  Nothing map<R>(R Function(Never) f) => Nothing();

  @override
  Maybe<R> ap<S, R>(
    Maybe<R Function(S)> f,
    Maybe<S> m,
  ) =>
      this;

  @override
  Nothing flatMap<R>(Nothing Function(Never) f) => this;

  @override
  Nothing flatten<Never>() => this;

  @override
  bool equals(Nothing other) =>
      identical(this, other) || runtimeType == other.runtimeType;

  @override
  bool operator ==(Nothing other) => equals(other);

  @override
  int get hashCode => 0;
}
