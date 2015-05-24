shared
interface MonadPlus<Box>
        satisfies Monad<Box>
            & ApplicativePlus<Box>
            & Wrapping<MonadPlusWrapper, Box>
        given Box<out E> {

    shared actual default
    MonadPlusWrapper<Box, A> wrap<A>
            (Box<A> unwrapped)
            => let (uw = unwrapped) object
            satisfies MonadPlusWrapper<Box, A> {

        shared actual
        Box<A> unwrapped => uw;

        shared actual
        MonadPlus<Box> typeClass => outer;
    };
}

shared
interface MonadPlusOpsMixin<Box, A, out Self, out FSelf>
        satisfies Wrapper<Box, A, Self, FSelf>
            & MonadOpsMixin<Box, A, Self, FSelf>
            & PlusOpsMixin<Box, A, Self, FSelf>
        given FSelf<FSB>
            satisfies MonadPlus<FSB> & Wrapping<Self, FSB>
            given FSB<out FSBE>
        given Box<out E>
        given Self<SB, SE>
            given SB<out SBE> {}

shared
interface MonadPlusWrapper<Box, A>
        satisfies MonadWrapper<Box, A>
            & MonadPlusOpsMixin<Box, A, MonadPlusWrapper, MonadPlus>
        given Box<out E> {}
