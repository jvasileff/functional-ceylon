shared
class PushFactory()
        satisfies StreamAlg<PushType> &
        ExecStreamAlg<IdType, PushType> {

    shared actual
    Push<T> source<T>({T*} array) => object
            satisfies Push<T> {

        shared actual
        void invoke(Consumer<T> k)
            =>  array.each((e) => k(e));
    };

    shared actual
    Push<Result> map<Element, Result>(
            Result(Element) mapper,
            Application<PushType, Element> stream) => object
            satisfies Push<Result> {

        value pushStream = narrowPush(stream);

        shared actual
        void invoke(Consumer<Result> k)
            =>  pushStream.invoke((element)
                =>  k(mapper(element)));
    };

    shared actual
    Push<Element> filter<Element>(
            Boolean(Element) predicate,
            Application<PushType, Element> stream) => object
            satisfies Push<Element> {

        value pushStream = narrowPush(stream);

        shared actual
        void invoke(Consumer<Element> k) {
            pushStream.invoke(void(e) {
                if (predicate(e)) {
                    k(e);
                }
            });
        }
    };

    shared actual
    Push<Result> flatMap<Element, Result>(
            Application<PushType, Result>(Element) mapper,
            Application<PushType, Element> stream)
        =>  nothing;

    shared actual
    Id<Integer> count<Element>(
            Application<PushType, Element> stream) {

        value pushStream = narrowPush(stream);
        variable value result = 0;
        pushStream.invoke((e) => result++);
        return Id(result);
    }

    shared actual
    Application<IdType, Element> reduce<Element>(
            Element identity,
            Element(Element, Element) accumulator,
            Application<PushType, Element> stream) => nothing;
}
