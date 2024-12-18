/// Identity interface for HKT
///
/// - [C] is the constructor type.
/// - [T] is the type parameter.
abstract interface class Identity<C, T> {
  /// Extracts the value from the container.
  T extract();
}
