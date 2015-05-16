shared
interface Functor<F> given F<out E> {
    shared formal
    F<Out> map<In, Out>(F<In> source, Out(In) apply);

    shared default
    F<Out>(F<In>) lift<In, Out>(Out(In) apply)
        =>  shuffle(curry(map<In,Out>))(apply);
}
