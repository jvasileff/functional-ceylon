shared
class LoggingAdvice<E, C>(
        ExecStreamAlgebra<E, C> & StreamAlgebra<C> alg)
        satisfies StreamAlgebra<C> &
                  ExecStreamAlgebra<E, C>
        given E<E>
        given C<E> {

    // Stream Alg Methods
    shared actual
    C<Result> map<Element, Result>(
            Result(Element) mapper,
            C<Element> stream)
        =>  alg.map((Element element) {
                value mapped = mapper(element);
                print("map: ``element else "<null>"`` -> \
                      ``mapped else "<null>"``");
                return mapped;
            }, stream);

    shared actual
    C<Element> source<Element>(
            {Element*} array)
        =>  alg.source(array);

    shared actual
    C<Result> flatMap<Element, Result>(
            C<Result>(Element) mapper,
            C<Element> stream)
        =>  alg.flatMap(mapper, stream);

    shared actual
    C<Element> filter<Element>(
            Boolean(Element) predicate,
            C<Element> stream)
        =>  alg.filter(predicate, stream);

    //// Exec Alg Methods
    shared actual
    E<Integer> count<T>
            (C<T> stream) {
        print("counting...");
        return alg.count(stream);
    }

    shared actual
    E<Element> reduce<Element>(
            Element partial,
            Element(Element, Element) accumulator,
            C<Element> stream) => nothing;
}
