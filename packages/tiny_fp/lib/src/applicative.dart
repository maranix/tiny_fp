import "package:tiny_fp/src/functor.dart";

/// {@template applicative}
///
/// Represents an Applicative, which extends a Functor by supporting the
/// application of wrapped functions to wrapped values.
///
/// Implementers must define & adhere to Applicative Laws:
///
///
/// - [pure] to wrap a value in the Applicative context
/// - [ap] to apply a wrapped function to a wrapped value.
///
///
/// ### Applicative Laws:
/// The following laws must hold for all `Applicative` implementations:
///
/// 1. **Identity Law**:
///    Applying the identity function (`(x) => x`) wrapped inside the applicative to a wrapped value should return the same value wrapped in the applicative.
///    ```dart
///    applicative.pure((x) => x).ap(applicative) == applicative
///    ```
///
/// 2. **Homomorphism Law**:
///    Applying a wrapped function to a pure value should be the same as applying the function directly to the value and wrapping the result.
///    ```dart
///    applicative.pure(f).ap(applicative.pure(x)) == applicative.pure(f(x))
///    ```
///
/// 3. **Interchange Law**:
///    Applying a wrapped function to a wrapped value should be the same as applying the value to the wrapped function.
///    ```dart
///    func.ap(applicative.pure(x)) == applicative.pure((f) => f(x)).ap(func)
///    ```
///
/// 4. **Composition Law**:
///    Applying a composition of two wrapped functions should be the same as applying them sequentially inside the applicative.
///    ```dart
///    applicative.pure((f) => (g) => (x) => f(g(x))).ap(func.ap(func2)) == func.ap(func2.ap(applicative))
///    ```
///
/// {@endtemplate}
abstract interface class Applicative<T> implements Functor<T> {
  /// {@macro applicative}
  const Applicative();

  /// Wraps a value in the Applicative context.
  Applicative<T> pure(T value);

  /// Applies a wrapped function to a wrapped value.
  Applicative<R> ap<R>(Applicative<R Function(T)> f);
}
