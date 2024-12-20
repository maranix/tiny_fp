import "package:tiny_fp/src/hkt.dart";

/// A container type that may or may not contain a value of type [T].
///
/// The `Maybe` class is a sealed class that encapsulates a value that can either
/// be present (`Just`) or absent (`Nothing`). It implements functional programming
/// abstractions like [Eq], [Functor], [Applicative], and [Monad] for working with
/// optional values, and supports operations such as mapping, applying functions, and
/// chaining computations on the wrapped value.
///
/// This is useful when working with computations that may fail or return no result,
/// without the need for nullable types or exceptions.
///
/// Example:
/// ```dart
/// final maybeValue = Maybe.just(42);
/// final result = maybeValue.map((x) => x * 2);
/// print(result.extract()); // 84
/// ```
sealed class Maybe<T> extends HKT<Maybe, T>
    implements Eq<Maybe, T>, Functor<Maybe, T>, Applicative<Maybe, T>, Monad<Maybe, T> {
  const Maybe();

  /// A factory method that creates a `Just` container with the specified value.
  ///
  /// **Note:** This method is not recommended for general use, as it loses the
  /// type safety value and instead returns [Maybe<T>.just] instead of [Just<T>].
  ///
  /// It is better to directly initialize the concrete type using `Just` for type safety and clarity.
  ///
  /// This method is provided for convenience, it's strongly recommended to combine its usage with [toJust] method
  /// to retain type safety and get concrete [Just] instead of being of a subclass of [Maybe].
  ///
  /// Example usage:
  /// ```dart
  /// final maybe = Maybe.just(42);
  /// // It's recommended to use `Just` directly:
  /// final just = Just(42);
  /// ```
  const factory Maybe.just(T value) = Just<T>;

  /// A factory constructor that creates a singleton `Nothing`, representing the absence of a value.
  ///
  /// This is used to represent a `Maybe` container that does not contain any value.
  ///
  /// Example:
  /// ```dart
  /// final maybeValue = Maybe.nothing();
  /// final nothing = Nothing();
  /// assert(maybeValue == nothing);
  /// ```
  factory Maybe.nothing() => Nothing();

  /// Converts the current [Maybe] instance to a [Just] if it contains a value, or throws a [TypeError] if it is [Nothing].
  ///
  /// This method is useful when you are confident that the `Maybe` instance contains a value (`Just`) and need to treat it as such.
  ///
  /// Example:
  /// ```dart
  /// final maybeValue = Maybe.just(42);
  /// final justValue = maybeValue.toJust();
  /// print(justValue); // Just(42)
  /// ```
  Just<T> toJust() => when(
        just: (_) => this as Just<T>,
        nothing: () => throw TypeError(),
      );

  /// Returns instance of [Nothing], representing the absence of a value.
  ///
  /// Example:
  /// ```dart
  /// final maybeValue = Maybe.just(42);
  /// final nothingValue = maybeValue.toNothing();
  /// print(nothingValue); // Nothing()
  /// ```
  Nothing toNothing() => Nothing();

  /// Executes one of two functions based on the current state of the `Maybe` container:
  /// - [just]: The function to run when the value is present (`Just`).
  /// - [nothing]: The function to run when there is no value (`Nothing`).
  ///
  /// Example:
  /// ```dart
  /// final maybeValue = Maybe.just(42);
  /// final result = maybeValue.when(
  ///     just: (x) => 'Value is $x',
  ///     nothing: () => 'No value');
  /// print(result); // 'Value is 42'
  /// ```
  R when<R>({
    required R Function(T) just,
    required R Function() nothing,
  }) =>
      switch (this) {
        Just<T>(:final _value) => just(_value),
        Nothing() => nothing(),
      };

  /// Returns true if the `Maybe` contains a value.
  ///
  /// Example:
  /// ```dart
  /// final maybeValue = Maybe.just(42);
  /// print(maybeValue.isJust); // true
  /// ```
  bool get isJust;

  /// Returns true if the `Maybe` does not contain a value.
  ///
  /// Example:
  /// ```dart
  /// final maybeValue = Maybe.nothing();
  /// print(maybeValue.isNothing); // true
  /// ```
  bool get isNothing;

  /// Maps a function [f] over the value inside the `Maybe` and returns a new `Maybe` with the result.
  ///
  /// If the `Maybe` is `Nothing`, it will remain `Nothing`, otherwise, it will apply the function to the value inside.
  ///
  /// - [f]: A function that takes a value of type [T] and returns a new value of type [R].
  ///
  /// Example:
  /// ```dart
  /// final maybeValue = Maybe.just(42);
  /// final result = maybeValue.map((x) => x * 2);
  /// print(result.extract()); // 84
  /// ```
  @override
  Maybe<R> map<R>(R Function(T) f);

  /// Wraps a value [value] into a new `Just` container.
  ///
  /// Example:
  /// ```dart
  /// final maybeValue = Maybe.just(42);
  /// final newMaybe = maybeValue.pure(100);
  /// print(newMaybe.extract()); // 100
  /// ```
  @override
  Just<R> pure<R>(R value) => Just(value);

  /// Applies a function inside another `Maybe` to the value inside the current `Maybe`.
  ///
  /// If either `Maybe` is `Nothing`, the result will be `Nothing`, otherwise, it will apply the function inside the first `Maybe` to the value inside the second `Maybe`.
  ///
  /// Example:
  /// ```dart
  /// final maybeFn = Maybe.just((x) => x * 2);
  /// final maybeVal = Maybe.just(21);
  /// final result = maybeFn.ap(maybeVal);
  /// print(result.extract()); // 42
  /// ```
  @override
  Maybe<R> ap<R>(covariant Maybe<R Function(T)> f);

  /// Chains a computation that returns a new `Maybe` from the value inside the current `Maybe`.
  ///
  /// If the current `Maybe` is `Nothing`, it will remain `Nothing`, otherwise, it will apply the function to the value inside.
  ///
  /// Example:
  /// ```dart
  /// final maybeValue = Maybe.just(42);
  /// final result = maybeValue.flatMap((x) => Maybe.just(x * 2));
  /// print(result.extract()); // 84
  /// ```
  @override
  Maybe<R> flatMap<R>(covariant Maybe<R> Function(T) f);

  /// Flattens a nested `Maybe` structure (`Maybe<Maybe<T>>`) into a single level `Maybe`.
  ///
  /// Example:
  /// ```dart
  /// final nestedMaybe = Maybe.just(Maybe.just(42));
  /// final flattenedMaybe = nestedMaybe.flatten();
  /// print(flattenedMaybe.extract()); // 42
  /// ```
  @override
  Maybe<R> flatten<R>();

  /// Compares the current `Maybe` to another `Maybe` for equality.
  ///
  /// - Returns true if both containers are of the same type and their values are equal.
  ///
  /// Example:
  /// ```dart
  /// final maybe1 = Maybe.just(42);
  /// final maybe2 = Maybe.just(42);
  /// final result = maybe1.equals(maybe2); // true
  /// ```
  @override
  bool equals(covariant Maybe<T> other);

  /// Equality operator.
  @override
  bool operator ==(covariant Maybe<T> other);

  /// Hash code of the `Maybe`.
  @override
  int get hashCode;
}

// sealed class Maybe<T> extends HKT<Maybe, T>
//     implements
//         Eq<Maybe, T>,
//         Functor<Maybe, T>,
//         Applicative<Maybe, T>,
//         Monad<Maybe, T> {
//   const Maybe();
//
//   R when<R>({
//     required R Function(T) just,
//     required R Function() nothing,
//   }) =>
//       switch (this) {
//         Just<T>(:final _value) => just(_value),
//         Nothing() => nothing(),
//       };
//
//   bool get isJust;
//
//   bool get isNothing;
//
//   @override
//   Maybe<R> map<R>(R Function(T) f);
//
//   @override
//   Just<R> pure<R>(R value) => Just(value);
//
//   @override
//   Maybe<R> ap<R>(covariant Maybe<R Function(T)> f);
//
//   @override
//   Maybe<R> flatMap<R>(covariant Maybe<R> Function(T) f);
//
//   @override
//   Maybe<R> flatten<R>();
//
//   @override
//   bool equals(covariant Maybe<T> other);
//
//   @override
//   bool operator ==(covariant Maybe<T> other);
//
//   @override
//   int get hashCode;
// }

/// A concrete class that represents a value wrapped in a `Maybe` container.
///
/// `Just<T>` is used to represent a valid value of type `T` inside a `Maybe` container.
/// It implements the `Identity<T>` interface and inherits from `Maybe<T>`, providing
/// additional functionalities such as mapping, applying functions, and flattening.
///
/// A `Just` is used to signify that a valid value exists. The opposite of `Just` is `Nothing`,
/// which represents the absence of a value.
///
/// Example usage:
/// ```dart
/// final justValue = Just(42);
/// // Access the value using extract:
/// print(justValue.extract()); // 42
/// ```
final class Just<T> extends Maybe<T> implements Identity<T> {
  /// Creates a `Just` instance containing the provided [value].
  ///
  /// Example usage:
  /// ```dart
  /// final justValue = Just(42);
  /// ```
  const Just(T value) : _value = value;

  final T _value;

  @override
  bool get isJust => true;

  @override
  bool get isNothing => false;

  /// Applies the function [f] to the value inside the container and returns a new `Just`
  /// containing the result.
  ///
  /// Example:
  /// ```dart
  /// final just = Just(2);
  /// final result = just.map((x) => x * 2);
  /// print(result.extract()); // 4
  /// ```
  @override
  Just<R> map<R>(R Function(T) f) => pure(f(_value));

  /// Applies the function inside the `Just` (a function of type `R Function(T)`) to the value
  /// inside this `Just` container and returns a new `Just<R>`.
  ///
  /// Example:
  /// ```dart
  /// final justFn = Just<int Function(int)>((x) => x * 2);
  /// final justVal = Just(5);
  /// final result = justFn.ap(justVal);
  /// print(result.extract()); // 10
  /// ```
  @override
  Just<R> ap<R>(Just<R Function(T)> f) => pure(f._value(_value));

  /// Chains a computation that returns a new `Maybe` from the value inside the current `Maybe`.
  ///
  /// If the current `Maybe` is `Nothing`, it will remain `Nothing`, otherwise, it will apply the function to the value inside.
  ///
  /// Example:
  /// ```dart
  /// final just = Just(42);
  /// final result = just.flatMap((x) => Just(x * 2));
  /// print(result.extract()); // 84
  /// ```
  @override
  Just<R> flatMap<R>(Just<R> Function(T) f) => f(_value);

  /// Flattens a nested `Just` structure by recursively extracting values until a non-nested
  /// value is found. If the values inside the nested `Just` do not match the expected type `R`,
  /// a `TypeError` will be thrown.
  ///
  /// Example:
  /// ```dart
  /// final nestedJust = Just(Just(42));
  /// final result = nestedJust.flatten();
  /// print(result.extract()); // 42
  /// ```
  @override
  Just<R> flatten<R>() {
    dynamic current = _value;

    while (current is Just) {
      if (current._value is R) {
        return pure(current._value);
      }

      current = current._value;
    }

    if (current is! R) {
      throw TypeError();
    }

    return pure(current);
  }

  /// Extracts the value inside the `Just` container.
  ///
  /// Example:
  /// ```dart
  /// final just = Just(42);
  /// print(just.extract()); // 42
  /// ```
  @override
  T extract() => _value;

  /// Compares this instance to an another instance to determine whether they are equal.
  ///
  /// Example:
  /// ```dart
  /// final just1 = Just(42);
  /// final just2 = Just(42);
  /// final just3 = Just(10);
  /// print(just1.equals(just2)); // true
  /// print(just1.equals(just3)); // false
  /// ```
  @override
  bool equals(Just<T> other) => (identical(this, other) || this._value == other._value);

  @override
  bool operator ==(Just<T> other) => equals(other);

  @override
  int get hashCode => _value.hashCode;
}

/// A concrete class that represents the absence of a value in a `Maybe` container.
///
/// `Nothing` is used to signify the lack of a valid value. It is the opposite of `Just`, which
/// contains a value. `Nothing` is a singleton class, meaning only one instance of it exists.
/// It implements the `Maybe<Never>` type, where `Never` represents the absence of a valid type.
///
/// Example usage:
/// ```dart
/// final nothing = Nothing();
/// // This indicates the absence of a value
/// ```
final class Nothing extends Maybe<Never> {
  /// A private constructor to ensure that only one instance of `Nothing` exists.
  const Nothing._();

  /// The singleton instance of `Nothing`.
  static const _instance = Nothing._();

  /// Returns the singleton instance of `Nothing`.
  ///
  /// Example usage:
  /// ```dart
  /// final nothing = Nothing();
  /// print(nothing.isNothing); // true
  /// ```
  factory Nothing() => _instance;

  @override
  bool get isJust => false;

  @override
  bool get isNothing => true;

  /// The `map` function is a no-op for `Nothing`. Since there is no value to apply the function
  /// to, it simply returns `Nothing`.
  ///
  /// Example:
  /// ```dart
  /// final nothing = Nothing();
  /// final result = nothing.map((x) => x * 2);
  /// print(result.isNothing); // true
  /// ```
  @override
  Nothing map<R>(R Function(Never) f) => Nothing();

  /// The `ap` function is a no-op for `Nothing`. It returns `Nothing` because there is no value
  /// to apply the function to.
  ///
  /// Example:
  /// ```dart
  /// final nothing = Nothing();
  /// final result = nothing.ap(Just((x) => x * 2));
  /// print(result.isNothing); // true
  /// ```
  @override
  Maybe<R> ap<R>(Maybe<R Function(Never)> f) => this;

  /// The `flatMap` function is a no-op for `Nothing`. Since there is no value, it simply returns `Nothing`.
  ///
  /// Example:
  /// ```dart
  /// final nothing = Nothing();
  /// final result = nothing.flatMap((x) => Nothing());
  /// print(result.isNothing); // true
  /// ```
  @override
  Nothing flatMap<R>(Nothing Function(Never) f) => this;

  /// The `flatten` function is a no-op for `Nothing`, returning `Nothing` regardless of the type `R`.
  ///
  /// Example:
  /// ```dart
  /// final nothing = Nothing();
  /// final result = nothing.flatten();
  /// print(result.isNothing); // true
  /// ```
  @override
  Nothing flatten<Never>() => this;

  /// Compares the current instance of `Nothing` to another instance of `Nothing`. Since `Nothing`
  /// is a singleton, two `Nothing` instances are considered equal if they are the same instance.
  ///
  /// Example:
  /// ```dart
  /// final nothing1 = Nothing();
  /// final nothing2 = Nothing();
  /// print(nothing1 == nothing2); // true
  /// ```
  @override
  bool equals(Nothing other) => identical(this, other) || runtimeType == other.runtimeType;

  @override
  bool operator ==(Nothing other) => equals(other);

  @override
  int get hashCode => 0;
}
