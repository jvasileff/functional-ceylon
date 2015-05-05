"A singleton that works with our
 simulated type constructor polymorphism"
shared
class Id<Element>
        (shared Element element)
        satisfies Application<IdType, Element> {}

shared sealed
class IdType() {}

shared
Id<Type> narrowId<Type>
        (Application<IdType, Type> app) {
    assert (is Id<Type> app);
    return app;
}
