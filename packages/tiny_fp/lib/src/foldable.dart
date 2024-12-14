/// {@template foldable}
///
///// Represents a Foldable, which allows reducing a data structure to a single
/// summary value.
///
/// Implementers must define & adhere to Foldable Laws:
///
///
/// - [fold] to combine the values in the data structure into a single result.
/// - [foldMap] to map each value to a monoidal value before combining.
///
///
/// /// ### Foldable Laws:
/// The following laws must hold for all `Foldable` implementations:
///
/// 1. **Associative Law**:
///    The order in which we combine values during folding should not affect the result, as long as the combining function is associative.
///    ```dart
///    fold(acc, combine).foldMap(mapFunc, combine) == combine(fold(acc, combine))
///    ```
///
/// 2. **Left Identity Law**:
///    The initial value provided to the fold operation should not affect the result when combined with the first element.
///    ```dart
///    fold(initial, combine).foldMap(mapFunc, combine) == initial
///    ```
///
/// {@endtemplate}
abstract interface class Foldable<T> {
  /// {@macro foldable}
  const Foldable();

  /// Reduces the data structure to a single value using an accumulator and a combining function.
  R fold<R>(R initialValue, R Function(R acc, T value) combine);

  /// Maps each value to a monoidal value and combines them into a single result.
  R foldMap<R>(R Function(T value) mapFunc, R Function(R acc, T value) combine);
}
