import "package:meta/meta.dart";
import "package:tiny_fp/src/applicative.dart";
import "package:tiny_fp/src/eq.dart";
import "package:tiny_fp/src/functor.dart";
import "package:tiny_fp/src/hkt.dart";
import "package:tiny_fp/src/identity.dart";
import "package:tiny_fp/src/monad.dart";

/// Box type implementing multiple abstractions:
/// Functor, Applicative, Monad, Identity, and Eq.
///
/// - [T] is the type parameter.
@immutable
final class Box<T> extends HKT<Box, T>
    implements
        Functor<Box, T>,
        Applicative<Box, T>,
        Monad<Box, T>,
        Eq<Box, T>,
        Identity<T> {
  const Box(T value) : _value = value;

  final T _value;

  @override
  Box<R> map<R>(R Function(T) f) => Box(f(_value));

  @override
  Box<R> pure<R>(R value) => Box(value);

  @override
  Box<R> ap<S, R>(
    covariant Box<R Function(S)> boxFunc,
    covariant Box<S> box,
  ) =>
      pure(boxFunc._value(box.extract()));

  @override
  Box<R> flatMap<R>(covariant Box<R> Function(T) f) => f(_value);

  @override
  Box<R> flatten<R>() {
    dynamic current = this._value;

    while (current is Box) {
      if (current._value is R) {
        return pure(current._value);
      }

      current = current._value;
    }

    // Ensure the final value matches the expected type
    if (current is! R) {
      throw TypeError();
    }

    return pure(current);
  }

  @override
  T extract() => _value;

  @override
  bool equals(covariant Box<T> other) =>
      identical(this, other) || _value == other.extract();

  @override
  bool operator ==(covariant Box<T> other) => equals(other);

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => "Box($_value)";
}
