import "package:tiny_fp/src/hkt.dart";

/// Applicative interface for HKT
///
/// - [C] is the constructor type
/// - [T] is the type parameter
abstract interface class Applicative<C, T> {
  /// Wraps a raw value of type [R] into the container.
  HKT<C, R> pure<R>(R value);

  /// Applies a function inside one container to a value inside another container.
  ///
  /// - [C] is the constructor type
  /// - [S] is the input type
  /// - [R] is the output type
  HKT<C, R> ap<S, R>(
    HKT<C, R Function(S)> hktFunc,
    HKT<C, S> hktVal,
  );
}
