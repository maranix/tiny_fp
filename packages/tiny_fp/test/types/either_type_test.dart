import "package:test/test.dart";
import "package:tiny_fp/src/types/either_type.dart";

void main() {
  group("Type: ", () {
    group("[Either][Left]: ", () {
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

      test("fromEither should return the default value for Left", () {
        final left = Left<String, int>("Error");

        expect(left.fromEither(0), equals(0));
      });

      test("fromRight should throw StateError for Left", () {
        final left = Left<String, int>("Error");

        expect(() => left.fromRight(), throwsA(isA<StateError>()));
      });

      test("map should return Left unchanged", () {
        final left = Left<String, int>("Error");

        final mappedLeft = left.map((value) => value * 2);

        expect(mappedLeft, isA<Left<String, int>>());
        expect(mappedLeft.fromLeft(), equals("Error"));
      });

      test("flatMap should return Left unchanged", () {
        final left = Left<String, int>("Error");

        final flatMappedLeft =
            left.flatMap((value) => Right<String, int>(value * 2));

        expect(flatMappedLeft, isA<Left<String, int>>());
        expect(flatMappedLeft.fromLeft(), equals("Error"));
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

    group("[Either][Right]: ", () {
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

      test("fromEither should return the value from Right", () {
        final right = Right<String, int>(42);

        expect(right.fromEither(0), equals(42));
      });

      test("fromRight should return the value from Right", () {
        final right = Right<String, int>(42);

        expect(right.fromRight(), equals(42));
      });

      test("map should transform the value inside Right", () {
        final right = Right<String, int>(10);

        final mappedRight = right.map((value) => value * 2);

        expect(mappedRight, isA<Right<String, int>>());
        expect(mappedRight.fromRight(), equals(20));
      });

      test("flatMap should chain operations on Right", () {
        final right = Right<String, int>(10);

        final flatMappedRight =
            right.flatMap((value) => Right<String, int>(value * 2));

        expect(flatMappedRight, isA<Right<String, int>>());
        expect(flatMappedRight.fromRight(), equals(20));
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
}
