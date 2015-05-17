shared
interface Applicative<Container>
        satisfies Functor<Container>
        given Container<out E> {

    shared formal
    Container<A> unit<A>(A element);

    shared formal
    Container<B> apply<A, B>(
            Container<A> container,
            Container<B(A)> f);
}
