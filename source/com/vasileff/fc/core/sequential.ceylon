import ceylon.language {
    emptySequence = empty
}

shared
class SequentialMonoid<A>()
        satisfies Monoid<Sequential<A>> {

    shared actual
    Empty zero = [];

    shared actual
    Sequential<A> append([A*] xs, [A*] ys)
        =>  xs.append(ys);
}

shared
object sequentialTypeClass
        satisfies FoldableMonadPlus<Sequential> {

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
    B foldMap<A, B>
            (Monoid<B> monoid, Sequential<A> source)
            (B(A) mapping)
        =>  source.fold(monoid.zero)((a, b)
            =>  monoid.append(a, mapping(b)));

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

    shared actual
    [B*]([A*]) lift<A, B>(B(A) f)
        // FIXME this refinement shouldn't be necessary!
        // Wasn't fixed by https://github.com/ceylon/ceylon-js/issues/583
        =>  shuffle(curry(map<A,B>))(f);
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
