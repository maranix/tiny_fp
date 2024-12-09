import "package:test/test.dart";
import "package:tiny_fp/src/types/maybe_type.dart";

void main() {
  group("Type: ", () {
    group("[Maybe][Just]: ", () {
      test("contains a value and behaves as expected", () {
        const maybe = Just<int>(42);

        expect(maybe.isJust, isTrue);
        expect(maybe.isNothing, isFalse);
        expect(maybe.fromMaybe(0), equals(42));
      });

      test("map applies a transformation to the value", () {
        const maybe = Just<int>(10);
        final mapped = maybe.map((value) => value * 2);

        expect(mapped.isJust, isTrue);
        expect(mapped, isA<Just<int>>());
        expect(mapped.fromJust(), equals(20));
      });

      test("flatMap chains operations correctly", () {
        const maybe = Just<int>(5);
        final result =
            maybe.flatMap((value) => Just<String>("Value is $value"));

        expect(result, isA<Just<String>>());
        expect(result.fromJust(), equals("Value is 5"));
      });

      test("filter returns Just when predicate is true", () {
        const maybe = Just<int>(10);
        final filtered = maybe.filter((value) => value > 5);

        expect(filtered, isA<Just<int>>());
        expect(filtered.fromJust(), equals(10));
      });

      test("filter returns Nothing when predicate is false", () {
        const maybe = Just<int>(3);
        final filtered = maybe.filter((value) => value > 5);

        expect(filtered, isA<Nothing<int>>());
      });

      test("equality for Just instances", () {
        const just1 = Just<int>(42);
        const just2 = Just<int>(42);
        const just3 = Just<int>(7);

        expect(just1, equals(just2)); // Same value
        expect(just1, isNot(equals(just3))); // Different value
      });

      test("hashCode for Just instances", () {
        const just1 = Just<int>(42);
        const just2 = Just<int>(42);

        expect(just1.hashCode,
            equals(just2.hashCode)); // Same value, same hashCode
      });

      group("Deprecated match functions", () {
        test("Just match calls the correct callback", () {
          const maybe = Just<int>(42);
          // ignore: deprecated_member_use_from_same_package
          final result = maybe.match(
            nothing: () => "Nothing",
            just: (value) => "Just $value",
          );

          expect(result, equals("Just 42"));
        });
      });
    });

    group("[Maybe][Nothing]: ", () {
      test("Nothing does not contain a value and behaves as expected", () {
        const maybe = Nothing<int>();

        expect(maybe.isJust, isFalse);
        expect(maybe.isNothing, isTrue);
        expect(maybe.fromMaybe(0), equals(0));
      });

      test("Nothing map returns Nothing", () {
        const maybe = Nothing<int>();
        final mapped = maybe.map((value) => value * 2);

        expect(mapped, isA<Nothing<int>>());
      });

      test("Nothing flatMap returns Nothing", () {
        const maybe = Nothing<int>();
        final result =
            maybe.flatMap((value) => Just<String>("Value is $value"));

        expect(result, isA<Nothing<String>>());
      });

      test("Nothing filter always returns Nothing", () {
        const maybe = Nothing<int>();
        final filtered = maybe.filter((value) => value > 5);

        expect(filtered, isA<Nothing<int>>());
      });

      group("Deprecated match function", () {
        test("Nothing match calls the correct callback", () {
          const maybe = Nothing<int>();
          // ignore: deprecated_member_use_from_same_package
          final result = maybe.match(
            nothing: () => "Nothing",
            just: (value) => "Just $value",
          );

          expect(result, equals("Nothing"));
        });
      });
    });

    group("Maybe Type General Tests", () {
      test("Maybe getOrElse works for both Just and Nothing", () {
        const just = Just<int>(42);
        const nothing = Nothing<int>();

        expect(just.fromMaybe(0), equals(42));
        expect(nothing.fromMaybe(0), equals(0));
      });
    });
  });
}
