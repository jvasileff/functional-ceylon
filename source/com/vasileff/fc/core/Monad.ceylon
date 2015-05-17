shared
interface Monad<Container>
        satisfies Applicative<Container>
        given Container<out E> {

    shared formal
    Container<B> bind<A, B>(Container<A> source, Container<B>(A) apply);

    shared actual default
    Container<B> map<A, B>(Container<A> source, B(A) apply)
        // TODO use compose after https://github.com/ceylon/ceylon-js/issues/553
        //=>  bind(source, compose(unit<B>, apply));
        =>  bind<A, B>(source, (x) => unit(apply(x)));

    shared default
    Container<A> join<A>(Container<Container<A>> source)
        =>  bind<Container<A>, A>(source, identity);
}
