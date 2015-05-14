"Interface for push style streams"
shared
interface Push<Element>
        satisfies Application<PushType, Element> {
    shared formal
    void invoke(Consumer<Element> k);
}

shared
alias Consumer<Element> => Anything(Element);

"Marker interface for simulated type
 constructor polymorphism"
shared sealed
class PushType() {}

"Unsafe narrowing operation; safe by convention"
shared
Push<Element> narrowPush<Element>
        (Application<PushType, Element> application) {
    assert (is Push<Element> application);
    return application;
}
