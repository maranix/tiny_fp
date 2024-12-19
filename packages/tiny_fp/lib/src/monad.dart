import "package:tiny_fp/src/applicative.dart";
import "package:tiny_fp/src/functor.dart";
import "package:tiny_fp/src/hkt.dart";

/// Monad interface for HKT
///
/// Monad builds upon [Applicative] and [Functor] abstractions.
///
/// - [C] is the constructor type
/// - [T] is the type parameter
abstract interface class Monad<C, T>
    implements Applicative<C, T>, Functor<C, T> {
  /// Flattens the value inside the container using a function `f` on a single level.
  ///
  /// - [R] is the output type after transformation.
  /// - [f] is a function that maps the value inside the monad to another monad.
  HKT<C, R> flatMap<R>(HKT<C, R> Function(T) f);

  /// Flattens nested values inside the container until a single level is remaining.
  HKT<C, R> flatten<R>();
}
