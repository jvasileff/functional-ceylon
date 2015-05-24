shared
interface Plus<Box>
        given Box<out E> {

    shared formal
    Box<A|B> plus<A, B>
            (Box<A> as, Box<B> bs);
}

shared
interface PlusOpsMixin<Box, out A, out Self, out FSelf>
        satisfies Wrapper<Box, A, Self, FSelf>
        given FSelf<FSB>
            satisfies Plus<FSB> & Wrapping<Self, FSB>
            given FSB<out FSBE>
        given Box<out E>
        given Self<SB, SE>
            given SB<out SBE> {

    shared default
    Self<Box, A|B> plus<B>(Box<B> bs)
        =>  typeClass.wrap<A|B>(typeClass.plus(unwrapped, bs));
}
