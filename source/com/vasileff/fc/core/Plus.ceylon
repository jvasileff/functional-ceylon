shared
interface Plus<Container> given Container<out E> {

    shared formal
    Container<A|B> plus<A, B>
            (Container<A> as, Container<B> bs);
}
