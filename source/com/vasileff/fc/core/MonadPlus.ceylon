shared
interface MonadPlus<Box>
        satisfies Monad<Box>
            & ApplicativePlus<Box>
        given Box<out E> {

    // TODO consider reverting to using an anonymous class
    // after https://github.com/ceylon/ceylon-spec/issues/1310
    shared actual default
    MonadPlusWrapper<Box, A> wrap<A>
            (Box<A> unwrapped)
        =>  MonadPlusWrapperImpl<Box, A>
                (this, unwrapped);
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

class MonadPlusWrapperImpl<Box, A>(
        shared actual MonadPlus<Box> typeClass,
        shared actual Box<A> unwrapped)
        satisfies MonadPlusWrapper<Box, A>
        given Box<out E> {

    shared actual
    MonadPlusWrapper<Box, E> wrap<E>(Box<E> wrapped)
        =>  MonadPlusWrapperImpl<Box, E>(typeClass, wrapped);
}
