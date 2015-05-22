shared
interface MonadPlus<Box>
        satisfies Monad<Box> &
                  ApplicativePlus<Box>
        given Box<out E> {

    shared actual default
    MonadPlusWrapper<Box, A> wrap<A>(Box<A> unwrapped)
        =>  let (tc = this, uw = unwrapped)
            object satisfies MonadPlusWrapper<Box, A> {

        shared actual
        MonadPlus<Box> typeClass => tc;

        shared actual
        Box<A> unwrapped => uw;

        shared actual
        MonadPlusWrapper<Box, E> wrap<E>(Box<E> wrapped)
            =>  outer.wrap(wrapped);
    };
}

shared
interface MonadPlusOpsMixin<Box, out A, Self>
        satisfies Wrapper<Box, A, Self, MonadPlus>
            & MonadOpsMixin<Box, A, Self>
            & PlusOpsMixin<Box, A, Self>
        given Box<out E>
        given Self<C, El> given C<out E2> {}

shared
interface MonadPlusWrapper<Box, out A>
        satisfies MonadWrapper<Box, A>
            & MonadOpsMixin<Box, A, MonadPlusWrapper>
        given Box<out E> {}
