shared
interface Foldable<Container> given Container<out E> {
    shared formal
    B foldLeft<A, B>
            (Container<A> source,
             B initial)
            (B(B, A) accumulating);
}
