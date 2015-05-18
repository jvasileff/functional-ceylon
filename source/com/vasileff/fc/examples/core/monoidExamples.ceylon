import com.vasileff.fc.core {
    Monoid,
    Foldable,
    integerPlusMonoid,
    integerTimesMonoid,
    stringMonoid,
    sequentialTypeClass,
    maybeTypeClass,
    identityTypeClass
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

    assert(""     == sum(stringMonoid, sequentialTypeClass, []));
    assert("abcd" == sum(stringMonoid, sequentialTypeClass, ["a","b","c","d"]));

    assert(0  == sum(integerPlusMonoid, sequentialTypeClass, []));
    assert(10 == sum(integerPlusMonoid, sequentialTypeClass, 1..4));

    assert(1  == sum(integerTimesMonoid, sequentialTypeClass, []));
    assert(24 == sum(integerTimesMonoid, sequentialTypeClass, 1..4));

    assert(0 == sum(integerPlusMonoid, maybeTypeClass, null));
    assert(0 == sum(integerPlusMonoid, maybeTypeClass, 0));
    assert(5 == sum(integerPlusMonoid, maybeTypeClass, 5));

    assert(1 == sum(integerTimesMonoid, maybeTypeClass, null));
    assert(0 == sum(integerTimesMonoid, maybeTypeClass, 0));
    assert(5 == sum(integerTimesMonoid, maybeTypeClass, 5));

    assert(0 == sum(integerPlusMonoid, identityTypeClass, 0));

    //sum(integerAddMonoid, identityFoldable, null);
    // Argument must be assignable to parameter elements of sum:
    // null is not assignable to Identity<Integer>

    assert(6.0 == sum {
        object satisfies Monoid<Float> {
            zero = 0.0;
            append = uncurry(Float.plus);
        };
        foldable = sequentialTypeClass;
        elements = [1.0, 2.0, 3.0];
    });

    print("done");
}
