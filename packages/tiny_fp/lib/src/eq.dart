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

/// Eq interface for High-Kinded Types with two different type definitions.
///
/// The `Eq` interface provides a way to compare the values contained in two
/// instances of a type. This is useful for checking whether two containers
/// (or values inside them) are equal. Types that implement `Eq` should define
/// equality logic based on the value contained in the container, not the container
/// itself.
///
/// - [C]: The type of the constructor (container) itself.
/// - [A]: The type of the first value inside the container.
/// - [B]: The type of the second value inside the container.
///
/// Example:
/// ```dart
/// final either1 = Either("Fourty Two", 42);
/// final either2 = Either("Fourty Two", 42);
/// final either3 = Either(3.14, 42);
///
/// assert(either1.equals(either2)); // true, values are equal.
/// assert(!either1.equals(either3)); // false, values are different.
/// ```
abstract interface class Eq2<C extends HKTMarker, A, B> {
  /// Compares the value inside the container with another container's value.
  ///
  /// This method checks if the internal values of two containers are equal.
  /// The equality comparison is based on the values held by the containers,
  /// not the containers themselves. It should return `true` if the values are equal
  /// and `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final either1 = Either("Fourty Two", 42);
  /// final either2 = Either("Fourty Two", 42);
  /// final either3 = Either(3.14, 42);
  ///
  /// assert(either1.equals(either2)); // true, values are equal.
  /// assert(!either1.equals(either3)); // false, values are different.
  /// ```
  bool equals(HKT2<C, A, B> other);
}
