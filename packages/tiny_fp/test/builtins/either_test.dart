import "package:test/test.dart";
import "package:tiny_fp/src/builtins/either.dart";

void main() {
  group("Either", () {
    group("Left", () {
      test("should identify as Left", () {
        final left = Either.left(42);

        expect(left.isLeft, isTrue);
        expect(left.isRight, isFalse);
      });

      test("fromLeft should return the value for Left", () {
        final left = Either.left(42);

        expect(left.fromLeft(0), equals(42));
      });

      test("fromRight should return the default value for Left", () {
        final left = Either.left(42);
        expect(left.fromRight("default"), equals("default"));
      });

      test("map should not apply the function for Left", () {
        final left = Left<int, String>(42);
        final result = left.map((value) => value.toUpperCase());

        expect(result, equals(left));
      });

      test("ap should not apply the function for Left", () {
        final left = Left<int, String>(42);
        final result = left
            .ap(Right<int, String Function(String)>((x) => x.toUpperCase()));
        expect(result, equals(left));
      });

      // test(
      //     "flatMap should not apply the function for Left instead throws TypeError",
      //     () {
      //   final left = Left<int, String>(42);
      //   final result = left.flatMap((value) => Right<int, int>(value.length));
      //
      //   expect(result, equals(left));
      // });

      // test("flatten should return itself for Left", () {
      //   final left = Left<int, Either<int, String>>(42);
      //   final result = left.flatten();
      //   expect(result, equals(left));
      // });

      test("equals should correctly compare two Lefts", () {
        final left1 = Left<int, String>(42);
        final left2 = Left<int, String>(42);
        final left3 = Left<int, String>(0);
        expect(left1.equals(left2), isTrue);
        expect(left1.equals(left3), isFalse);
      });
    });

    group("Right", () {
      test("should identify as Right", () {
        final right = Right<int, String>("value");
        expect(right.isRight, isTrue);
        expect(right.isLeft, isFalse);
      });

      test("fromRight should return the value for Right", () {
        final right = Right<int, String>("value");
        expect(right.fromRight("default"), equals("value"));
      });

      test("fromLeft should return the default value for Right", () {
        final right = Right<int, String>("value");
        expect(right.fromLeft(0), equals(0));
      });

      test("map should apply the function for Right", () {
        final right = Right<int, String>("value");
        final result = right.map((value) => value.toUpperCase());
        expect(result, equals(Right<int, String>("VALUE")));
      });

      test("ap should apply the function for Right", () {
        final right = Right<int, int>(5);
        final result = right.ap(Right<int, int Function(int)>((x) => x * 2));
        expect(result, equals(Right<int, int>(10)));
      });

      test("flatMap should apply the function for Right", () {
        final right = Right<int, String>("value");
        final result = right.flatMap((value) => Right<int, int>(value.length));
        expect(result, equals(Right<int, int>(5)));
      });

      test("flatten should collapse nested Right values", () {
        final nested =
            Right<int, Either<int, String>>(Right<int, String>("value"));
        final result = nested.flatten<String>();
        expect(result, equals(Right<int, String>("value")));
      });

      test("flatten should throw TypeError for invalid nested values", () {
        final nested = Right<int, Either<int, int>>(Left<int, int>(42));
        expect(() => nested.flatten<int>(), throwsA(isA<TypeError>()));
      });

      test("equals should correctly compare two Rights", () {
        final right1 = Right<int, String>("value");
        final right2 = Right<int, String>("value");
        final right3 = Right<int, String>("other");
        expect(right1.equals(right2), isTrue);
        expect(right1.equals(right3), isFalse);
      });
    });

    group("Pattern Matching", () {
      test("when should call the appropriate function for Left", () {
        final left = Left<int, String>(42);
        final result = left.when(
          left: (value) => "Error: $value",
          right: (value) => "Success: $value",
        );
        expect(result, equals("Error: 42"));
      });

      test("when should call the appropriate function for Right", () {
        final right = Right<int, String>("value");
        final result = right.when(
          left: (value) => "Error: $value",
          right: (value) => "Success: $value",
        );
        expect(result, equals("Success: value"));
      });
    });

    group("Combining", () {
      test("map and flatMap chaining for Right", () {
        final right = Right<int, int>(5);
        final result = right
            .map((value) => value * 2)
            .flatMap((value) => Right<int, int>(value + 3));
        expect(result, equals(Right<int, int>(13)));
      });

      test("map and flatMap chaining for Left", () {
        final left = Left<int, int>(42);
        final result = left
            .map((value) => value * 2)
            .flatMap((value) => Right<int, int>(value + 3));
        expect(result, equals(left));
      });

      test("ap chaining for Right", () {
        final right = Right<int, int>(3);
        final result = right
            .ap(Right<int, int Function(int)>((x) => x * 2))
            .ap(Right<int, int Function(int)>((x) => x + 1));
        expect(result, equals(Right<int, int>(7)));
      });
    });
  });
}
