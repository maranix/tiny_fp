part of "hkt.dart";

/// Applicative interface for High-Kinded Types (HKT)
///
/// The `Applicative` interface is an extension of `Functor`, providing the ability
/// to apply a function wrapped inside a container to a value wrapped inside another container.
/// It allows you to work with values that are wrapped in a context (or container) and apply
/// functions inside that context to other values inside a similar context.
///
/// - [C]: The constructor type (the container or wrapper type), which must extend `HKT`.
/// - [T]: The type of the value inside the container.
/// - [R]: The type of the transformed value after applying the function inside the container.
///
/// An `Applicative` must satisfy the following laws:
/// 1. **Identity law**: Applying a function that returns the value itself should result in the original container.
/// 2. **Homomorphism law**: Applying a pure function (`pure(f)`) inside the container should work the same as applying the function to the value directly, then wrapping the result in the container.
/// 3. **Interchange law**: The order of function application and wrapping/unwrapping should not affect the result.
///
/// Example:
/// ```dart
/// final func = Just((int value) => value * 2);
/// final value = Just(42);
/// final result = func.ap(func, value);  // Applies the function inside `func` to the value inside `value`.
/// assert(result == Just(84));     // The function was applied, and the result is wrapped in `Just()`.
/// ```
abstract interface class Applicative<C extends HKTMarker, T>
    extends Functor<C, T> {
  /// Wraps a raw value of type [R] into the container.
  ///
  /// This method takes a raw value and wraps it inside the container (or context).
  ///
  /// - [value]: The raw value of type [R] to be wrapped in the container.
  /// - Returns: A new container of type [C] that holds the value.
  ///
  /// Example:
  /// ```dart
  /// final result = Just(10).pure(42);
  /// assert(result == Just(42));  // The value is wrapped inside `Just()`.
  /// ```
  HKT<C, R> pure<R>(R value);

  /// Applies a function inside one container to a value inside another container.
  ///
  /// This method allows you to apply a function that is inside one container
  /// to a value inside another container. The result is a new container that holds
  /// the result of the function application.
  ///
  /// - [hktFunc]: A container that holds a function of type [R Function(S)].
  /// - Returns: A new container of type [C] that holds the result of applying the function to the value.
  ///
  /// Example:
  /// ```dart
  /// final hktFunc = Box((int x) => x * 2); // A function wrapped in Box
  /// final hktValue = Box(21); // A value wrapped in Box
  /// final result = hktValue.ap(hktFunc);
  /// assert(result == Box(42));     // The value inside `Just()` was doubled.
  /// ```
  ///
  /// **Note:** The `ap` method assumes that the function is wrapped in an HKT and applies
  /// it to the value in the current HKT. If either the function or value is invalid,
  /// the implementation should handle it appropriately.
  ///
  HKT<C, R> ap<R>(HKT<C, R Function(T)> hktFunc);
}
