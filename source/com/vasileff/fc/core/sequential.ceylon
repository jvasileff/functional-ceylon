shared
object sequentialTypeClass
        satisfies Monad<Sequential> &
                  Foldable<Sequential> {
    shared actual
    Sequential<Out> bind<In, Out>
            (Sequential<In> source,
            Sequential<Out>(In) apply)
        =>  source.flatMap(apply).sequence();

    shared actual
    Sequential<Out> unit<Out>(Out element)
        =>  Singleton(element);

    shared actual
    Result foldLeft<Result, Element>
            (Element[] source, Result initial)
            (Result(Result, Element) accumulating)
        =>  source.fold(initial)(accumulating);
}

shared
Functor<Sequential> sequentialFunctor = sequentialTypeClass;

shared
Monad<Sequential> sequentialMonad = sequentialTypeClass;

shared
Foldable<Sequential> sequentialFoldable = sequentialTypeClass;
