part of "hkt.dart";

/// Identity interface for High-Kinded Types
///
/// The `Identity` abstraction provides a way to extract the internal value
/// from a container type. This interface is foundational for types like `Maybe`
/// and `Box` where the concept of holding and extracting a value is central.
///
/// - [T]: The type of the value contained in the implementing structure.
///
/// Example:
/// ```dart
/// final box = Box(42); // A Box containing the value 42.
/// final extractedValue = box.extract(); // Returns 42.
/// ```
abstract interface class Identity<T> {
  /// Extracts the internal value from the container.
  ///
  /// This method provides a standardized way to retrieve the value held
  /// by any structure that implements `Identity`.
  ///
  /// Example:
  /// ```dart
  /// final maybe = Maybe.just(42);
  /// final value = maybe.extract(); // Returns 42.
  /// ```
  ///
  /// Implementing classes should ensure that this method adheres to their
  /// semantics. For instance:
  /// - For `Maybe.just`, it returns the wrapped value.
  /// - For `Maybe.nothing`, it may throw an error or return a default value
  ///   depending on the implementation.
  T extract();
}
