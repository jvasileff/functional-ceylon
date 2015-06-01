shared
interface Monad<Box>
        satisfies Applicative<Box>
            & Wrapping<MonadWrapper, Box>
        given Box<out E> {

    shared formal
    Box<B> bind<A, B>(Box<A> source, Box<B>(A) apply);

    shared actual default
    Box<B> map<A, B>(Box<A> source, B(A) apply)
        // FIXME https://github.com/ceylon/ceylon.language/issues/699
        //=>  bind(source, compose(unit<B>, apply));
        =>  bind(source, (A a) => unit(apply(a)));

    shared default
    Box<A> join<A>(Box<Box<A>> source)
        // FIXME JavaScript bug; see [[flattenExample]]
        // affects non-Sequentials, so probably not the same as
        // https://github.com/ceylon/ceylon-js/issues/568
        //=>  bind<Box<A>, A>(source, identity<Box<A>>);
        =>  bind<Box<A>, A>(source, (Box<A> a) => a);

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
