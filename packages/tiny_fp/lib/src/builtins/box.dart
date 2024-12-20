import "package:tiny_fp/src/hkt.dart";

/// A container type that wraps a single value of type [T].
///
/// The `Box` class is a concrete implementation of a higher-kind type (HKT) that
/// allows you to perform functional operations like mapping, applying functions,
/// and chaining operations on values inside the container. It implements several
/// abstractions, including [Functor], [Applicative], [Monad], [Eq], and [Identity],
/// providing an intuitive way to handle computations that may or may not produce a result.
///
/// This class is designed to be used in functional programming paradigms, where
/// the value inside the `Box` is not directly accessible but can be transformed
/// and interacted with through the provided methods.
final class Box<T> extends HKT<Box, T>
    implements Functor<Box, T>, Applicative<Box, T>, Monad<Box, T>, Eq<Box, T>, Identity<T> {
  /// Creates a new [Box] instance wrapping the given [value].
  const Box(T value) : _value = value;

  final T _value;

  /// Maps a function [f] over the value inside the box and returns a new [Box] with the result.
  ///
  /// - [f]: A function that takes the value of type [T] and returns a new value of type [R].
  ///
  /// Example:
  /// ```dart
  /// final box = Box(42);
  /// final mappedBox = box.map((x) => x * 2);
  /// final value = mappedBox.extract(); // 84
  /// ```
  @override
  Box<R> map<R>(R Function(T) f) => Box(f(_value));

  /// Wraps a raw value of type [R] into a [Box].
  ///
  /// This method takes a raw value and wraps it inside [Box].
  ///
  /// - [value]: The raw value of type [R] to be wrapped in the container.
  /// - Returns: A new [Box] that holds the value.
  ///
  /// Example:
  /// ```dart
  /// final box = Box(10);
  /// final result = box.pure(42);
  /// assert(result == Box(42));  // The value is wrapped inside `Just()`.
  /// ```
  @override
  Box<R> pure<R>(R value) => Box(value);

  /// Applies a function inside another [Box] to the value inside the current [Box].
  ///
  /// - [boxFunc]: A [Box] containing a function that takes a value of type [T]
  /// and returns a value of type [R].
  ///
  /// Example:
  /// ```dart
  /// final boxFn = Box<int Function(int)>((x) => x + 5);
  /// final boxVal = Box<int>(10);
  /// final result = boxFn.ap(boxVal); // Box(15)
  /// ```
  @override
  Box<R> ap<R>(covariant Box<R Function(T)> boxFunc) => pure(boxFunc._value(_value));

  /// Flattens nested boxes into a single box.
  ///
  /// This method will flatten a nested structure of boxes (e.g., Box(Box(T))) into
  /// a single level of nesting.
  ///
  /// Example:
  /// ```dart
  /// final box = Box(Box(42));
  /// final flattenedBox = box.flatten(); // Box(42)
  /// ```
  @override
  Box<R> flatten<R>() {
    dynamic current = this._value;

    while (current is Box) {
      if (current._value is R) {
        return pure(current._value);
      }

      current = current._value;
    }

    // Ensure the final value matches the expected type
    if (current is! R) {
      throw TypeError();
    }

    return pure(current);
  }

  /// Performs a flatMap (monadic bind) operation.
  ///
  /// This method allows chaining computations on the value inside the box. It takes a
  /// function that returns a new box and applies it to the value inside the current box.
  ///
  /// Example:
  /// ```dart
  /// final box = Box(42);
  /// final result = box.flatMap((x) => Box(x * 2));
  /// final value = result.extract(); // 84
  /// ```
  @override
  Box<R> flatMap<R>(covariant Box<R> Function(T) f) => f(_value);

  /// Extracts the value from the [Box] container.
  ///
  /// - Returns the value inside the box.
  /// - Throws a [StateError] if the box is empty (but in this case, it's always non-null).
  ///
  /// Example:
  /// ```dart
  /// final box = Box(42);
  /// final value = box.extract(); // 42
  /// ```
  @override
  T extract() => _value;

  /// Checks if the current box is equal to another box.
  ///
  /// - Returns true if the values inside the boxes are the same.
  /// - Uses `==` to compare the values inside both boxes.
  ///
  /// Example:
  /// ```dart
  /// final box1 = Box(42);
  /// final box2 = Box(42);
  /// final result = box1.equals(box2); // true
  /// ```
  @override
  bool equals(covariant Box<T> other) => identical(this, other) || _value == other.extract();

  @override
  bool operator ==(covariant Box<T> other) => equals(other);

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => "Box($_value)";
}
