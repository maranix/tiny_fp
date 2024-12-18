import "package:test/test.dart";
import "package:tiny_fp/src/builtins/box.dart";

class Person {
  final String name;

  Person(this.name);
}

void main() {
  group("[Box]", () {
    group("[Identity]: ", () {
      test("extract should return the value inside the Box", () {
        final box = Box<int>(42);
        expect(box.extract(), equals(42));

        final stringBox = Box<String>("Hello");
        expect(stringBox.extract(), equals("Hello"));
      });

      test(
          "Identity law: extract should return the same value that was put in the Box",
          () {
        final box = Box<int>(42);
        final result = box.extract();
        expect(result, equals(42));
      });
    });

    group("[Eq]: ", () {
      test("equals should return true for two Boxes with the same value", () {
        final box1 = Box<int>(42);
        final box2 = Box<int>(42);

        expect(box1.equals(box2), isTrue);
      });

      test("equals should return false for two Boxes with different values",
          () {
        final box1 = Box<int>(42);
        final box2 = Box<int>(43);

        expect(box1.equals(box2), isFalse);
      });

      test("equals should be reflexive (x.equals(x) is true)", () {
        final box = Box<int>(42);
        expect(box.equals(box), isTrue);
      });

      test(
          "equals should be symmetric (x.equals(y) is the same as y.equals(x))",
          () {
        final box1 = Box<int>(42);
        final box2 = Box<int>(42);

        expect(box1.equals(box2), isTrue);
        expect(box2.equals(box1), isTrue);
      });

      test(
          "equals should be transitive (if x.equals(y) and y.equals(z), then x.equals(z))",
          () {
        final box1 = Box<int>(42);
        final box2 = Box<int>(42);
        final box3 = Box<int>(42);

        expect(box1.equals(box2), isTrue);
        expect(box2.equals(box3), isTrue);
        expect(box1.equals(box3), isTrue);
      });
    });

    group("[Functor]: ", () {
      test("should transform int to string", () {
        final box = Box(42);

        final result = box.map<String>((x) => "Value: $x");
        expect(result.extract(), equals("Value: 42"));
      });

      test("should transform string to uppercase", () {
        final box = Box("hello");

        final result = box.map<String>((x) => x.toUpperCase());
        expect(result.extract(), equals("HELLO"));
      });

      test("should work with complex objects", () {
        final box = Box(Person("Alice"));

        final result = box.map<String>((person) => person.name.toUpperCase());
        expect(result.extract(), equals("ALICE"));
      });

      test("should preserve immutability of the Box value", () {
        final box = Box(42);
        final originalValue = box.extract();
        final result = box.map<int>((x) => x * 2);

        expect(result.extract(), equals(84));
        expect(box.extract(), equals(originalValue));
      });

      test("should handle complex nested types (Box<Box<T>>)", () {
        final box = Box(Box(42));

        final result = box
            .map<Box<String>>((nestedBox) => Box(nestedBox.value.toString()));
        expect(result.extract().value, equals("42"));
      });

      test("should handle transformations with null values", () {
        final box = Box<int?>(null);

        final result = box.map<String>((x) => x?.toString() ?? "null");
        expect(result.extract(), equals("null"));
      });

      test("should work with boolean values", () {
        final box = Box(true);

        final result = box.map<String>((x) => x ? "True" : "False");
        expect(result.extract(), equals("True"));
      });

      test("should work with other numeric types", () {
        final box = Box(3.14);

        final result = box.map<int>((x) => (x * 10).toInt());
        expect(result.extract(), equals(31));
      });

      test("should handle empty list transformation inside Box", () {
        final box = Box<List<int>>([]);

        final result = box.map<List<String>>(
            (list) => list.map((e) => e.toString()).toList());
        expect(result.extract(), equals([]));
      });

      test("should handle single-item list transformation inside Box", () {
        final box = Box<List<int>>([42]);

        final result = box
            .map<List<String>>((list) => list.map((e) => "Value: $e").toList());
        expect(result.extract(), equals(["Value: 42"]));
      });

      test("should handle transformations that return the same type", () {
        final box = Box(42);

        final result = box.map<int>((x) => x);
        expect(result.extract(), equals(42));
      });

      test("should handle transformations to dynamic type", () {
        final box = Box(42);

        final result = box.map<dynamic>((x) => x.toString()); // Box<dynamic>
        expect(result.extract(), equals("42"));
      });

      test("should handle large numeric values", () {
        final box = Box(1e18); // Box<double> (large number)

        final result = box.map<int>((x) => x.toInt());
        expect(result.extract(), equals(1000000000000000000));
      });

      test("should work with null-safe transformations", () {
        final box = Box<int?>(null);

        final result = box.map<String>((x) => x?.toString() ?? "null");
        expect(result.extract(), equals("null"));
      });

      test("should handle non-trivial transformations", () {
        final box = Box(3);

        final result = box.map<String>((x) => "${x * 2} is double");
        expect(result.extract(), equals("6 is double"));
      });

      test("should allow mapping a complex nested structure (List<Box>)", () {
        final box1 = Box(42);
        final box2 = Box(100);
        final boxes = Box([box1, box2]);

        final result = boxes.map<List<String>>(
            (list) => list.map((e) => "Value: ${e.value}").toList());
        expect(result.extract(), equals(["Value: 42", "Value: 100"]));
      });

      test("should handle transformations on larger objects (list of lists)",
          () {
        final box = Box([
          [1, 2, 3],
          [4, 5, 6],
        ]);

        final result = box.map<List<List<String>>>(
          (lists) => lists
              .map((list) => list.map((e) => "Value: $e").toList())
              .toList(),
        );

        expect(
            result.extract(),
            equals([
              ["Value: 1", "Value: 2", "Value: 3"],
              ["Value: 4", "Value: 5", "Value: 6"]
            ]));
      });
    });

    group("[Applicative]: ", () {
      test("ap should correctly apply a function to a value", () {
        final boxFn = Box<int Function(int)>((x) => x + 5);
        final boxVal = Box<int>(10);

        final result = boxFn.ap(boxFn, boxVal);

        expect(result, isA<Box<int>>());
        expect(result.extract(), equals(15));
      });

      test("ap should work with different types", () {
        final boxFn = Box<String Function(int)>((x) => "Value: $x");
        final boxVal = Box<int>(42);

        final result = boxFn.ap(boxFn, boxVal);

        expect(result, isA<Box<String>>());
        expect(result.extract(), equals("Value: 42"));
      });

      test("ap should work with nested containers", () {
        final boxFn = Box<Box<int> Function(int)>((x) => Box(x * 2));
        final boxVal = Box<int>(5);

        final result = boxFn.ap(boxFn, boxVal);

        expect(result, isA<Box<Box<int>>>());
        expect(result.extract().value, equals(10));
      });

      test("ap behaves correctly regardless of the order of operations", () {
        final boxFn = Box<int Function(int)>((x) => x + 5);
        final boxVal = Box<int>(10);

        final result1 = boxFn.ap(boxFn, boxVal);
        final result2 = boxVal.ap(boxFn, boxVal);

        expect(result1, isA<Box<int>>());
        expect(result1.runtimeType, equals(result2.runtimeType));
        expect(result1.extract(), equals(result2.extract()));
        expect(result1.toString(), equals(result2.toString()));
      });

      test("ap should handle function returning null safely", () {
        final boxFn = Box<int? Function(int)>((x) => null);
        final boxVal = Box<int>(5);

        final result = boxFn.ap(boxFn, boxVal);

        expect(result, isA<Box<int?>>());
        expect(result.extract(), isNull);
      });

      test("ap should throw TypeError when incompatible HKTs are passed", () {
        final boxFn = Box<int Function(dynamic)>((x) => x * 2);
        final boxVal = Box("str");

        expect(
          () => boxFn.ap<String, int>(boxFn, boxVal),
          throwsA(isA<TypeError>()),
        );
      });

      test("ap with large data structures", () {
        final boxFn = Box<int Function(List<int>)>(
            (list) => list.reduce((a, b) => a + b));
        final boxVal = Box<List<int>>([1, 2, 3, 4, 5]);

        final result = boxFn.ap(boxFn, boxVal);

        expect(result, isA<Box<int>>());
        expect(result.extract(), equals(15)); // Sum of the list
      });

      test("ap should work when Box contains higher-order functions", () {
        final boxFn = Box<int Function(int Function(int))>(
          (f) => f(10),
        );
        final boxVal = Box<int Function(int)>((x) => x * 3);

        final result = boxFn.ap(boxFn, boxVal);

        expect(result, isA<Box<int>>());
        expect(result.extract(), equals(30));
      });

      test("ap should work when Box contains a constant function", () {
        final boxFn = Box<int Function(int)>((_) => 42); // Constant function
        final boxVal = Box<int>(99);

        final result = boxFn.ap(boxFn, boxVal);

        expect(result, isA<Box<int>>());
        expect(result.extract(), equals(42));
      });

      test("ap should work when Box contains a function that throws", () {
        final boxFn = Box<int Function(int)>((_) {
          throw Exception("Test exception");
        });
        final boxVal = Box<int>(5);

        expect(
          () => boxFn.ap(boxFn, boxVal),
          throwsA(isA<Exception>().having(
              (e) => e.toString(), "message", contains("Test exception"))),
        );
      });

      test("ap should handle deeply nested Box types", () {
        final boxFn = Box<Box<String> Function(Box<int>)>(
          (x) => Box("Nested Value: ${x.value}"),
        );

        final boxVal = Box<Box<int>>(Box(10));
        final result = boxFn.ap(boxFn, boxVal);

        expect(result, isA<Box<Box<String>>>());
        expect(result.extract().value, equals("Nested Value: 10"));
      });

      test("pure should work with null value", () {
        final result = Box<int>(42).pure(null);

        expect(result, isA<Box<Null>>());
        expect(result.extract(), isNull);
      });

      test("pure should work with complex types", () {
        final result = Box<int>(42).pure<List<int>>([1, 2, 3]);

        expect(result, isA<Box<List<int>>>());
        expect(result.extract(), equals([1, 2, 3]));
      });

      test("ap should work when Box contains a curried function", () {
        final boxFn = Box<int Function(int)>((x) => x * 2);
        final intermediate = boxFn.ap(boxFn, Box<int>(5));

        final boxFn2 = Box<int Function(int)>((x) => x + 3);
        final result = boxFn2.ap(boxFn2, intermediate);

        expect(result, isA<Box<int>>());
        expect(result.extract(), equals(13));
      });

      test("pure followed by ap should behave as identity", () {
        final boxVal = Box<int>(42);
        final result = Box<int>(42)
            .pure<int Function(int)>((x) => x)
            .ap<int, int>(Box((x) => x), boxVal);

        expect(result, isA<Box<int>>());
        expect(result.extract(), equals(42));
      });

      test("pure should wrap a value into a new Box", () {
        final box = Box<int>(42).pure(100);

        expect(box, isA<Box<int>>());
        expect(box.extract(), equals(100));
      });

      test("pure and ap should behave consistently", () {
        final boxFn = Box<int Function(int)>((x) => x * 3);
        final value = 10;

        final result1 = boxFn.ap(boxFn, Box<int>(value));
        final result2 = Box<int>(value).map<int>((x) => x * 3);

        expect(result1, isA<Box<int>>());
        expect(result2, isA<Box<int>>());
        expect(result1.extract(), equals(result2.extract()));
      });
    });

    group("[Monad]: ", () {
      test("Left identity: pure(a).flatMap(f) == f(a)", () {
        final box = Box(5);
        final result = box.pure(5).flatMap((x) => Box(x * 2));

        expect(result.equals(Box(10)), isTrue);
      });

      test("Right identity: m.flatMap(pure) == m", () {
        final box = Box(10);
        final result = box.flatMap((x) => Box(x));

        expect(result.equals(box), isTrue);
      });

      test(
          "Associativity: m.flatMap(f).flatMap(g) == m.flatMap((x) => f(x).flatMap(g))",
          () {
        final box = Box(3);

        final result1 =
            box.flatMap((x) => Box(x * 2)).flatMap((x) => Box(x + 1));
        final result2 =
            box.flatMap((x) => Box(x * 2).flatMap((x) => Box(x + 1)));

        expect(result1.equals(result2), isTrue);
      });

      test("flatMap should transform the value correctly", () {
        final box = Box(5);

        final result = box.flatMap((x) => Box(x * 2));

        expect(result, isA<Box<int>>());
        expect(result.extract(), equals(10));
      });

      test("flatMap should handle nested Box transformations", () {
        final box = Box("Hello");

        final result = box.flatMap((x) => Box("$x World"));

        expect(result, isA<Box<String>>());
        expect(result.extract(), equals("Hello World"));
      });

      test("flatMap should flatten one level of nesting", () {
        final box = Box("Hello");

        final result = box.flatMap(
          (x) => Box(Box("$x World")),
        );

        expect(result, isA<Box<Box<String>>>());
        expect(result.extract().value, equals("Hello World"));
      });

      test("flatMap should not flatten deeply nested structures", () {
        final box = Box(Box(Box(Box(Box(42)))));

        final result = box.flatMap((x) => x);

        expect(result, isA<Box<Box<Box<Box<int>>>>>());
        expect(result.extract().value.value.value, equals(42));
      });

      test("flatMap should handle an empty or null-like Box value", () {
        final box = Box<Box<int>?>(null);

        final result = box.flatMap((x) => x ?? Box(-1));
        expect(result, isA<Box<int>>());
        expect(result.extract(), equals(-1));
      });

      test("flatMap should not perform additional flattening if unnecessary",
          () {
        final box = Box(42);

        final result = box.flatMap((x) => Box(x * 2));
        expect(result, isA<Box<int>>());
        expect(result.extract(), equals(84));
      });

      test("flatMap should handle deeply nested transformations", () {
        final box = Box(Box(Box(Box(2))));

        final result = box.flatMap(
          (x) => x.flatMap(
            (y) => Box(y.value.value * 3),
          ),
        );

        expect(result, isA<Box<int>>());
        expect(result.extract(), equals(6));
      });

      test("flatMap should handle identity transformation", () {
        final box = Box(10);

        final result = box.flatMap((x) => Box(x));

        expect(result, isA<Box<int>>());
        expect(result.extract(), equals(10));
      });
    });
  });
}
