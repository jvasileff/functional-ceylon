shared
interface Monad<Box>
        satisfies Applicative<Box>
            & Wrapping<MonadWrapper, Box>
        given Box<out E> {

    shared formal
    Box<B> bind<A, B>(Box<A> source, Box<B>(A) apply);

    shared actual default
    Box<B> map<A, B>(Box<A> source, B(A) apply)
        =>  bind(source, compose(unit<B>, apply));

    shared default
    Box<A> join<A>(Box<Box<A>> source)
        =>  bind<Box<A>, A>(source, identity<Box<A>>);

    shared actual default
    MonadWrapper<Box, A> wrap<A>
            (Box<A> unwrapped)
            => let (uw = unwrapped) object
            satisfies MonadWrapper<Box, A> {

        shared actual
        Box<A> unwrapped => uw;

        shared actual
        Monad<Box> typeClass => outer;
    };
}

shared
interface MonadOpsMixin<Box, A, out Self, out FSelf>
        satisfies Wrapper<Box, A, Self, FSelf>
            & ApplicativeOpsMixin<Box, A, Self, FSelf>
        given FSelf<FSB>
            satisfies Monad<FSB>
                & Wrapping<Self, FSB>
            given FSB<out FSBE>
        given Box<out E>
        given Self<SB, SE>
            given SB<out SBE> {

    shared default
    Self<Box, B> bind<B>(
            Box<B>(A) apply)
        =>  typeClass.wrap<B>(typeClass.bind(unwrapped, apply));
}

shared
interface MonadWrapper<Box, A>
        satisfies ApplicativeWrapper<Box, A>
            & MonadOpsMixin<Box, A, MonadWrapper, Monad>
        given Box<out BE> {}
