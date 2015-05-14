shared class PullFactory()
        satisfies StreamAlg<PullType> &
                  ExecStreamAlg<IdType, PullType> {

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
            Application<PullType, Element> stream) => object
            satisfies Pull<Result> {

        value pullStream = narrowPull(stream);

        shared actual
        Result|Finished next()
            =>  if (!is Finished t = pullStream.next())
                then mapper(t)
                else finished;
    };

    shared actual
    Pull<Element> filter<Element>(
            Boolean(Element) predicate,
            Application<PullType, Element> stream) => object
            satisfies Pull<Element> {

        value pullStream = narrowPull(stream);

        shared actual
        Element|Finished next() {
            while (!is Finished element = pullStream.next()) {
                if (predicate(element)) {
                    return element;
                }
            }
            return finished;
        }
    };

    shared actual
    Pull<Result> flatMap<Element, Result>(
            Application<PullType, Result>(Element) f,
            Application<PullType, Element> s)
        =>  nothing;

    shared actual
    Id<Integer> count<Element>(
            Application<PullType, Element> stream) {
        value pullStream = narrowPull(stream);
        variable value count = 0;
        while (!is Finished element = pullStream.next()) {
            count++;
        }
        return Id(count);
    }

    shared actual
    Application<IdType, Element> reduce<Element>(
            Element partial,
            Element(Element, Element) accumulator,
            Application<PullType, Element> stream) => nothing;
}
