import ceylon.language {
    emptySequence = empty
}

shared
object sequentialTypeClass
        satisfies Monad<Sequential> &
                  Foldable<Sequential> &
                  PlusEmpty<Sequential> {

    shared actual
    Sequential<B> bind<A, B>
            (Sequential<A> source,
            Sequential<B>(A) apply)
        =>  source.flatMap(apply).sequence();

    shared actual
    Sequential<A> unit<A>(A element)
        =>  Singleton(element);

    shared actual
    B foldLeft<A, B>
            (A[] source, B initial)
            (B(B, A) accumulating)
        =>  source.fold(initial)(accumulating);

    shared actual
    [Nothing*] empty
        =>  emptySequence;

    shared actual
    [<A|B>*] plus<A, B>([A*] as, [B*] bs)
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
    Boolean equal(Element[] e1, Element[] e2)
        =>  corresponding(e1, e2, elementEqual.equal);
}

shared
class SequentialCompare<Element>
        (Compare<Element> elementCompare)
        satisfies Compare<Sequential<Element>> {

    shared actual
    Comparison compare(Element[] e1, Element[] e2)
        =>  if (nonempty e1, nonempty e2) then (
                switch (c = elementCompare.compare(
                                e1.first, e2.first))
                case (equal) compare(e1.rest, e2.rest)
                else c)
            else if (nonempty e1) then larger
            else if (nonempty e2) then smaller
            else equal;
}
