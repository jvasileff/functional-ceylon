shared
interface Monoid<F> {
    shared formal
    F zero;

    shared formal
    F append(F x, F y);
}
