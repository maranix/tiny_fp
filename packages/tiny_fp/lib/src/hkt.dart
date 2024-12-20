part "identity.dart";
part "eq.dart";
part "functor.dart";
part "applicative.dart";
part "monad.dart";

/// Marker interface for types that implement Higher-Kinded Types (HKT).
///
/// This interface ensures that only HKT-compatible types can implement abstractions.
abstract interface class  HKTMarker {}

/// Base type for High-Kinded Types (HKT)
///
/// This abstraction allows us to represent types that take other types as parameters
/// in a generic and reusable manner, enabling the implementation of advanced type
/// constructs like `Functor`, `Applicative`, and `Monad`.
///
/// - [C] represents the constructor type (e.g., `Box`, `Maybe`).
/// - [T] represents the contained or inner type.
///
/// All higher-kinded abstractions (`Functor`, `Applicative`, `Monad`, etc.) will
/// extend this base class, ensuring consistent behavior across implementations.
///
/// Example:
/// ```dart
/// final class Box<T> extends HKT<Box, T> { ... }
/// final class Maybe<T> extends HKT<Maybe, T> { ... }
/// ```
abstract class HKT<C, T> implements HKTMarker {
  /// Base constructor for HKT
  ///
  /// This ensures that HKT is not directly instantiated but serves as a base
  /// for other high-kinded types.

  const HKT();
}
