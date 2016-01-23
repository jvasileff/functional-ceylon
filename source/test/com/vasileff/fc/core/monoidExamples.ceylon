import ceylon.test {
    test,
    assertEquals
}

import com.vasileff.fc.core {
    Monoid,
    Foldable,
    integerPlusMonoid,
    integerTimesMonoid,
    stringMonoid,
    sequentialTypeClass,
    maybeTypeClass,
    identityTypeClass,
    SequentialMonoid
}

shared test
void monoidExamples() {
    function sum<Container, Element>(
            Monoid<Element> monoid,
            Foldable<Container> foldable,
            Container<Element> elements)
            given Container<out E>
        =>  foldable.fold(monoid, elements);

    assertEquals(sum(stringMonoid, sequentialTypeClass, []), "");
    assertEquals(sum(stringMonoid, sequentialTypeClass, ["a","b","c","d"]), "abcd");

    assertEquals(sum(integerPlusMonoid, sequentialTypeClass, []), 0);
    assertEquals(sum(integerPlusMonoid, sequentialTypeClass, 1..4), 10);

    assertEquals(sum(integerTimesMonoid, sequentialTypeClass, []), 1);
    assertEquals(sum(integerTimesMonoid, sequentialTypeClass, 1..4), 24);

    assertEquals(sum(integerPlusMonoid, maybeTypeClass, null), 0);
    assertEquals(sum(integerPlusMonoid, maybeTypeClass, 0), 0);
    assertEquals(sum(integerPlusMonoid, maybeTypeClass, 5), 5);

    assertEquals(sum(integerTimesMonoid, maybeTypeClass, null), 1);
    assertEquals(sum(integerTimesMonoid, maybeTypeClass, 0), 0);
    assertEquals(sum(integerTimesMonoid, maybeTypeClass, 5), 5);

    assertEquals(sum(integerPlusMonoid, identityTypeClass, 0), 0);

    // Not allowed, good: null is not assignable to Identity<Integer> (Integer)
    //sum(integerPlusMonoid, identityTypeClass, null);

    assertEquals(sum {
        object satisfies Monoid<Float> {
            zero = 0.0;
            append = plus<Float>;
        };
        foldable = sequentialTypeClass;
        elements = [1.0, 2.0, 3.0];
    }, 6.0);
}

shared test
void intercalate() {
    assertEquals(sequentialTypeClass.intercalate(
            SequentialMonoid<Integer>(),
            [[1], [2], [3]], [5, 6]),
            [1, 5, 6, 2, 5, 6, 3]);

    assertEquals(sequentialTypeClass.intercalate(
            integerPlusMonoid,
            [1, 2, 3], 5), 16);

    assertEquals(sequentialTypeClass.intercalate(
            integerTimesMonoid,
            [1, 2, 3], 5), 150);

    assertEquals(identityTypeClass.intercalate(
            integerPlusMonoid, 5, 10), 5);

    assertEquals(maybeTypeClass.intercalate(
            integerPlusMonoid, 5, 10), 5);

    assertEquals(maybeTypeClass.intercalate<Integer>(
            integerPlusMonoid, null, 10), 0);

    assertEquals(maybeTypeClass.intercalate<Integer>(
            integerTimesMonoid, null, 10), 1);

    assertEquals(sequentialTypeClass.intercalate(
            stringMonoid,
            ["Say", "more,", "more", "clearly"], " "),
            "Say more, more clearly");

    // with wrapper

    assertEquals(sequentialTypeClass.wrap<[Integer*]>
            ([[1], [2], [3]])
                .map(([Integer*] xs)
                    => sequentialTypeClass.map(xs, 2.times))
                .intercalate(
                    SequentialMonoid<Integer>(), [10, 11]),
            [2, 10, 11, 4, 10, 11, 6]);

    // union types

    assertEquals(sequentialTypeClass.intercalate(
            SequentialMonoid<Integer|String>(),
            [[1], [2], [3]], ["<-", "->"]),
            [1, "<-", "->", 2, "<-", "->", 3]);

    assertEquals(sequentialTypeClass.wrap<[Integer*]>
            ([[1], [2], [3]])
                .map(([Integer*] xs)
                    => sequentialTypeClass.map(xs, 2.times))
                .intercalate(
                    SequentialMonoid<Integer|String>(), ["-"]),
            [2, "-", 4, "-", 6]);
}
