shared object pullAlgebra
        satisfies StreamAlgebra<Pull> &
                  ExecStreamAlgebra<Id, Pull> {

    shared actual
    Pull<Element> source<Element>({Element*} array) => object
            satisfies Pull<Element> {

        value delegate = array.iterator();

        shared actual
        Element|Finished next() => delegate.next();
    };

    shared actual
    Pull<Result> map<Element, Result>(
            Result(Element) mapper,
            Pull<Element> stream) => object
            satisfies Pull<Result> {

        shared actual
        Result|Finished next()
            =>  if (!is Finished t = stream.next())
                then mapper(t)
                else finished;
    };

    shared actual
    Pull<Element> filter<Element>(
            Boolean(Element) predicate,
            Pull<Element> stream) => object
            satisfies Pull<Element> {

        shared actual
        Element|Finished next() {
            while (!is Finished element = stream.next()) {
                if (predicate(element)) {
                    return element;
                }
            }
            return finished;
        }
    };

    shared actual
    Pull<Result> flatMap<Element, Result>(
            Pull<Result>(Element) f,
            Pull<Element> s)
        =>  nothing;

    shared actual
    Id<Integer> count<Element>(
            Pull<Element> stream) {

        variable value count = 0;
        while (!is Finished element = stream.next()) {
            count++;
        }
        return Id(count);
    }

    shared actual
    Id<Element> reduce<Element>(
            Element partial,
            Element(Element, Element) accumulator,
            Pull<Element> stream) => nothing;
}
