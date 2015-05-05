"Interface for push style streams"
shared
interface Push<Element>
        satisfies Application<PushType, Element> {
    shared formal
    void invoke(Consumer<Element> k);
}

shared
alias Consumer<T> => Anything(T);

"Marker interface for simulated type
 constructor polymorphism"
shared sealed
class PushType() {}

"Unsafe narrowing operation; safe by convention"
shared
Push<T> narrowPush<T>
        (Application<PushType, T> application) {
    assert (is Push<T> application);
    return application;
}
