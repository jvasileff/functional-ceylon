shared
interface Monoid<T> {
    shared formal
    T zero;

    shared formal
    T append(T x, T y);
}
