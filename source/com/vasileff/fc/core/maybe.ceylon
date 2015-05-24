shared
alias Maybe<out T> => T?;

shared
object maybeTypeClass
        satisfies FoldableMonad<Maybe> {

    shared actual
    B? bind<A, B>(A? source, B?(A) apply)
        =>  if (exists source)
            then apply(source)
            else null;

    shared actual
    A unit<A>(A element)
        =>  element;

    shared actual
    B foldLeft<A, B>
            (A? source, B initial)
            (B(B, A) accumulating)
        =>  if (exists source)
            then accumulating(initial, source)
            else initial;

    shared actual
    B? apply<A, B>(A? container, B(A)? f)
        =>  if (exists container, exists f)
            then f(container)
            else null;
}

shared
class MaybeEqual<Element>
        (Equal<Element> elementEqual)
        satisfies Equal<Maybe<Element>> {

    shared actual
    Boolean equal(Element? e1, Element? e2)
        =>  if (exists e1, exists e2)
            then elementEqual.equal(e1, e2)
            else !e1 exists && !e2 exists;
}

shared
class MaybeCompare<Element>
        (Compare<Element> elementCompare)
        satisfies Compare<Maybe<Element>> {

    shared actual
    Comparison compare(Element? e1, Element? e2)
        =>  if (exists e1, exists e2) then
                elementCompare.compare(e1, e2)
            else if (exists e1) then larger
            else if (exists e2) then smaller
            else equal;
}
