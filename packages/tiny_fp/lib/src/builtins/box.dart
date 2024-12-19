import "package:tiny_fp/src/applicative.dart";
import "package:tiny_fp/src/eq.dart";
import "package:tiny_fp/src/functor.dart";
import "package:tiny_fp/src/hkt.dart";
import "package:tiny_fp/src/identity.dart";
import "package:tiny_fp/src/monad.dart";

final class Box<T> extends HKT<Box, T>
    implements
        Functor<Box, T>,
        Applicative<Box, T>,
        Monad<Box, T>,
        Identity<Box, T>,
        Eq<Box<T>> {
  const Box(this.value);

  final T value;

  @override
  Box<R> map<R>(R Function(T) f) => Box(f(value));

  @override
  Box<R> pure<R>(R value) => Box(value);

  @override
  Box<R> ap<S, R>(
    covariant Box<R Function(S)> boxFunc,
    covariant Box<S> boxVal,
  ) =>
      pure(boxFunc.value(boxVal.value));

  @override
  Box<R> flatMap<R>(covariant Box<R> Function(T) f) => f(value);

  @override
  T extract() => value;

  @override
  bool equals(Box<T> other) => identical(this, other) || value == other.value;

  @override
  bool operator ==(covariant Box<T> other) => equals(other);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "Box($value)";
}
