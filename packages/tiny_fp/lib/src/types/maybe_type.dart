sealed class Maybe<T> {
  const Maybe();

  /// Pattern matching on `Maybe` type
  ///
  /// Note: Usage of this discouraged, `switch` based pattern matching is recommended.
  @Deprecated(
    "This function is deprecated."
    "\n"
    "Only use in situations where `switch` based pattern matching is not feasible or supported.",
  )
  R match<R>({
    required R Function() nothing,
    required R Function(T value) just,
  });

  /// Check if the `Maybe` contains a value
  bool get isJust => this is Just<T>;

  /// Check if the `Maybe` is `Nothing`
  bool get isNothing => this is Nothing<T>;

  /// Extracts the value from [Just] but throws a [StateError] for [Nothing]
  T fromJust() => switch (this) {
        Nothing() => throw StateError("Expected Just, found Nothing"),
        Just(:final value) => value,
      };

  /// Extracts the value form [Just] or returns [defaultValue] for [Nothing]
  T fromMaybe(T defaultValue) => switch (this) {
        Nothing() => defaultValue,
        Just(:final value) => value,
      };
}

final class Nothing<T> extends Maybe<T> {
  const Nothing();

  static const empty = Nothing<void>();

  @Deprecated(
    "This function is deprecated."
    "\n"
    "Only use in situations where `switch` based pattern matching is not feasible or supported.",
  )
  @override
  R match<R>({
    required R Function() nothing,
    required R Function(T value) just,
  }) =>
      nothing();

  @override
  bool operator ==(Object other) => other is Nothing<T>;

  @override
  int get hashCode => 0;

  @override
  String toString() => "Nothing";
}

final class Just<T> extends Maybe<T> {
  const Just(this.value);

  final T value;

  @Deprecated(
    "This function is deprecated."
    "\n"
    "Only use in situations where `switch` based pattern matching is not feasible or supported.",
  )
  @override
  R match<R>({
    required R Function() nothing,
    required R Function(T value) just,
  }) =>
      just(value);

  @override
  bool operator ==(Object other) => other is Just<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "Just($value)";
}

extension MaybeExtension<T> on Maybe<T> {
  /// Maps a function over the value, returning a new `Maybe`
  Maybe<R> map<R>(R Function(T value) transform) => switch (this) {
        Just(:final value) => Just<R>(transform(value)),
        Nothing() => Nothing<R>(),
      };

  /// FlatMaps a function that returns another `Maybe`
  Maybe<R> flatMap<R>(Maybe<R> Function(T value) transform) => switch (this) {
        Just(:final value) => transform(value),
        Nothing() => Nothing<R>(),
      };

  /// Filters the value based on a predicate
  Maybe<T> filter(bool Function(T value) predicate) => switch (this) {
        Just(:final value) when predicate(value) => this,
        _ => Nothing<T>(),
      };
}
