shared
interface Plus<Box> given Box<out E> {

    shared formal
    Box<A|B> plus<A, B>
            (Box<A> as, Box<B> bs);
}

shared
interface PlusOpsMixin<Box, out A, out Self>
        satisfies Wrapper<Box, A, Self, Plus>
        given Box<out E>
        given Self<C, El> given C<out E2> {

    shared default
    Self<Box, A|B> plus<B>(Box<B> bs)
        =>  wrap<A|B>(typeClass.plus(unwrapped, bs));
}
