shared
object pushAlgebra
        satisfies StreamAlgebra<Push> &
                  ExecStreamAlgebra<Id, Push> {

    shared actual
    Push<Element> source<Element>({Element*} array) => object
            satisfies Push<Element> {

        shared actual
        void invoke(Anything(Element) k)
            =>  array.each((e) => k(e));
    };

    shared actual
    Push<Result> map<Element, Result>(
            Result(Element) mapper,
            Push<Element> stream) => object
            satisfies Push<Result> {

        shared actual
        void invoke(Anything(Result) k)
            =>  stream.invoke((element)
                =>  k(mapper(element)));
    };

    shared actual
    Push<Element> filter<Element>(
            Boolean(Element) predicate,
            Push<Element> stream) => object
            satisfies Push<Element> {

        shared actual
        void invoke(Anything(Element) k) {
            stream.invoke(void(e) {
                if (predicate(e)) {
                    k(e);
                }
            });
        }
    };

    shared actual
    Push<Result> flatMap<Element, Result>(
            Push<Result>(Element) mapper,
            Push<Element> stream)
        =>  nothing;

    shared actual
    Integer count<Element>(
            Push<Element> stream) {

        variable value result = 0;
        stream.invoke((e) => result++);
        return result;
    }

    shared actual
    Element reduce<Element>(
            Element identity,
            Element(Element, Element) accumulator,
            Push<Element> stream) => nothing;
}
