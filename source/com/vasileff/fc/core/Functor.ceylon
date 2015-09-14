shared
interface Functor<Box>
        satisfies Wrapping<FunctorWrapper, Box>
        given Box<out E> {

    shared formal
    Box<B> map<A, B>(Box<A> source, B(A) f);

    shared default
    Box<B>(Box<A>) lift<A, B>(B(A) f)
        =>  shuffle(curry(map<A,B>))(f);

    shared default actual
    FunctorWrapper<Box, A> wrap<A>
            (Box<A> unwrapped)
            => let (uw = unwrapped) object
            satisfies FunctorWrapper<Box, A> {

        shared actual
        Box<A> unwrapped => uw;

        shared actual
        Functor<Box> typeClass => outer;
    };
}

shared
interface FunctorOpsMixin<Box, out A, out Self, out FunctorSelf>
        satisfies Wrapper<Box, A, Self, FunctorSelf>
        given FunctorSelf<FSB>
            satisfies Functor<FSB> & Wrapping<Self, FSB>
            given FSB<out FSBE>
        given Box<out E>
        given Self<SB, SE>
            given SB<out SBE> {

    shared default
    Self<Box, B> map<B>(B(A) f)
        =>  typeClass.wrap<B>(typeClass.map(unwrapped, f));
}

shared
interface FunctorWrapper<Box, out A>
        satisfies FunctorOpsMixin<Box, A, FunctorWrapper, Functor>
        given Box<out E> {}
