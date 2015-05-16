shared
object integerPlusMonoid
        satisfies Monoid<Integer> &
                  Equal<Integer> {

    shared actual
    Integer zero = 0;

    shared actual
    Integer append(Integer x, Integer y) => x + y;

    shared actual
    Boolean equal(Integer x, Integer y) => x == y;
}

shared
object integerTimesMonoid
        satisfies Monoid<Integer> &
                  Equal<Integer> {
    shared actual
    Integer zero = 1;

    shared actual
    Integer append(Integer x, Integer y) => x * y;

    shared actual
    Boolean equal(Integer x, Integer y) => x == y;
}
