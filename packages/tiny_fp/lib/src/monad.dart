/// {@template monad}
///
/// Represents a Monad, which extends an Applicative by supporting
/// chaining of computations that produce wrapped values.
///
/// Implementers must define & adhere to Monad Laws:
///
///
/// - [flatMap] (also called `bind`) to chain computations that return wrapped value.
///
///
/// /// ### Monad Laws:
/// The following laws must hold for all `Monad` implementations:
///
/// 1. **Left Identity Law**:
///    Lifting a value into a monad and applying a function to it should give the same result as applying the function directly to the value.
///    ```dart
///    monad.pure(x).flatMap(f) == f(x)
///    ```
///
/// 2. **Right Identity Law**:
///    Applying `flatMap` with the identity function (`(x) => monad.pure(x)`) should return the same monad.
///    ```dart
///    monad.flatMap((x) => monad.pure(x)) == monad
///    ```
///
/// 3. **Associativity Law**:
///    Chaining computations via `flatMap` should be associative. That is, the order in which we chain them should not matter.
///    ```dart
///    monad.flatMap(f).flatMap(g) == monad.flatMap((x) => f(x).flatMap(g))
///    ```
///
/// {@endtemplate}
abstract interface class Monad<T> {
  /// {@macro monad}
  const Monad();

  /// Chains a computation that produces a wrapped value.
  Monad<R> flatMap<R>(Monad<R> Function(T value) f);
}
