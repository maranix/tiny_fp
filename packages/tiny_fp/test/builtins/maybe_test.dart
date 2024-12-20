import "package:test/test.dart";
import "package:tiny_fp/src/builtins/maybe.dart";

void main() {
  group("[Maybe]", () {
    group("[Identity] :", () {
      test("extract should return value for Just", () {
        final just = Just(42);
        expect(just.extract(), equals(42));
      });
    });

    group("[Eq] :", () {
      test("equals should return true for two identical Just values", () {
        final just1 = Just(42);
        final just2 = Just(42);

        expect(just1.equals(just2), isTrue);
        expect(just1 == just2, isTrue);
      });

      test("equals should return false for two different Just values", () {
        final just1 = Just(42);
        final just2 = Just(43);

        expect(just1.equals(just2), isFalse);
        expect(just1 == just2, isFalse);
      });

      test("equals should return true for two Nothing values", () {
        final nothing1 = Nothing();
        final nothing2 = Nothing();

        expect(nothing1.equals(nothing2), isTrue);
        expect(nothing1 == nothing2, isTrue);
      });
    });

    group("[Functor] :", () {
      test("map should transform the value inside Just", () {
        final just = Just(42);
        final mapped = just.map((x) => x * 2);

        expect(mapped, isA<Just<int>>());
        expect(mapped.extract(), equals(84));
      });
    });

    group("[Applicative] :", () {
      test("pure should wrap a value in Just", () {
        final just = Just(42).pure(99);
        expect(just, isA<Just<int>>());
        expect(just.extract(), equals(99));
      });

      test("ap should apply function in Just to value in another Just", () {
        final func = Just((int x) => x + 1);
        final value = Just(42);
        final result = func.ap(func, value);

        expect(result, isA<Just<int>>());
        expect(result.extract(), equals(43));
      });

      test("ap should return Nothing if the function is Nothing", () {
        final func = Nothing();
        final value = Just(42);
        final result = func.ap(func, value);

        expect(result, isA<Nothing>());
      });
    });

    group("[Monad] :", () {
      test("flatMap should apply function to value in Just", () {
        final just = Just(42);
        final result = just.flatMap((x) => Just(x * 2));

        expect(result, isA<Just<int>>());
        expect(result.extract(), equals(84));
      });

      test("flatten should reduce nested Just structures", () {
        final nested = Just(Just(Just(42)));
        final flattened = nested.flatten<int>();
        expect(flattened, isA<Just<int>>());
        expect(flattened.extract(), equals(42));
      });

      test("flatten should return Nothing when called on Nothing", () {
        final nothing = Nothing();
        final flattened = nothing.flatten();
        expect(flattened, isA<Nothing>());
      });

      test("flatten should throw TypeError for incompatible nested structure",
          () {
        final nested = Just("not a Maybe");
        expect(() => nested.flatten<int>(), throwsA(isA<TypeError>()));
      });
    });

    group("[Maybe] [Edge Cases]", () {
      test("extract should work with deeply nested Just structures", () {
        final nested = Just(Just(Just(42)));
        expect(nested.flatten<int>().extract(), equals(42));
      });

      test("map should handle nullable values correctly", () {
        final just = Just(null);
        final mapped = just.map((x) => x ?? 0);
        expect(mapped.extract(), equals(0));
      });

      test("Nothing should have a consistent hashCode", () {
        final nothing1 = Nothing();
        final nothing2 = Nothing();
        expect(nothing1.hashCode, equals(nothing2.hashCode));
      });

      test("Just should have a consistent hashCode based on value", () {
        final just1 = Just(42);
        final just2 = Just(42);
        final just3 = Just(43);

        expect(just1.hashCode, equals(just2.hashCode));
        expect(just1.equals(just2), isTrue);

        expect(just1.hashCode, isNot(equals(just3.hashCode)));
        expect(just1.equals(just3), isFalse);
      });
    });
  });
}
