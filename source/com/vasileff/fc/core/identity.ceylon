shared
alias Identity<out T> => T;

shared
object identityTypeClass
        satisfies Monad<Identity>
            & Foldable<Identity> {

    shared actual
    B bind<A, B>(A source, B(A) apply)
        =>  apply(source);

    shared actual
    A unit<A>(A element)
        =>  element;

    shared actual
    B foldLeft<A, B>
            (A source, B initial)
            (B(B, A) accumulating)
        =>  accumulating(initial, source);

    shared actual
    B apply<A, B>(A container, B(A) f)
        =>  f(container);
}

shared
class IdentityEqual<Element>
        (Equal<Element> elementEqual)
        satisfies Equal<Identity<Element>> {

    shared actual
    Boolean equal(Element e1, Element e2)
        =>  elementEqual.equal(e1, e2);
}

shared
class IdentityCompare<Element>
        (Compare<Element> elementCompare)
        satisfies Compare<Identity<Element>> {

    shared actual
    Comparison compare(Element e1, Element e2)
        =>  elementCompare.compare(e1, e2);
}
