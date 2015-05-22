import ceylon.language {
    emptySequence = empty
}

shared
object sequentialTypeClass
        satisfies MonadPlus<Sequential> &
                  Foldable<Sequential> {

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

    // TODO FoldableMonadPlus interface w/this as `foldableWrapper`?
    shared
    FoldableMonadPlusWrapper<Sequential, A> foldableWrapper<A>
            (Sequential<A> unwrapped)
        =>  let (tc = this, uw = unwrapped)
            object satisfies FoldableMonadPlusWrapper<Sequential, A> {

        shared actual
        Foldable<Sequential> &
            MonadPlus<Sequential> typeClass => tc;

        shared actual
        Sequential<A> unwrapped => uw;

        shared actual
        FoldableMonadPlusWrapper<Sequential, E> wrap<E>
                (Sequential<E> wrapped)
            =>  outer.foldableWrapper(wrapped);
    };
}

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
