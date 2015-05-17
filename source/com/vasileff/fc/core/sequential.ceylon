import ceylon.language {
    emptySequence = empty
}

shared
object sequentialTypeClass
        satisfies Monad<Sequential> &
                  Foldable<Sequential> &
                  PlusEmpty<Sequential> {

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

    shared actual
    Nothing[] empty
        =>  emptySequence;

    shared actual
    <A|B>[] plus<A, B>(A[] as, B[] bs)
        =>  as.append(bs);

    shared actual
    [B*] apply<A, B>([A*] container, [B(A)*] f)
        =>  f.flatMap((B(A) f)
            =>  container.map((A element)
                =>  f(element))).sequence();
}

shared
Functor<Sequential> sequentialFunctor = sequentialTypeClass;

shared
Monad<Sequential> sequentialMonad = sequentialTypeClass;

shared
Foldable<Sequential> sequentialFoldable = sequentialTypeClass;

shared
class SequentialEqual<Element>
        (Equal<Element> elementEqual)
        satisfies Equal<Sequential<Element>> {

    shared actual
    Boolean equal(Element[] xs, Element[] ys)
        =>  corresponding(xs, ys, elementEqual.equal);
}

shared
class SequentialOrder<Element>
        (Compare<Element> elementCompare)
        satisfies Compare<Sequential<Element>> {

    shared actual
    Comparison compare(Element[] xs, Element[] ys)
        =>  if (nonempty xs, nonempty ys) then (
                switch (c = elementCompare.compare(
                                xs.first, ys.first))
                case (equal) compare(xs.rest, ys.rest)
                else c)
            else if (nonempty xs) then larger
            else if (nonempty ys) then smaller
            else equal;
}
