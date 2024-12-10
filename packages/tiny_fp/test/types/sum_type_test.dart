import "package:test/test.dart";
import "package:tiny_fp/src/types/sum_type.dart";

/// TODO: Improve tests rigidity and add more edge cases.
void main() {
  group("Type: ", () {
    group("[SumType][Maybe]", () {
      group("[Just]:", () {
        test("contains a value and behaves as expected", () {
          const maybe = Just<int>(42);

          expect(maybe.isJust, isTrue);
          expect(maybe.isNothing, isFalse);
          expect(maybe.value, equals(42));
        });

        test("map applies a transformation to the value", () {
          const maybe = Just<int>(10);
          final mapped = maybe.map((value) => value * 2);

          expect(mapped.isJust, isTrue);
          expect(mapped, isA<Just<int>>());
          expect((mapped as Just).value, equals(20));
        });

        test("flatMap chains operations correctly", () {
          const maybe = Just<int>(5);
          final result =
              maybe.flatMap((value) => Just<String>("Value is $value"));

          expect(result, isA<Just<String>>());
          expect((result as Just).value, equals("Value is 5"));
        });

        test("filter returns Just when predicate is true", () {
          const maybe = Just<int>(10);
          final filtered = maybe.filter((value) => value > 5);

          expect(filtered, isA<Just<int>>());
          expect((filtered as Just).value, equals(10));
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

          // Same value, same hashCode
          expect(just1.hashCode, equals(just2.hashCode));
        });
      });

      group("[Nothing]:", () {
        test("Nothing does not contain a value and behaves as expected", () {
          const maybe = Nothing<int>();

          expect(maybe.isJust, isFalse);
          expect(maybe.isNothing, isTrue);
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
      });
    });

    group("[SumType][Either]", () {
      group("[Left]:", () {
        test("Left should return the error passed to it", () {
          final left = Left<String, int>("Error");
          expect(left.error, equals("Error"));
        });

        test("isLeft should return true for Left and false for Right", () {
          final left = Left<String, int>("Error");
          final right = Right<String, int>(42);

          expect(left.isLeft, isTrue);
          expect(right.isLeft, isFalse);
        });

        test("isRight should return false for Left and true for Right", () {
          final left = Left<String, int>("Error");
          final right = Right<String, int>(42);

          expect(left.isRight, isFalse);
          expect(right.isRight, isTrue);
        });

        // test("fromEither should return the default value for Left", () {
        //   final left = Left<String, int>("Error");
        //
        //   expect(left.fromEither(0), equals(0));
        // });

        // test("fromRight should throw StateError for Left", () {
        //   final left = Left<String, int>("Error");
        //
        //   expect(() => left.fromRight(), throwsA(isA<StateError>()));
        // });

        test("map should return Left unchanged", () {
          final left = Left<String, int>("Error");

          final mappedLeft = left.map((value) => value * 2);

          expect(mappedLeft, isA<Left<String, int>>());
          // expect(mappedLeft.fromLeft(), equals("Error"));
        });

        test("flatMap should return Left unchanged", () {
          final left = Left<String, int>("Error");

          final flatMappedLeft =
              left.flatMap((value) => Right<String, int>(value * 2));

          expect(flatMappedLeft, isA<Left<String, int>>());
          // expect(flatMappedLeft.fromLeft(), equals("Error"));
        });

        test("fold should execute onLeft for Left", () {
          final left = Left<String, int>("Error");

          final leftResult = left.fold(
            onLeft: (error) => "Left: $error",
            onRight: (value) => "Right: $value",
          );
          expect(leftResult, equals("Left: Error"));
        });
      });

      group("[Right]:", () {
        test("Right should return the value passed to it", () {
          final right = Right<String, int>(42);
          expect(right.value, equals(42));
        });

        test("isRight should return true for Right and false for Left", () {
          final right = Right<String, int>(42);
          final left = Left<String, int>("Error");

          expect(right.isRight, isTrue);
          expect(left.isRight, isFalse);
        });

        test("isLeft should return false for Right and true for Left", () {
          final right = Right<String, int>(42);
          final left = Left<String, int>("Error");

          expect(right.isLeft, isFalse);
          expect(left.isLeft, isTrue);
        });

        // test("fromEither should return the value from Right", () {
        //   final right = Right<String, int>(42);
        //
        //   expect(right.fromEither(0), equals(42));
        // });

        // test("fromRight should return the value from Right", () {
        //   final right = Right<String, int>(42);
        //
        //   expect(right.fromRight(), equals(42));
        // });

        test("map should transform the value inside Right", () {
          final right = Right<String, int>(10);

          final mappedRight = right.map((value) => value * 2);

          expect(mappedRight, isA<Right<String, int>>());
          // expect(mappedRight.fromRight(), equals(20));
        });

        test("flatMap should chain operations on Right", () {
          final right = Right<String, int>(10);

          final flatMappedRight =
              right.flatMap((value) => Right<String, int>(value * 2));

          expect(flatMappedRight, isA<Right<String, int>>());
          // expect(flatMappedRight.fromRight(), equals(20));
        });

        test("fold should execute onRight for Right", () {
          final right = Right<String, int>(10);

          final rightResult = right.fold(
            onLeft: (error) => "Left: $error",
            onRight: (value) => "Right: $value",
          );

          expect(rightResult, equals("Right: 10"));
        });
      });
    });
  });
}
