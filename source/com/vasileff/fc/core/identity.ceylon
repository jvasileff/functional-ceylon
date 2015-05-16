shared
alias Identity<out T> => T;

shared
object identityTypeClass
        satisfies Monad<Identity> &
                  Foldable<Identity> {
    shared actual
    Out bind<In, Out>(In source, Out(In) apply)
        =>  apply(source);

    shared actual
    Out unit<Out>(Out element)
        =>  element;

    shared actual
    Result foldLeft<Result, Element>
            (Identity<Element> source, Result initial)
            (Result(Result, Element) accumulating)
        =>  accumulating(initial, source);
}

shared
Functor<Identity> identityFunctor = identityTypeClass;

shared
Monad<Identity> identityMonad = identityTypeClass;

shared
Foldable<Identity> identityFoldable = identityTypeClass;

shared
class IdentityEqual<Element>
        (Equal<Element> elementEqual)
        satisfies Equal<Identity<Element>> {

    shared actual
    Boolean equal(Element x, Element y)
        =>  elementEqual.equal(x, y);
}

shared
class IdentityCompare<Element>
        (Compare<Element> elementCompare)
        satisfies Compare<Identity<Element>> {

    shared actual
    Comparison compare(Element x, Element y)
        =>  elementCompare.compare(x, y);
}
