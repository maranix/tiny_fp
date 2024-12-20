part of "hkt.dart";

/// Eq interface for High-Kinded Types
///
/// The `Eq` interface provides a way to compare the values contained in two
/// instances of a type. This is useful for checking whether two containers
/// (or values inside them) are equal. Types that implement `Eq` should define
/// equality logic based on the value contained in the container, not the container
/// itself.
///
/// - [C]: The type of the constructor (container) itself.
/// - [T]: The type of the value inside the container.
///
/// Example:
/// ```dart
/// final box1 = Box(42);
/// final box2 = Box(42);
/// final box3 = Box(100);
///
/// assert(box1.equals(box2)); // true, values are equal.
/// assert(!box1.equals(box3)); // false, values are different.
/// ```
abstract interface class Eq<C extends HKTMarker, T> {
  /// Compares the value inside the container with another container's value.
  ///
  /// This method checks if the internal values of two containers are equal.
  /// The equality comparison is based on the values held by the containers,
  /// not the containers themselves. It should return `true` if the values are equal
  /// and `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final maybe1 = Maybe.just(42);
  /// final maybe2 = Maybe.just(42);
  /// final maybe3 = Maybe.just(100);
  ///
  /// assert(maybe1.equals(maybe2)); // true, values are equal.
  /// assert(!maybe1.equals(maybe3)); // false, values are different.
  /// ```
  bool equals(HKT<C, T> other);
}
