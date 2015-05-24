shared
interface Applicative<Box>
        satisfies Functor<Box>
            & Wrapping<ApplicativeWrapper, Box>
        given Box<out E> {

    shared formal
    Box<A> unit<A>(A element);

    shared formal
    Box<B> apply<A, B>(
            Box<A> container,
            Box<B(A)> f);

    shared actual default
    ApplicativeWrapper<Box, A> wrap<A>
            (Box<A> unwrapped)
            => let (uw = unwrapped) object
            satisfies ApplicativeWrapper<Box, A> {

        shared actual
        Box<A> unwrapped => uw;

        shared actual
        Applicative<Box> typeClass => outer;
    };
}

shared
interface ApplicativeOpsMixin<Box, A, out Self, out FSelf>
        satisfies Wrapper<Box, A, Self, FSelf>
            & FunctorOpsMixin<Box, A, Self, FSelf>
        given FSelf<FSB>
            satisfies Applicative<FSB> & Wrapping<Self, FSB>
            given FSB<out FSBE>
        given Box<out E>
        given Self<SB, SE>
            given SB<out SBE> {

    shared default
    Self<Box, B> apply<B>(Box<B(A)> f)
        =>  typeClass.wrap<B>(typeClass.apply(unwrapped, f));
}

shared
interface ApplicativeWrapper<Box, A>
        satisfies FunctorWrapper<Box, A>
            & ApplicativeOpsMixin<Box, A, ApplicativeWrapper, Applicative>
        given Box<out E> {}
