shared
interface Monad<M> satisfies Functor<M> given M<out E> {

    shared formal
    M<Out> unit<Out>(Out element);

    shared formal
    M<Out> bind<In, Out>(M<In> source, M<Out>(In) apply);

    shared actual default
    M<Out> map<In, Out>(M<In> source, Out(In) apply)
        // TODO use compose after https://github.com/ceylon/ceylon-js/issues/553
        //=>  bind(source, compose(unit<Out>, apply));
        =>  bind<In, Out>(source, (x) => unit(apply(x)));

    shared default
    M<Out> join<Out>(M<M<Out>> source)
        =>  bind<M<Out>, Out>(source, identity);
}
