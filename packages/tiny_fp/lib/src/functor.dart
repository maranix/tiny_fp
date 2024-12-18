import "package:tiny_fp/src/hkt.dart";

/// Functor interface for HKT
///
/// - [C] is the constructor type
/// - [T] is the type of value that it will operate on
abstract interface class Functor<C, T> {
  /// Maps a function `f` over the value inside the HKT.
  ///
  /// - [C] is the constructor type
  /// - [R] is the output type
  /// - [T] is the input type
  HKT<C, R> map<R>(R Function(T) f);
}
