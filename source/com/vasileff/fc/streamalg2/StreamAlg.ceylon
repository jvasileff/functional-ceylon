"Intermediate Combinators"
shared
interface StreamAlg<C> given C<E> {
    shared formal
    C<Element> source<Element>(
            {Element*} array);

    shared formal
    C<Result> map<Element, Result>(
            Result(Element) mapper,
            C<Element> stream);

    shared formal
    C<Result> flatMap<Element, Result>(
            C<Result>(Element) mapper,
            C<Element> stream);

    shared formal
    C<Element> filter<Element>(
            Boolean(Element) predicate,
            C<Element> stream);
}
