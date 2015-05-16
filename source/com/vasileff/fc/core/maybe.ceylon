shared
alias Maybe<out T> => T?;

shared
object maybeTypeClass
        satisfies Monad<Maybe> &
                  Foldable<Maybe> {

    shared actual
    Out? bind<In, Out>(In? source, Out?(In) apply)
        =>  if (exists source)
            then apply(source)
            else null;

    shared actual
    Out unit<Out>(Out element)
        =>  element;

    shared actual
    Result foldLeft<Result, Element>
            (Maybe<Element> source, Result initial)
            (Result(Result, Element) accumulating)
        =>  if (exists source)
            then accumulating(initial, source)
            else initial;
}

shared
Functor<Maybe> maybeFunctor = maybeTypeClass;

shared
Monad<Maybe> maybeMonad = maybeTypeClass;

shared
Foldable<Maybe> maybeFoldable = maybeTypeClass;

shared
class MaybeEqual<Element>
        (Equal<Element> elementEqual)
        satisfies Equal<Maybe<Element>> {

    shared actual
    Boolean equal(Element? x, Element? y)
        =>  if (exists x, exists y)
            then elementEqual.equal(x, y)
            else !x exists && !y exists;
}

shared
class MaybeCompare<Element>
        (Compare<Element> elementCompare)
        satisfies Compare<Maybe<Element>> {

    shared actual
    Comparison compare(Element? x, Element? y)
        =>  if (exists x, exists y) then
                elementCompare.compare(x, y)
            else if (exists x) then larger
            else if (exists y) then smaller
            else equal;
}
