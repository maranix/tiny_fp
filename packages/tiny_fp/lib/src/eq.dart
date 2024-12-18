/// Eq interface for HKT
///
/// - [T] is the type parameter.
abstract interface class Eq<T> {
  /// Compares the value inside the container with another value.
  bool equals(T other);
}
