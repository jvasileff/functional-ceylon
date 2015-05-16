shared
interface Foldable<F> given F<out E> {
    shared formal
    Result foldLeft<Result, Element>
            (F<Element> source,
             Result initial)
            (Result(Result, Element) accumulating);
}
