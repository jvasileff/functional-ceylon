shared
interface MonadPlus<Box>
        satisfies Monad<Box>
            & ApplicativePlus<Box>
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

        shared actual
        MonadPlusWrapper<Box, E> wrap<E>(Box<E> wrapped)
            =>  outer.wrap<E>(wrapped);
    };
}

shared
interface MonadPlusOpsMixin<Box, A, Self>
        satisfies Wrapper<Box, A, Self, MonadPlus>
            & MonadOpsMixin<Box, A, Self>
            & PlusOpsMixin<Box, A, Self>
        given Box<out E>
        given Self<C, El> given C<out E2> {}

shared
interface MonadPlusWrapper<Box, A>
        satisfies MonadWrapper<Box, A>
            & MonadPlusOpsMixin<Box, A, MonadPlusWrapper>
        given Box<out E> {}
