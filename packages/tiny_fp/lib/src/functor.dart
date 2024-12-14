/// {@template functor}
///
/// Represents a data structure that supports mapping a function
/// over its wrapped value while preserving its structure.
///
/// Implementers must define & adhere to Function Laws:
///
///
/// - [map] to transform the value inside the Functor.
///
/// 1. **Identity Law**:
///
/// Applying the identity function (`(x) => x`) to the functor should return the same functor.
///
/// ```dart
/// functor.map((x) => x) == functor
/// ```
///
/// 2. **Composition Law**:
///
/// Mapping over a composition of two functions (`f` and `g`) is equivalent to applying them sequentially inside the functor.
///
/// ```dart
/// functor.map((x) => g(f(x))) == functor.map(f).map(g)
/// ```
///
/// {@endtemplate}
abstract interface class Functor<T> {
  /// {@macro functor}
  const Functor();

  /// Maps a function [f] over the wrapped value and returns a new [Functor].
  Functor<R> map<R>(R Function(T value) f);
}
