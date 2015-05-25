import com.vasileff.fc.core {
    FoldableMonad
}

shared
object bounceTypeClass
        satisfies FoldableMonad<Bounce> {

    shared actual
    Bounce<A> unit<A>(A element)
        =>  Return(element);

    shared actual
    Bounce<B> bind<A, B>
            (Bounce<A> source,
            Bounce<B>(A) apply)
        =>  source.flatMap(apply);

    shared actual
    Bounce<B> apply<A, B>(Bounce<A> container, Bounce<B(A)> f)
        =>  f.flatMap((B(A) f)
            =>  container.map((A element)
                =>  f(element)));

    shared actual
    B foldLeft<A, B>
            (Bounce<A> source, B initial)
            (B(B, A) accumulating)
        =>  accumulating(initial, source.result);
}
