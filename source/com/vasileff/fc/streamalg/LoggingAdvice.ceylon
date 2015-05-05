shared
class LoggingAdvice<E, C>(
        ExecStreamAlg<E, C> & StreamAlg<C> alg)
        satisfies StreamAlg<C> &
                  ExecStreamAlg<E, C> {

    // Stream Alg Methods
    shared actual
    Application<C, Result> map<T, Result>(
            Result(T) mapper,
            Application<C,T> stream)
        =>  alg.map((T element) {
                value mapped = mapper(element);
                print("map: ``element else "<null>"`` -> \
                      ``mapped else "<null>"``");
                return mapped;
            }, stream);

    shared actual
    Application<C, Element> source<Element>(
            {Element*} array)
        =>  alg.source(array);

    shared actual
    Application<C, Result> flatMap<Element, Result>(
            Application<C, Result>(Element) mapper,
            Application<C, Element> stream)
        =>  alg.flatMap(mapper, stream);

    shared actual
    Application<C, Element> filter<Element>(
            Boolean(Element) predicate,
            Application<C, Element> stream)
        =>  alg.filter(predicate, stream);

    //// Exec Alg Methods
    shared actual
    Application<E, Integer> count<T>
            (Application<C, T> stream) {
        print("counting...");
        return alg.count(stream);
    }

    shared actual
    Application<E,Element> reduce<Element>(
            Element partial,
            Element(Element, Element) accumulator,
            Application<C,Element> stream) => nothing;
}
