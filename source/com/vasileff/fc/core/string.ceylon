shared
object integerPlusMonoid satisfies Monoid<Integer> {
    shared actual
    Integer zero = 0;

    shared actual
    Integer append(Integer x, Integer y) => x + y;
}

shared
object integerTimesMonoid satisfies Monoid<Integer> {
    shared actual
    Integer zero = 1;

    shared actual
    Integer append(Integer x, Integer y) => x * y;
}
