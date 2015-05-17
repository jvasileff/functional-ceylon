shared
interface Functor<Container> given Container<out E> {

    shared formal
    Container<B> map<A, B>(Container<A> source, B(A) f);

    shared default
    Container<B>(Container<A>) lift<A, B>(B(A) f)
        =>  shuffle(curry(map<A,B>))(f);
}
