shared
object stringMonoid satisfies Monoid<String> {
    shared actual
    String zero = "";

    shared actual
    String append(String x, String y) => x + y;
}
