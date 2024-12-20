part of "hkt.dart";

/// Functor interface for High-Kinded Types
///
/// The `Functor` interface represents a type that can be mapped over. It provides
/// a way to apply a function to the value inside a container (HKT) and return a new
/// container with the transformed value.
///
/// - [C]: The constructor type (the container or wrapper type).
/// - [T]: The type of the value inside the container.
/// - [R]: The type of the transformed value after applying the function.
///
/// A `Functor` must satisfy the following laws:
/// 1. **Identity law**: `map(id) == self`, where `id` is the identity function.
/// 2. **Composition law**: `map(f).map(g) == map(f.compose(g))`, where `compose` is function composition.
///
/// Example:
/// ```dart
/// final box = Box(42);
/// final result = box.map((value) => value * 2);
/// assert(result == Box(84)); // The value inside the box was doubled.
/// ```
abstract interface class Functor<C extends HKTMarker, T> {
  /// Maps a function `f` over the value inside the container.
  ///
  /// This method takes a function that transforms the value inside the container
  /// and applies it, returning a new container with the transformed value.
  ///
  /// - [f]: A function that takes a value of type [T] and returns a value of type [R].
  /// - Returns: A new container of type [C] with the transformed value of type [R].
  ///
  /// Example:
  /// ```dart
  /// final maybe = Maybe.just(42);
  /// final result = maybe.map((value) => value * 2);
  /// assert(result == Maybe.just(84)); // The value was doubled inside the container.
  /// ```
  HKT<C, R> map<R>(R Function(T) f);
}
