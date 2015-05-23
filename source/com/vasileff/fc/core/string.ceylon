shared
object stringMonoid
        satisfies Monoid<String>
            & Equal<String>
            & Compare<String> {

    shared actual
    String zero = "";

    shared actual
    String append(String x, String y) => x + y;

    shared actual
    Boolean equal(String x, String y) => x == y;

    shared actual
    Comparison compare(String x, String y) => x <=> y;
}
