shared
object stringMonoid
        satisfies Monoid<String> &
                  Equal<String> {

    shared actual
    String zero = "";

    shared actual
    String append(String x, String y) => x + y;

    shared actual
    Boolean equal(String x, String y) => x == y;
}
