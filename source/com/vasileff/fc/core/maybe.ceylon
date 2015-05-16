shared
alias Maybe<out T> => T?;

shared
object maybeTypeClass satisfies Monad<Maybe> & Foldable<Maybe> {
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
