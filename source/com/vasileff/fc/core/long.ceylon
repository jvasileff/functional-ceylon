import com.vasileff.ceylon.xmath.long {
    Long,
    longOne=one,
    longZero=zero
}

shared
object longPlusMonoid
        satisfies Monoid<Long>
            & Equal<Long>
            & Compare<Long> {

    shared actual
    Long zero = longZero;

    shared actual
    Long append(Long x, Long y) => x + y;

    shared actual
    Boolean equal(Long x, Long y) => x == y;

    shared actual
    Comparison compare(Long x, Long y) => x <=> y;
}

shared
object longTimesMonoid
        satisfies Monoid<Long>
            & Equal<Long>
            & Compare<Long> {

    shared actual
    Long zero = longOne;

    shared actual
    Long append(Long x, Long y) => x * y;

    shared actual
    Boolean equal(Long x, Long y) => x == y;

    shared actual
    Comparison compare(Long x, Long y) => x <=> y;
}
