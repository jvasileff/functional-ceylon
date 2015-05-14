"Interface for pull style streams"
shared
interface Pull<out Element>
        satisfies Iterator<Element> &
                  Application<PullType, Element> {}

"Marker interface for simulated type
 constructor polymorphism"
shared sealed
class PullType() {}

"Unsafe narrowing operation; safe by convention"
shared
Pull<Element> narrowPull<Element>
        (Application<PullType, Element> app) {
    assert (is Pull<Element> app);
    return app;
}
