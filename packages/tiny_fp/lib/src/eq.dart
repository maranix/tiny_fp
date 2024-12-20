import "package:tiny_fp/src/hkt.dart";

/// Eq interface for HKT
///
/// - [C] is the type constructor.
/// - [T] is the type parameter.
abstract interface class Eq<C, T> {
  /// Compares the value inside the container with another value.
  bool equals(HKT<C, T> other);
}
