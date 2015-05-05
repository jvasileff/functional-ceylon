"Intermediate Combinators"
shared
interface StreamAlg<C> {
    shared formal
    Application<C, Element> source<Element>(
            {Element*} array);

    shared formal
    Application<C, Result> map<T, Result>(
            Result(T) mapper,
            Application<C,T> stream);

    shared formal
    Application<C, Result> flatMap<Element, Result>(
            Application<C, Result>(Element) mapper,
            Application<C, Element> stream);

    shared formal
    Application<C, Element> filter<Element>(
            Boolean(Element) predicate,
            Application<C, Element> stream);
}
