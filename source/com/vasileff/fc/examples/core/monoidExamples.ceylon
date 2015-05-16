import com.vasileff.fc.core {
    Monoid,
    Foldable,
    integerPlusMonoid,
    sequentialFoldable,
    integerTimesMonoid,
    maybeFoldable,
    identityFoldable,
    stringMonoid
}

shared
void monoidExamples() {
    function sum<Container, Element>(
            Monoid<Element> monoid,
            Foldable<Container> foldable,
            Container<Element> elements)
            given Container<out E>
        =>  foldable.foldLeft
                    (elements, monoid.zero)
                    (monoid.append);

    assert(""     == sum(stringMonoid, sequentialFoldable, []));
    assert("abcd" == sum(stringMonoid, sequentialFoldable, ["a","b","c","d"]));

    assert(0  == sum(integerPlusMonoid, sequentialFoldable, []));
    assert(10 == sum(integerPlusMonoid, sequentialFoldable, 1..4));

    assert(1  == sum(integerTimesMonoid, sequentialFoldable, []));
    assert(24 == sum(integerTimesMonoid, sequentialFoldable, 1..4));

    assert(0 == sum(integerPlusMonoid, maybeFoldable, null));
    assert(0 == sum(integerPlusMonoid, maybeFoldable, 0));
    assert(5 == sum(integerPlusMonoid, maybeFoldable, 5));

    assert(1 == sum(integerTimesMonoid, maybeFoldable, null));
    assert(0 == sum(integerTimesMonoid, maybeFoldable, 0));
    assert(5 == sum(integerTimesMonoid, maybeFoldable, 5));

    assert(0 == sum(integerPlusMonoid, identityFoldable, 0));

    //sum(integerAddMonoid, identityFoldable, null);
    // Argument must be assignable to parameter elements of sum:
    // null is not assignable to Identity<Integer>

    assert(6.0 == sum {
        object satisfies Monoid<Float> {
            zero = 0.0;
            append = uncurry(Float.plus);
        };
        foldable = sequentialFoldable;
        elements = [1.0, 2.0, 3.0];
    });

    print("done");
}
