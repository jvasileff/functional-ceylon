shared
alias CovariantArray<out A> => Array<out A>;

shared
object covariantArrayTypeClass
        satisfies FoldableMonadPlus<CovariantArray> {

    shared actual
    CovariantArray<B> bind<A, B>(
            CovariantArray<A> source,
            CovariantArray<B>(A) apply)
        =>  Array(source.flatMap(apply));

    shared actual
    CovariantArray<A> unit<A>(A element)
        =>  Array({element});

    shared actual
    B foldLeft<A, B>
            (CovariantArray<A> source, B initial)
            (B(B, A) accumulating)
        =>  source.fold(initial)(accumulating);

    shared actual
    B foldMap<A, B>
            (Monoid<B> monoid, CovariantArray<A> source)
            (B(A) mapping)
        =>  source.fold(monoid.zero)((a, b)
            =>  monoid.append(a, mapping(b)));

    shared actual
    CovariantArray<Nothing> empty
        =>  Array<Nothing>({});

    shared actual
    CovariantArray<A|B> plus<A, B>(
            CovariantArray<A> as,
            CovariantArray<B> bs)
        =>  Array<A|B>(as.chain(bs));

    shared actual
    CovariantArray<B> apply<A, B>(
            CovariantArray<A> container,
            CovariantArray<B(A)> f)
        =>  Array(f.flatMap((B(A) f)
            =>  container.map((A element)
                =>  f(element))));
}

shared
class ArrayMonoid<A>()
        satisfies Monoid<Array<A>> {

    shared actual
    Array<A> zero = Array<A>({});

    shared actual
    Array<A> append(Array<A> xs, Array<A> ys)
        =>  Array<A>(xs.chain(ys));
}

shared
class ArrayEqual<Element>
        (Equal<Element> elementEqual)
        satisfies Equal<Array<Element>> {

    shared actual
    Boolean equal(
            Array<Element> e1,
            Array<Element> e2)
        =>  corresponding(e1, e2, elementEqual.equal);
}

shared
class ArrayCompare<Element>
        (Compare<Element> elementCompare)
        satisfies Compare<Array<Element>> {

    shared actual
    Comparison compare(
            Array<Element> e1,
            Array<Element> e2)
        =>  if (exists result = zipPairs(e1, e2)
                .map(unflatten(elementCompare.compare))
                .find(not(equal.equals)))
            then result
            else e1.size <=> e2.size;
}
