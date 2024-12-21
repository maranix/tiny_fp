part of "hkt.dart";

/// Monad interface for High-Kinded Types (HKT)
///
/// A `Monad` is an abstraction that extends the `Applicative` interface, adding the
/// ability to chain operations that return values wrapped in a container (or context).
/// The `flatMap` method is the primary mechanism for chaining operations that return
/// monadic values. The `flatten` method is useful for flattening nested monadic structures.
///
/// - [C]: The constructor type (the container or wrapper type), which must extend `HKT`.
/// - [T]: The type of the value inside the container.
///
/// A `Monad` must satisfy the following laws:
/// 1. **Left identity law**: Applying a function to a value wrapped in the container
///    should be the same as just applying the function directly to the value.
///    ```dart
///    container.pure(value).flatMap(f) == f(value)
///    ```
/// 2. **Right identity law**: Applying the `flatMap` function to a value inside the container
///    should return the value wrapped inside the container.
///    ```dart
///    container.flatMap(container.pure) == container
///    ```
/// 3. **Associativity law**: The order in which you chain operations should not matter.
///    ```dart
///    container.flatMap(f).flatMap(g) == container.flatMap((x) => f(x).flatMap(g))
///    ```
abstract interface class Monad<C extends HKTMarker, T>
    extends Applicative<C, T> {
  /// Chains an operation that returns a new container (or context).
  ///
  /// This method allows you to chain operations that return new monadic values
  /// based on the current value inside the container. The result of this operation
  /// will be a new container with the value of the operation.
  ///
  /// - [f]: A function that takes a value of type [T] and returns a container of type [C].
  /// - Returns: A new container of type [C] that holds the result of the operation.
  ///
  /// Example:
  /// ```dart
  /// final result = Just(42).flatMap((value) => Just(value * 2));
  /// assert(result == Just(84));  // The value is transformed and wrapped in a new `Just` container.
  /// ```
  HKT<C, R> flatMap<R>(HKT<C, R> Function(T) f);

  /// Flattens a nested monadic structure into a single or multiple monadic container as defined by the constraint type [R].
  ///
  /// This method is useful for simplifying nested monadic structures like `Just<Just<T>>`
  /// into a single or multi-level monadic structure for ex: `Just<T>`.
  ///
  /// - Returns: A new container of type [C] that holds the flattened value.
  ///
  /// Example:
  ///
  /// - Single level flattening
  /// ```dart
  /// // The nested `Just` is flattened into type [R] wrapped inside Container [C].
  /// final result = Just(Just(42)).flatten<int>();
  /// assert(result == Just(42));
  /// ```
  ///
  /// ---
  ///
  /// - Multi-level flattening based on type [R] wrapped inside Container [C].
  /// ```dart
  /// final just = Just(Just(Just(Just(Just(42)))));
  ///
  /// // Nested `Just<Just<Just<Just<Just<int>>>>>` is flattened into type `Just<Just<int>>`.
  /// `final result1 = just.flatten<Just<int>>();`
  /// assert(result1 == Just(Just(42)));
  ///
  ///
  /// // Nested `Just<Just<Just<Just<Just<int>>>>>` is flattened into a type `Just<Just<Just<int>>>`.
  /// `final result2 = just.flatten<Just<Just<int>>>();`
  /// assert(result2 == Just(Just(Just(42))));
  /// ```
  ///
  HKT<C, R> flatten<R>();
}

/// Monad interface for High-Kinded Types (HKT) with two different type parameters.
///
/// A `Monad` is an abstraction that extends the `Applicative` interface, adding the
/// ability to chain operations that return values wrapped in a container (or context).
/// The `flatMap` method is the primary mechanism for chaining operations that return
/// monadic values. The `flatten` method is useful for flattening nested monadic structures.
///
/// - [C]: The constructor type (the container or wrapper type), which must extend `HKT`.
/// - [A]: The type of the first value inside the container.
/// - [B]: The type of the second value inside the container.
///
/// A `Monad` must satisfy the following laws:
/// 1. **Left identity law**: Applying a function to a value wrapped in the container
///    should be the same as just applying the function directly to the value.
///    ```dart
///    container.pure(value).flatMap(f) == f(value)
///    ```
/// 2. **Right identity law**: Applying the `flatMap` function to a value inside the container
///    should return the value wrapped inside the container.
///    ```dart
///    container.flatMap(container.pure) == container
///    ```
/// 3. **Associativity law**: The order in which you chain operations should not matter.
///    ```dart
///    container.flatMap(f).flatMap(g) == container.flatMap((x) => f(x).flatMap(g))
///    ```
abstract interface class Monad2<C extends HKTMarker, A, B>
    extends Applicative2<C, A, B> {
  /// Chains an operation that returns a new container (or context).
  ///
  /// This method allows you to chain operations that return new monadic values
  /// based on the current value inside the container. The result of this operation
  /// will be a new container with the value of the operation.
  ///
  /// - [f]: A function that takes a value of type [B] and returns a container of type [C].
  /// - Returns: A new container of type [C] that holds the result of the operation.
  ///
  /// Example:
  /// ```dart
  /// final result = Either("Some", 42).flatMap((value) => Either("None", value * 2));
  /// assert(result == Either("Some", 84));  // The value is transformed and wrapped in a new `Either` container.
  /// ```
  HKT2<C, A, T> flatMap<T>(HKT2<C, A, T> Function(B) f);

  /// Flattens a nested monadic structure into a single or nested monadic container depending on [T].
  ///
  /// This method is useful for simplifying nested monadic structures like `Either<Either<L, R>>`
  /// into a single monadic structure `Either<L, R>` or custom monadic structure based on [T].
  ///
  /// - Returns: A new container of type [C] that holds the flattened value.
  ///
  /// Example:
  ///
  /// - Single level flattening
  /// ```dart
  /// // The nested `Either` is flattened into type [R] wrapped inside Container [C].
  /// final result = Either(Either("Some", 42)).flatten<int>();
  /// assert(result == Either("Some", 42));
  /// ```
  ///
  /// ---
  ///
  /// - Multi-level flattening based on type [R] wrapped inside Container [C].
  /// ```dart
  /// final either = Either(Either(Either(Either(Either("Some", 42)))));
  ///
  /// // Nested `Either<Either<Either<Either<Either<L, R>>>>>` is flattened into type `Either<Either<L, R>>`.
  /// `final result1 = either.flatten<Either<String, int>>();`
  /// assert(result1 == Either(Either(42)));
  ///
  ///
  /// // Nested `Either<Either<Either<Either<Either<L, R>>>>>` is flattened into a type `Either<Either<Either<L, R>>>`.
  /// `final result2 = either.flatten<Either<Either<String, int>>>();`
  /// assert(result2 == Either(Either(Either("Some", 42))));
  /// ```
  ///
  HKT2<C, A, T> flatten<T>();
}
