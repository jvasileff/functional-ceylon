import com.vasileff.ceylon.xmath.whole {
    Whole,
    wholeZero=zero,
    wholeOne=one
}

shared
object wholePlusMonoid
        satisfies Monoid<Whole>
            & Equal<Whole>
            & Compare<Whole> {

    shared actual
    Whole zero = wholeZero;

    shared actual
    Whole append(Whole x, Whole y) => x + y;

    shared actual
    Boolean equal(Whole x, Whole y) => x == y;

    shared actual
    Comparison compare(Whole x, Whole y) => x <=> y;
}

shared
object wholeTimesMonoid
        satisfies Monoid<Whole>
            & Equal<Whole>
            & Compare<Whole> {

    shared actual
    Whole zero = wholeOne;

    shared actual
    Whole append(Whole x, Whole y) => x * y;

    shared actual
    Boolean equal(Whole x, Whole y) => x == y;

    shared actual
    Comparison compare(Whole x, Whole y) => x <=> y;
}
